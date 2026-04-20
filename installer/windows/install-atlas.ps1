param(
    [string]$WorkspacePath = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [string]$DemoProjectName = "classroom-demo",
    [switch]$SkipDemoProject
)

$ErrorActionPreference = "Stop"

function Write-Step([string]$Message) {
    Write-Host "[Atlas Install] $Message" -ForegroundColor Cyan
}

Write-Step "Starting Atlas Lite install for Windows"
Write-Step "Workspace: $WorkspacePath"

# ---------------------------------------------------------------------------
# Descarga automática de engram.exe desde GitHub Releases
# Refs:
#   Releases : https://github.com/Gentleman-Programming/engram/releases
#   Install  : https://github.com/Gentleman-Programming/engram/blob/main/docs/INSTALLATION.md
# ---------------------------------------------------------------------------
$engramDest = Join-Path $WorkspacePath "engram.exe"
if (-not (Test-Path $engramDest)) {
    Write-Step "Downloading engram.exe from GitHub Releases..."
    $releasesApi = "https://api.github.com/repos/Gentleman-Programming/engram/releases/latest"
    $release = Invoke-RestMethod -Uri $releasesApi -Headers @{"User-Agent"="Atlas-Installer"}
    $asset = $release.assets | Where-Object { $_.name -match "windows_amd64\.zip" } | Select-Object -First 1
    if (-not $asset) { throw "Could not find windows_amd64 asset in latest engram release." }
    $zip = Join-Path $env:TEMP "engram.zip"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zip
    Expand-Archive $zip -DestinationPath $WorkspacePath -Force
    Remove-Item $zip
    Write-Step "engram.exe downloaded: $($release.tag_name)"
}
# ---------------------------------------------------------------------------

$required = @(
    ".github/copilot-instructions.md",
    ".github/atlas-work-system.md",
    ".github/atlas-skill-catalog.json",
    ".github/skills",
    ".projects/_template"
)

foreach ($item in $required) {
    $full = Join-Path $WorkspacePath $item
    if (-not (Test-Path $full)) {
        throw "Missing required item: $item"
    }
}

$installDir = Join-Path $WorkspacePath ".atlas/install"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

$engramVersion = (& (Join-Path $WorkspacePath "engram.exe") version 2>&1 | Out-String).Trim()

if (-not $SkipDemoProject) {
    Write-Step "Creating demo project: $DemoProjectName"
    $newProjectScript = Join-Path $WorkspacePath "installer/windows/new-atlas-project.ps1"
    if (Test-Path (Join-Path $WorkspacePath ".projects/$DemoProjectName")) {
        Write-Step "Demo project already exists. Skipping creation."
    } else {
        & $newProjectScript -ProjectName $DemoProjectName -WorkspacePath $WorkspacePath
    }
}

Write-Step "Seeding Engram with global rules"
$seedFile = Join-Path $WorkspacePath "installer/windows/engram-seed.json"
if (Test-Path $seedFile) {
    & (Join-Path $WorkspacePath "engram.exe") import $seedFile 2>&1 | Out-Null
    Write-Step "Engram seed imported successfully"
} else {
    Write-Warning "Engram seed file not found. Skipping memory seed."
}

Write-Step "Running Atlas Doctor"
$doctorScript = Join-Path $WorkspacePath "installer/windows/atlas-doctor.ps1"
$doctorJson = & $doctorScript -WorkspacePath $WorkspacePath -Json | Out-String
$doctorObj = $doctorJson | ConvertFrom-Json

$report = [pscustomobject]@{
    installedAt = (Get-Date).ToString("o")
    workspace = $WorkspacePath
    engramVersion = $engramVersion
    demoProject = if ($SkipDemoProject) { "skipped" } else { $DemoProjectName }
    doctorStatus = $doctorObj.status
    doctorPassed = $doctorObj.passedChecks
    doctorTotal = $doctorObj.totalChecks
}

$reportPath = Join-Path $installDir "install-report.json"
$report | ConvertTo-Json -Depth 4 | Set-Content -Path $reportPath -Encoding UTF8

Write-Step "Install report saved: $reportPath"
Write-Step "Status: $($doctorObj.status)"

if ($doctorObj.status -ne "PASS") {
    throw "Atlas Doctor reported FAIL. Review installer/windows/atlas-doctor.ps1 output."
}

Write-Step "Atlas Lite install completed successfully."
