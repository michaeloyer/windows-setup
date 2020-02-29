Import-Module $PSScriptRoot\..\..\Modules\PowershellFiles -Force

$Shell = New-Item "Registry::HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\Shell" -Force
New-Item "Registry::$($Shell)\Open" | New-ItemProperty -Name 'LegacyDisable' -PropertyType 'ExpandString' | Out-Null

$PowershellCore = Get-PowershellCorePath

if ($null -ne $PowershellCore) {
    $0 = New-Item "Registry::$($Shell)\0"
    $0 | New-ItemProperty -Name "Icon" -Value 'pwsh.exe' -PropertyType 'ExpandString' | Out-Null
    $0 | New-ItemProperty -Name "MUIVerb" -Value 'Run with PowerShell' -PropertyType 'ExpandString' | Out-Null
    $command = New-Item "Registry::$($0)\Command"
    $command | New-ItemProperty -Name '(Default)' -PropertyType 'ExpandString' `
        -Value ('"' + $PowershellCore + '" "-Command" "if((Get-ExecutionPolicy ) -ne ''AllSigned'') { Set-ExecutionPolicy -Scope Process Bypass }; & ''%1''"') | Out-Null

    $1 = New-Item "Registry::$($Shell)\1"
    $1 | New-ItemProperty -Name "Icon" -Value 'pwsh.exe' -PropertyType 'ExpandString' | Out-Null
    $1 | New-ItemProperty -Name "MUIVerb" -Value 'Run with PowerShell (No Exit)' -PropertyType 'ExpandString' | Out-Null
    $command = New-Item "Registry::$($1)\Command"
    $command | New-ItemProperty -Name '(Default)' -PropertyType 'ExpandString' `
        -Value ('"' + $PowershellCore + '" -NoExit "-Command" "if((Get-ExecutionPolicy ) -ne ''AllSigned'') { Set-ExecutionPolicy -Scope Process Bypass }; & ''%1''"') | Out-Null

    Write-Host "Setup Context Menu to Run with " -ForegroundColor Yellow -NoNewLine
    Write-Host $PowershellCore -ForegroundColor Green
}
else {
    $PowershellFramework = Get-PowershellFrameworkPath
    $0 = New-Item "Registry::$($Shell)\0"
    $0 | New-ItemProperty -Name "Icon" -Value 'powershell.exe' -PropertyType 'ExpandString' | Out-Null
    $0 | New-ItemProperty -Name "MUIVerb" -Value 'Run with PowerShell' -PropertyType 'ExpandString' | Out-Null
    $command = New-Item "Registry::$($0)\Command"
    $command | New-ItemProperty -Name '(Default)' -PropertyType 'ExpandString' `
        -Value '"' + $PowershellFramework + '" "-Command" "if((Get-ExecutionPolicy ) -ne ''AllSigned'') { Set-ExecutionPolicy -Scope Process Bypass }; & ''%1''"' | Out-Null

    $1 = New-Item "Registry::$($Shell)\1"
    $1 | New-ItemProperty -Name "Icon" -Value 'powershell.exe' -PropertyType 'ExpandString' | Out-Null
    $1 | New-ItemProperty -Name "MUIVerb" -Value 'Run with PowerShell (No Exit)' -PropertyType 'ExpandString' | Out-Null
    $command = New-Item "Registry::$($1)\Command"
    $command | New-ItemProperty -Name '(Default)' -PropertyType 'ExpandString' `
        -Value '"' + $PowershellFramework + '" -NoExit "-Command" "if((Get-ExecutionPolicy ) -ne ''AllSigned'') { Set-ExecutionPolicy -Scope Process Bypass }; & ''%1''"' | Out-Null
    
    Write-Host "Setup Context Menu to Run with " -ForegroundColor Yellow -NoNewLine
    Write-Host $PowershellFramework -ForegroundColor Green
}

$2 = New-Item "Registry::$($Shell)\2"
$2 | New-ItemProperty -Name "Icon" -Value 'powershell_ise.exe,0' -PropertyType 'ExpandString' | Out-Null
$2 | New-ItemProperty -Name "MUIVerb" -Value 'Edit with Powershell ISE' -PropertyType 'ExpandString' | Out-Null
$command = New-Item "Registry::$($2)\Command"
$command | New-ItemProperty -Name '(Default)' -PropertyType 'ExpandString' `
    -Value '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" "%1"' | Out-Null

