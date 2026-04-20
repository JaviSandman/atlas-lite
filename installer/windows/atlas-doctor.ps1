param(
    [string]$WorkspacePath = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [switch]$Json
)

$ErrorActionPreference = "Continue"
$checks = New-Object System.Collections.ArrayList

function Add-Check([string]$Name, [bool]$Ok, [string]$Detail) {
    [void]$checks.Add([pscustomobject]@{
        name = $Name
        ok = $Ok
        detail = $Detail
    })
}

function Test-Exists([string]$Path) {
    return Test-Path $Path
}

$requiredPaths = @(
    ".github/copilot-instructions.md",
    ".github/atlas-work-system.md",
    ".github/atlas-skill-catalog.json",
    ".github/atlas-skill-growth-policy.md",
    ".github/engram-memory-instruction.md",
    ".projects/_template/ORCHESTRATOR.md",
    ".projects/_template/RULES.md"
)

foreach ($p in $requiredPaths) {
    $full = Join-Path $WorkspacePath $p
    Add-Check "path:$p" (Test-Exists $full) $full
}

$engramPath = Join-Path $WorkspacePath "engram.exe"
if (Test-Path $engramPath) {
    $versionOut = & $engramPath version 2>&1 | Out-String
    Add-Check "engram:version" ($LASTEXITCODE -eq 0) ($versionOut.Trim())

    $statsOut = & $engramPath stats 2>&1 | Out-String
    Add-Check "engram:stats" ($LASTEXITCODE -eq 0) (($statsOut.Trim() -split "`n")[0])
} else {
    Add-Check "engram:binary" $false "engram.exe not found"
}

$sddSkills = @("sdd-init", "sdd-explore", "sdd-propose", "sdd-spec", "sdd-design", "sdd-tasks", "sdd-apply", "sdd-verify", "sdd-archive")
foreach ($skill in $sddSkills) {
    $skillPath = Join-Path $WorkspacePath ".github/skills/$skill/SKILL.md"
    Add-Check "skill:$skill" (Test-Path $skillPath) $skillPath
}

$failed = @($checks | Where-Object { -not $_.ok })
$okCount = @($checks | Where-Object { $_.ok }).Count
$total = $checks.Count

$result = [pscustomobject]@{
    workspace = $WorkspacePath
    totalChecks = $total
    passedChecks = $okCount
    failedChecks = $failed.Count
    status = if ($failed.Count -eq 0) { "PASS" } else { "FAIL" }
    checks = $checks
}

if ($Json) {
    $result | ConvertTo-Json -Depth 6
} else {
    Write-Host "Atlas Doctor: $($result.status) ($okCount/$total)"
    foreach ($c in $checks) {
        $prefix = if ($c.ok) { "[OK]" } else { "[FAIL]" }
        Write-Host "$prefix $($c.name) - $($c.detail)"
    }
}

if ($failed.Count -gt 0) { exit 1 } else { exit 0 }
