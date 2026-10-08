$ErrorActionPreference = 'Stop'
$Tokens = $null
$ParseErrors = $null
$ScriptPath = Join-Path $PSScriptRoot 'remote_windows_deploy.ps1'
$Ast = [System.Management.Automation.Language.Parser]::ParseFile($ScriptPath, [ref]$Tokens, [ref]$ParseErrors)
if ($ParseErrors.Count -gt 0) { throw ($ParseErrors | Out-String) }
foreach ($Name in @('Resolve-ActiveConfigPath', 'Set-SecureActuatorDefaults')) {
    $FunctionAst = $Ast.Find({ param($Node) $Node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $Node.Name -eq $Name }, $true)
    if (-not $FunctionAst) { throw "Missing function: $Name" }
    . ([scriptblock]::Create($FunctionAst.Extent.Text))
}

$TempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('kkfileview-deploy-test-' + [guid]::NewGuid().ToString('N'))
try {
    $Bin = New-Item -ItemType Directory -Path (Join-Path $TempRoot 'bin')
    $Config = New-Item -ItemType Directory -Path (Join-Path $TempRoot 'config')
    $ActiveFile = Join-Path $Config.FullName 'test.properties'
    $Utf8 = New-Object System.Text.UTF8Encoding($false)
    $Original = "# Preserve Unicode: 中文`r`ncustom.value = unchanged`r`nmanagement.endpoints.web.exposure.include = health,info,metrics`r`nmanagement.endpoint.health.show-details = always`r`n"
    [System.IO.File]::WriteAllText($ActiveFile, $Original, $Utf8)
    $Resolved = Resolve-ActiveConfigPath -CommandLines @('java -Dspring.config.location=..\config\test.properties -jar kkFileView-5.0.jar') -WorkingDirectory $Bin.FullName
    if ($Resolved -ne $ActiveFile) { throw 'Did not resolve the runtime configuration override' }
    Set-SecureActuatorDefaults -ConfigPath $Resolved
    $Expected = $Original.Replace('health,info,metrics', 'health').Replace('show-details = always', 'show-details = never')
    $Actual = [System.IO.File]::ReadAllText($Resolved, $Utf8)
    if ($Actual -cne $Expected) { throw 'Migration altered unrelated configuration or missed a security default' }
    Set-SecureActuatorDefaults -ConfigPath $Resolved
    if ([System.IO.File]::ReadAllText($Resolved, $Utf8) -cne $Expected) { throw 'Migration is not idempotent' }

    [System.IO.File]::WriteAllText($ActiveFile, 'custom.value = unchanged', $Utf8)
    Set-SecureActuatorDefaults -ConfigPath $ActiveFile
    $Actual = [System.IO.File]::ReadAllText($ActiveFile, $Utf8)
    if ($Actual -notmatch 'management.endpoints.web.exposure.include = health' -or $Actual -notmatch 'management.endpoint.health.show-details = never') {
        throw 'Missing properties were not added'
    }
    $Rejected = $false
    try { Resolve-ActiveConfigPath -CommandLines @('java -jar app.jar') -WorkingDirectory $Bin.FullName } catch { $Rejected = $true }
    if (-not $Rejected) { throw 'Unknown active configuration must fail closed' }
    Write-Host 'Windows deployment syntax and configuration migration tests passed'
} finally {
    if (Test-Path $TempRoot) { Remove-Item -LiteralPath $TempRoot -Recurse -Force }
}
