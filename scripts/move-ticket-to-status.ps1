# Moves the given issue's card to the given Status column on the Learning
# Companion project board. Safe to call even if the card is already there.

param(
    [Parameter(Mandatory = $true)]
    [int]$IssueNumber,

    [Parameter(Mandatory = $true)]
    [string]$Status
)

$ProjectOwner = "Chainblocker64"
$ProjectNumber = 1

$projectRaw = gh project view $ProjectNumber --owner $ProjectOwner --format json
if ($LASTEXITCODE -ne 0) {
    Write-Error "gh project view failed"
    exit 1
}
$projectId = ($projectRaw | ConvertFrom-Json).id

$fieldsRaw = gh project field-list $ProjectNumber --owner $ProjectOwner --format json
if ($LASTEXITCODE -ne 0) {
    Write-Error "gh project field-list failed"
    exit 1
}
$statusField = ($fieldsRaw | ConvertFrom-Json).fields | Where-Object { $_.name -eq "Status" }
$statusOption = $statusField.options | Where-Object { $_.name -eq $Status }
if (-not $statusOption) {
    $validOptions = ($statusField.options | ForEach-Object { $_.name }) -join ", "
    Write-Error "'$Status' is not a valid Status option. Valid options: $validOptions"
    exit 1
}

$itemsRaw = gh project item-list $ProjectNumber --owner $ProjectOwner --format json
if ($LASTEXITCODE -ne 0) {
    Write-Error "gh project item-list failed"
    exit 1
}
$item = ($itemsRaw | ConvertFrom-Json).items | Where-Object { $_.content.number -eq $IssueNumber }
if (-not $item) {
    Write-Error "Issue #$IssueNumber was not found on the project board."
    exit 1
}

gh project item-edit `
    --project-id $projectId `
    --id $item.id `
    --field-id $statusField.id `
    --single-select-option-id $statusOption.id | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Error "gh project item-edit failed"
    exit 1
}

Write-Output "Moved issue #$IssueNumber to $Status."
