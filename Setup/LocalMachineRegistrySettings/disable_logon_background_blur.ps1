Import-Module $PSScriptRoot\RegistryFunctions -Force

Add-RegistrySetting `
    -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" `
    -Key "DisableAcrylicBackgroundOnLogon" `
    -Value '1' `
    -Type DWord