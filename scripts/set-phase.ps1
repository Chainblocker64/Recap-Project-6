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

$stateFile = "$dir/state.json"

# Preserve any other fields already in state.json (e.g. review's reviewAttempts
# counter) instead of clobbering the whole file with just the phase.
$state = @{}
if (Test-Path $stateFile) {
    $existing = Get-Content $stateFile -Raw | ConvertFrom-Json
    foreach ($prop in $existing.PSObject.Properties) {
        $state[$prop.Name] = $prop.Value
    }
}

$state["phase"] = $Phase

($state | ConvertTo-Json) | Set-Content -Path $stateFile -Encoding utf8

Write-Host "[ok] ticket $Ticket phase set to '$Phase' (other fields preserved)"
