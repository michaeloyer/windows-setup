function Add-RegistrySetting([String]$Path, [String]$Key, $Value, [Microsoft.Win32.RegistryValueKind]$Type) 
{
    if ($Path -inotmatch "^Registry::") {
        $Path = "Registry::$Path"
    }
    
    $Item = New-ItemProperty -Path $Path -Name $Key -Value $Value -PropertyType $Type -Force 
       
        
    Write-Host "Added Registry Setting " -ForegroundColor Yellow -NoNewline
    Write-Host "$Path\$Key" -ForegroundColor Blue -NoNewline
    Write-Host " with value " -ForegroundColor Yellow -NoNewline
    Write-Host "$Value ($Type)" -ForegroundColor Blue
}