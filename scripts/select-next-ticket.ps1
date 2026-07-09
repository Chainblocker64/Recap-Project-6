# Finds the oldest open ticket in the "Todo" column of the Learning Companion
# project board and prints its issue number to stdout.
# Exits non-zero (no output) if there are no candidates.

$ProjectOwner = "Chainblocker64"
$ProjectNumber = 1

$raw = gh project item-list $ProjectNumber --owner $ProjectOwner --format json
if ($LASTEXITCODE -ne 0) {
    Write-Error "gh project item-list failed"
    exit 1
}

$items = ($raw | ConvertFrom-Json).items

$candidate = $items |
    Where-Object { $_.status -eq "Todo" -and $_.content.type -eq "Issue" } |
    Sort-Object { $_.content.number } |
    Select-Object -First 1

if (-not $candidate) {
    Write-Error "No open tickets in the Todo column."
    exit 1
}

Write-Output $candidate.content.number
