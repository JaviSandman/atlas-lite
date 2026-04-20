param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("install", "doctor", "new-project")]
    [string]$Command,
    [string]$ProjectName = "classroom-demo"
)

$workspace = Resolve-Path (Join-Path $PSScriptRoot "..\..")

switch ($Command) {
    "install" {
        & (Join-Path $PSScriptRoot "install-atlas.ps1") -WorkspacePath $workspace -DemoProjectName $ProjectName
    }
    "doctor" {
        & (Join-Path $PSScriptRoot "atlas-doctor.ps1") -WorkspacePath $workspace
    }
    "new-project" {
        & (Join-Path $PSScriptRoot "new-atlas-project.ps1") -WorkspacePath $workspace -ProjectName $ProjectName
    }
}
