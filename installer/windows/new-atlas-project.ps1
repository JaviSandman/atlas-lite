param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,
    [string]$WorkspacePath = (Resolve-Path (Join-Path $PSScriptRoot "..\.."))
)

$ErrorActionPreference = "Stop"

function Write-Info([string]$Message) {
    Write-Host "[Atlas] $Message" -ForegroundColor Cyan
}

if ($ProjectName -match "[^a-zA-Z0-9_-]") {
    throw "ProjectName only supports letters, numbers, '-' and '_'."
}

$templatePath = Join-Path $WorkspacePath ".projects\_template"
$projectsRoot = Join-Path $WorkspacePath ".projects"
$targetPath = Join-Path $projectsRoot $ProjectName

if (-not (Test-Path $templatePath)) {
    throw "Template not found at $templatePath"
}

if (Test-Path $targetPath) {
    throw "Project already exists: $targetPath"
}

Copy-Item -Path $templatePath -Destination $targetPath -Recurse

$orchestratorPath = Join-Path $targetPath "ORCHESTRATOR.md"
$rulesPath = Join-Path $targetPath "RULES.md"

if (Test-Path $orchestratorPath) {
    $orchestrator = Get-Content $orchestratorPath -Raw
    $orchestrator = $orchestrator.Replace("<project_name>", $ProjectName)
    Set-Content -Path $orchestratorPath -Value $orchestrator -Encoding UTF8
}

if (Test-Path $rulesPath) {
    $rules = Get-Content $rulesPath -Raw
    $rules = $rules + "`n- Project name: $ProjectName`n"
    Set-Content -Path $rulesPath -Value $rules -Encoding UTF8
}

$readmePath = Join-Path $targetPath "README.md"
if (Test-Path $readmePath) {
    $readme = Get-Content $readmePath -Raw
    $readme = "# Project: $ProjectName`n`n" + $readme
    Set-Content -Path $readmePath -Value $readme -Encoding UTF8
}

Write-Info "Project created: .projects/$ProjectName"
