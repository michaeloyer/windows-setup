$ModulesDirectory = Join-Path $PSScriptRoot Modules

Import-Module $ModulesDirectory\InstallSetupModule

& $SetupDirectory\LocalMachineRegistrySettings\install.ps1

Pause