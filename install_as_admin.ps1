$ModulesDirectory = Join-Path $PSScriptRoot Modules
Write-Host $ModulesDirectory -ForegroundColor Yellow
Import-Module $(Join-Path $ModulesDirectory InstallSetupModule)
$SetupDirectory = Join-Path $PSScriptRoot Setup
& $SetupDirectory\LocalMachineRegistrySettings\install.ps1

Pause