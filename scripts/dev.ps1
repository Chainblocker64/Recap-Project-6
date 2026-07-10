# Quick local launch: starts Postgres, applies migrations, runs the dev server.
# Usage: powershell -File scripts\dev.ps1

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "[error] uv not found on PATH - open a fresh terminal if it was just installed, or run scripts\check-prerequisites.ps1"
    exit 1
}

Write-Host "[dev] starting Postgres..."
docker compose up -d db
if ($LASTEXITCODE -ne 0) {
    Write-Host "[error] docker compose failed - is Docker Desktop running?"
    exit 1
}

Write-Host "[dev] waiting for Postgres to be healthy..."
$deadline = (Get-Date).AddSeconds(30)
do {
    $status = docker compose ps db --format json | ConvertFrom-Json
    $healthy = $status.Health -eq "healthy"
    if (-not $healthy) { Start-Sleep -Seconds 1 }
} while (-not $healthy -and (Get-Date) -lt $deadline)

if (-not $healthy) {
    Write-Host "[error] Postgres did not become healthy in time"
    exit 1
}

Write-Host "[dev] applying migrations..."
uv run python manage.py migrate
if ($LASTEXITCODE -ne 0) {
    exit 1
}

Write-Host "[dev] starting server at http://127.0.0.1:8000/ (Ctrl+C to stop)"
uv run python manage.py runserver
