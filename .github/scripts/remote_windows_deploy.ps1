$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message"
}

function Get-RequiredEnv {
    param([string]$Name)

    $Value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw "Missing required environment variable: $Name"
    }

    return $Value
}

function Get-OptionalEnv {
    param(
        [string]$Name,
        [string]$DefaultValue
    )

    $Value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $DefaultValue
    }

    return $Value
}

$DeployRoot = Get-OptionalEnv 'KK_DEPLOY_ROOT' 'C:\kkFileView-5.0'
$HealthUrl = Get-OptionalEnv 'KK_DEPLOY_HEALTH_URL' 'http://127.0.0.1:8012/'
$RepoUrl = Get-OptionalEnv 'KK_DEPLOY_REPO_URL' 'https://github.com/kekingcn/kkFileView.git'
$Branch = Get-OptionalEnv 'KK_DEPLOY_BRANCH' 'master'
$SourceRoot = Get-OptionalEnv 'KK_DEPLOY_SOURCE_ROOT' 'C:\kkFileView-source'
$JavaHome = Get-OptionalEnv 'KK_DEPLOY_JAVA_HOME' 'C:\Program Files\jdk-21.0.2'
$GitExe = Get-OptionalEnv 'KK_DEPLOY_GIT_EXE' 'C:\kkFileView-tools\git\cmd\git.exe'
$MvnCmd = Get-OptionalEnv 'KK_DEPLOY_MVN_CMD' 'C:\kkFileView-tools\maven\bin\mvn.cmd'
$MavenSettings = Get-OptionalEnv 'KK_DEPLOY_MAVEN_SETTINGS' ''
$DryRun = Get-OptionalEnv 'KK_DEPLOY_DRY_RUN' 'false'

$BinDir = Join-Path $DeployRoot 'bin'
$StartupScript = Join-Path $BinDir 'startup.bat'
$ReleaseDir = Join-Path $DeployRoot 'releases'
$DeployTmp = Join-Path $DeployRoot 'deploy-tmp'
$BuildOutputDir = Join-Path (Join-Path $SourceRoot 'server') 'target'

if (-not (Test-Path $DeployRoot)) {
    throw "Deploy root not found: $DeployRoot"
}

if (-not (Test-Path $BinDir)) {
    throw "Bin directory not found: $BinDir"
}

if (-not (Test-Path $StartupScript)) {
    throw "Startup script not found: $StartupScript"
}

$CurrentJar = Get-ChildItem $BinDir -Filter 'kkFileView-*.jar' | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $CurrentJar) {
    throw "No kkFileView jar found in $BinDir"
}

$JavaExe = Join-Path $JavaHome 'bin\java.exe'
if (-not (Test-Path $JavaExe)) {
    throw "JDK 21 java executable not found: $JavaExe"
}

if (-not (Test-Path $GitExe)) {
    throw "Git executable not found: $GitExe"
}

if (-not (Test-Path $MvnCmd)) {
    throw "Maven executable not found: $MvnCmd"
}

if (-not [string]::IsNullOrWhiteSpace($MavenSettings) -and -not (Test-Path $MavenSettings)) {
    throw "Maven settings file not found: $MavenSettings"
}

$JarName = $CurrentJar.Name
$JarPath = $CurrentJar.FullName

Write-Step "Deploy root: $DeployRoot"
Write-Step "Current jar: $JarPath"
Write-Step "Startup script: $StartupScript"
Write-Step "Health url: $HealthUrl"
Write-Step "Source root: $SourceRoot"
Write-Step "Branch: $Branch"
Write-Step "Git exe: $GitExe"
Write-Step "Maven cmd: $MvnCmd"
Write-Step "Java home: $JavaHome"
if (-not [string]::IsNullOrWhiteSpace($MavenSettings)) {
    Write-Step "Maven settings: $MavenSettings"
}

function Invoke-External {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$WorkingDirectory = $null
    )

    $previous = $null
    if ($WorkingDirectory) {
        $previous = Get-Location
        Set-Location $WorkingDirectory
    }

    try {
        & $FilePath @Arguments
        if ($LASTEXITCODE -ne 0) {
            throw "Command failed ($LASTEXITCODE): $FilePath $($Arguments -join ' ')"
        }
    } finally {
        if ($previous) {
            Set-Location $previous
        }
    }
}

