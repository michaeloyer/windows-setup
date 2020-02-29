Import-Module $PSScriptRoot\..\..\Modules\Registry -Force

Add-RegistrySetting `
    -Path "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
    -Key "DisallowShaking" `
    -Value $true `
    -Type DWord