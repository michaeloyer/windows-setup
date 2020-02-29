Import-Module $PSScriptRoot\..\..\Modules\Registry -Force

Add-RegistrySetting `
    -Path "HKEY_CURRENT_USER\Console" `
    -Key "AllowAltF4Close" `
    -Value $true `
    -Type DWord