function Assert-SafeSourceRoot {
    param([string]$PathToCheck)

    $FullPath = [System.IO.Path]::GetFullPath($PathToCheck)
    $RootPath = [System.IO.Path]::GetPathRoot($FullPath)
    if ($FullPath.TrimEnd('\') -eq $RootPath.TrimEnd('\')) {
        throw "Refusing to use drive root as source root: $FullPath"
    }

    $DangerousLeafNames = @(
        'Windows',
        'Users',
        'Program Files',
        'Program Files (x86)',
        'ProgramData'
    )
    $LeafName = Split-Path -Leaf $FullPath.TrimEnd('\')
    if ($DangerousLeafNames -contains $LeafName) {
        throw "Refusing to use a high-risk source root path: $FullPath"
    }
}

$env:JAVA_HOME = $JavaHome
$env:Path = (Join-Path $JavaHome 'bin') + ';' + (Split-Path -Parent $GitExe) + ';' + (Split-Path -Parent $MvnCmd) + ';' + $env:Path

Write-Step 'Validating Git executable'
Invoke-External -FilePath $GitExe -Arguments @('--version')

Write-Step 'Validating Maven executable'
$MavenVersionArgs = @('-version')
if (-not [string]::IsNullOrWhiteSpace($MavenSettings)) {
    $MavenVersionArgs = @('-s', $MavenSettings, '-version')
}
Invoke-External -FilePath $MvnCmd -Arguments $MavenVersionArgs

if ($DryRun -eq 'true') {
    Write-Step "Dry run enabled, remote validation finished"
    return
}

New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null
New-Item -ItemType Directory -Force -Path $DeployTmp | Out-Null

function Sync-Repository {
    Assert-SafeSourceRoot -PathToCheck $SourceRoot

    if (-not (Test-Path (Join-Path $SourceRoot '.git'))) {
        if (Test-Path $SourceRoot) {
            Remove-Item $SourceRoot -Recurse -Force
        }

        $parent = Split-Path -Parent $SourceRoot
        if ($parent) {
            New-Item -ItemType Directory -Force -Path $parent | Out-Null
        }

        Write-Step "Cloning repository from $RepoUrl"
        Invoke-External -FilePath $GitExe -Arguments @('clone', '--depth', '1', '--branch', $Branch, '--single-branch', $RepoUrl, $SourceRoot)
        return
    }

    Write-Step "Fetching latest branch state from origin/$Branch"
    Invoke-External -FilePath $GitExe -Arguments @('remote', 'set-url', 'origin', $RepoUrl) -WorkingDirectory $SourceRoot
    Invoke-External -FilePath $GitExe -Arguments @('fetch', '--prune', '--depth', '1', 'origin', $Branch) -WorkingDirectory $SourceRoot
    Invoke-External -FilePath $GitExe -Arguments @('checkout', '-B', $Branch, "origin/$Branch") -WorkingDirectory $SourceRoot
    Invoke-External -FilePath $GitExe -Arguments @('reset', '--hard', "origin/$Branch") -WorkingDirectory $SourceRoot
    Invoke-External -FilePath $GitExe -Arguments @('clean', '-fd') -WorkingDirectory $SourceRoot
}

function Build-KkFileView {
    Write-Step 'Building kkFileView from source'
    $BuildArgs = @('-B', 'clean', 'package', '-Dmaven.test.skip=true', '--file', 'pom.xml')
    if (-not [string]::IsNullOrWhiteSpace($MavenSettings)) {
        $BuildArgs = @('-s', $MavenSettings) + $BuildArgs
    }
    Invoke-External -FilePath $MvnCmd -Arguments $BuildArgs -WorkingDirectory $SourceRoot
}

Sync-Repository
Build-KkFileView

$DownloadedJars = Get-ChildItem $BuildOutputDir -Filter 'kkFileView-*.jar' -File
if (-not $DownloadedJars) {
    throw "No kkFileView jar found in build output: $BuildOutputDir"
}

if ($DownloadedJars.Count -ne 1) {
    throw "Expected exactly one kkFileView jar in build output, found $($DownloadedJars.Count)"
}

$DownloadedJar = $DownloadedJars[0]

$Timestamp = Get-Date -Format 'yyyyMMddHHmmss'
$BackupJar = Join-Path $ReleaseDir ("{0}.{1}.bak" -f $JarName, $Timestamp)

function Stop-KkFileView {
    foreach ($Process in @(Get-KkFileViewJavaProcesses) + @(Get-KkFileViewLauncherProcesses)) {
        Write-Step "Stopping process $($Process.ProcessId)"
        Stop-Process -Id $Process.ProcessId -Force -ErrorAction SilentlyContinue
    }
}

function Get-KkFileViewJavaProcesses {
    $JarPattern = [regex]::Escape($JarName)
    return Get-CimInstance Win32_Process | Where-Object {
        $_.Name -match '^java(\.exe)?$' -and $_.CommandLine -and $_.CommandLine -match $JarPattern
    }
}

function Get-KkFileViewLauncherProcesses {
    $StartupPattern = [regex]::Escape([System.IO.Path]::GetFileName($StartupScript))
    return Get-CimInstance Win32_Process | Where-Object {
        $_.Name -ieq 'cmd.exe' -and $_.CommandLine -and $_.CommandLine -match $StartupPattern
    }
}

function Wait-KkFileViewStopped {
    param([int]$TimeoutSeconds = 30)

    for ($i = 0; $i -lt $TimeoutSeconds; $i++) {
        $JavaProcesses = @(Get-KkFileViewJavaProcesses)
        $CmdProcesses = @(Get-KkFileViewLauncherProcesses)
        if ((@($JavaProcesses).Count + @($CmdProcesses).Count) -eq 0) {
            return $true
        }

        Start-Sleep -Seconds 1
    }

    return $false
}

function Start-KkFileView {
    Write-Step "Starting kkFileView"
    $CreateResult = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{
        CommandLine = ('cmd.exe /c ""' + $StartupScript + '""')
        CurrentDirectory = $BinDir
    }

    if ($CreateResult.ReturnValue -ne 0) {
        throw "Failed to start kkFileView launcher, Win32_Process.Create returned $($CreateResult.ReturnValue)"
    }

    Write-Step "Launcher process created with pid $($CreateResult.ProcessId)"
}

function Wait-Health {
    param([string]$Url)

    $SuccessfulChecks = 0
    for ($i = 0; $i -lt 24; $i++) {
        Start-Sleep -Seconds 5
        try {
            $Response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
            if ($Response.StatusCode -eq 200 -and @(Get-KkFileViewJavaProcesses).Count -gt 0) {
                $SuccessfulChecks++
            } else {
                $SuccessfulChecks = 0
            }

            if ($SuccessfulChecks -ge 3) {
                return $true
            }
        } catch {
            $SuccessfulChecks = 0
            Start-Sleep -Milliseconds 200
        }
    }

    return $false
}

Write-Step "Backing up current jar to $BackupJar"
Copy-Item $JarPath $BackupJar -Force

Stop-KkFileView
if (-not (Wait-KkFileViewStopped)) {
    throw "Timed out waiting for the previous kkFileView process to exit"
}

Write-Step "Replacing jar with artifact output"
Copy-Item $DownloadedJar.FullName $JarPath -Force

Start-KkFileView

if (-not (Wait-Health -Url $HealthUrl)) {
    Write-Step "Health check failed, rolling back"
    Stop-KkFileView
    if (-not (Wait-KkFileViewStopped)) {
        throw "Timed out waiting for the failed kkFileView process to exit during rollback"
    }
    Copy-Item $BackupJar $JarPath -Force
    Start-KkFileView

    if (-not (Wait-Health -Url $HealthUrl)) {
        throw "Deployment failed and rollback health check also failed"
    }

    throw "Deployment failed, rollback completed successfully"
}

Write-Step "Deployment completed successfully"
