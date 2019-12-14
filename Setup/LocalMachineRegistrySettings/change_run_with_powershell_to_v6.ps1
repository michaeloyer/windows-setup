Import-Module $PSScriptRoot\RegistryFunctions -Force

$Powershell6 = "$env:ProgramFiles\PowerShell\6\pwsh.exe"

if (Test-Path $Powershell6){
    
    $RegsitryPath = "HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell\0\Command"

    $path = (Get-RegistrySetting $RegsitryPath).'(default)'
    $path = [Regex]::Replace($path, '^"[^"]+"', """$Powershell6""")
    
    Add-RegistrySetting `
        -Path $RegsitryPath `
        -Key "(default)" `
        -Value $path `
        -Type String
    
}