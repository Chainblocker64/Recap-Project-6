# Records which workflow phase a ticket is currently on, so work-ticket can
# recognize it as in progress and resume it correctly on a later run.
# Usage: powershell -File scripts/set-phase.ps1 -Ticket <number> -Phase <name>

param(
    [Parameter(Mandatory = $true)]
    [int]$Ticket,

    [Parameter(Mandatory = $true)]
    [string]$Phase
)

$dir = "work/$Ticket"
if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
}

$state = @{ phase = $Phase } | ConvertTo-Json
Set-Content -Path "$dir/state.json" -Value $state -Encoding utf8

Write-Host "[ok] ticket $Ticket phase set to '$Phase'"
