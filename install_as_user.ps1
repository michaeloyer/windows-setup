$ModulesDirectory = Join-Path $PSScriptRoot Modules

Import-Module $ModulesDirectory\InstallSetupModule -Force


$SetupDirectory = Join-Path $PSScriptRoot Setup

if (Test-Command git) {
   & $SetupDirectory\Git\install.ps1
}
else {
    Write-Host "Skipping Posh-Git installation and Git Config Installation" -ForegroundColor Yellow 
}

& $SetupDirectory\PowershellProfile\install.ps1
& $SetupDirectory\UserRegistrySettings\install.ps1

Pause
