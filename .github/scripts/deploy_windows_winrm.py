#!/usr/bin/env python3
import base64
import os
import pathlib
import sys
import uuid

import winrm


def require_env(name: str) -> str:
    value = os.getenv(name, "").strip()
    if not value:
        raise SystemExit(f"Missing required environment variable: {name}")
    return value


def optional_env(name: str, default: str) -> str:
    value = os.getenv(name, "").strip()
    return value if value else default


def ps_quote(value: str) -> str:
    return value.replace("'", "''")


def main() -> int:
    host = require_env("KK_DEPLOY_HOST")
    port = optional_env("KK_DEPLOY_PORT", "5985")
    username = require_env("KK_DEPLOY_USERNAME")
    password = require_env("KK_DEPLOY_PASSWORD")
    env_pairs = {
        "KK_DEPLOY_ROOT": optional_env("KK_DEPLOY_ROOT", r"C:\kkFileView-5.0"),
        "KK_DEPLOY_HEALTH_URL": optional_env("KK_DEPLOY_HEALTH_URL", "http://127.0.0.1:8012/"),
        "KK_DEPLOY_REPO_URL": optional_env("KK_DEPLOY_REPO_URL", "https://github.com/kekingcn/kkFileView.git"),
        "KK_DEPLOY_BRANCH": optional_env("KK_DEPLOY_BRANCH", "master"),
        "KK_DEPLOY_SOURCE_ROOT": optional_env("KK_DEPLOY_SOURCE_ROOT", r"C:\kkFileView-source"),
        "KK_DEPLOY_JAVA_HOME": optional_env("KK_DEPLOY_JAVA_HOME", r"C:\Program Files\jdk-21.0.2"),
        "KK_DEPLOY_GIT_EXE": optional_env("KK_DEPLOY_GIT_EXE", r"C:\kkFileView-tools\git\cmd\git.exe"),
        "KK_DEPLOY_MVN_CMD": optional_env("KK_DEPLOY_MVN_CMD", r"C:\kkFileView-tools\maven\bin\mvn.cmd"),
        "KK_DEPLOY_MAVEN_SETTINGS": optional_env("KK_DEPLOY_MAVEN_SETTINGS", ""),
        "KK_DEPLOY_DRY_RUN": optional_env("KK_DEPLOY_DRY_RUN", "false").lower(),
    }

    script_path = pathlib.Path(__file__).with_name("remote_windows_deploy.ps1")
    script_body = script_path.read_text(encoding="utf-8")
    payload = script_body.encode("utf-8-sig")
    payload_b64 = base64.b64encode(payload).decode("ascii")

    endpoint = f"http://{host}:{port}/wsman"
    session = winrm.Session(endpoint, auth=(username, password), transport="ntlm")

    suffix = uuid.uuid4().hex
    remote_b64_path = fr"C:\Windows\Temp\kkfileview_deploy_{suffix}.b64"
    remote_ps1_path = fr"C:\Windows\Temp\kkfileview_deploy_{suffix}.ps1"

    prep = session.run_ps(
        f"""
$ErrorActionPreference = 'Stop'
if (Test-Path '{ps_quote(remote_b64_path)}') {{ Remove-Item '{ps_quote(remote_b64_path)}' -Force }}
if (Test-Path '{ps_quote(remote_ps1_path)}') {{ Remove-Item '{ps_quote(remote_ps1_path)}' -Force }}
New-Item -ItemType File -Path '{ps_quote(remote_b64_path)}' -Force | Out-Null
"""
    )
    if prep.status_code != 0:
        sys.stderr.write(prep.std_err.decode("utf-8", errors="ignore"))
        return prep.status_code

    chunk_size = 1200
    for start in range(0, len(payload_b64), chunk_size):
        chunk = payload_b64[start : start + chunk_size]
        append = session.run_ps(
            f"Add-Content -LiteralPath '{ps_quote(remote_b64_path)}' -Value '{chunk}'"
        )
        if append.status_code != 0:
            sys.stderr.write(append.std_err.decode("utf-8", errors="ignore"))
            return append.status_code

    result = session.run_ps(
        f"""
$ErrorActionPreference = 'Stop'
$raw = Get-Content -LiteralPath '{ps_quote(remote_b64_path)}' -Raw
[System.IO.File]::WriteAllBytes('{ps_quote(remote_ps1_path)}', [Convert]::FromBase64String($raw))
try {{
"""
        + "\n".join(
            f"  $env:{key} = '{ps_quote(value)}'" for key, value in env_pairs.items()
        )
        + f"""
  powershell -NoProfile -ExecutionPolicy Bypass -File '{ps_quote(remote_ps1_path)}' `
  $code = $LASTEXITCODE
}} finally {{
"""
        + "\n".join(
            f"  Remove-Item Env:{key} -ErrorAction SilentlyContinue" for key in env_pairs
        )
        + f"""
  Remove-Item '{ps_quote(remote_b64_path)}' -Force -ErrorAction SilentlyContinue
  Remove-Item '{ps_quote(remote_ps1_path)}' -Force -ErrorAction SilentlyContinue
}}
exit $code
"""
    )

    stdout = result.std_out.decode("utf-8", errors="ignore").strip()
    stderr = result.std_err.decode("utf-8", errors="ignore").strip()

    if stdout:
        print(stdout)
    if stderr:
        print(stderr, file=sys.stderr)

    return result.status_code


if __name__ == "__main__":
    raise SystemExit(main())
