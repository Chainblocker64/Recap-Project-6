# Checks and installs the external CLI tools required by this project's workflow skills.
# Add an entry to $Prerequisites whenever a skill starts depending on a new tool.
# Windows-only for now (winget) - add per-OS install commands here if this ever
# needs to run on macOS/Linux.

$Prerequisites = @(
    @{
        Name    = "gh"
        Check   = { Get-Command gh -ErrorAction SilentlyContinue }
        Install = { winget install --id GitHub.cli -e }
    }
)

$allOk = $true

foreach ($tool in $Prerequisites) {
    if (& $tool.Check) {
        Write-Host "[ok] $($tool.Name) is installed"
    } else {
        Write-Host "[missing] $($tool.Name) not found - installing..."
        & $tool.Install
        if (-not (& $tool.Check)) {
            Write-Host "[error] $($tool.Name) install did not succeed"
            $allOk = $false
        }
    }
}

if (Get-Command gh -ErrorAction SilentlyContinue) {
    gh auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[action needed] gh is installed but not authenticated - run 'gh auth login' yourself (it's interactive)."
        $allOk = $false
    } else {
        Write-Host "[ok] gh is authenticated"
    }
}

if (-not $allOk) {
    exit 1
}
