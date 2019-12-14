function Add-RegistrySetting([String]$Path, [String]$Key, $Value, [Microsoft.Win32.RegistryValueKind]$Type) 
{
    $Path = Get-RegistryPath $Path
    
    $Item = New-ItemProperty -Path $Path -Name $Key -Value $Value -PropertyType $Type -Force 
       
        
    Write-Host "Added Registry Setting " -ForegroundColor Yellow -NoNewline
    Write-Host "$Path\$Key" -ForegroundColor Blue -NoNewline
    Write-Host " with value " -ForegroundColor Yellow -NoNewline
    Write-Host "$Value ($Type)" -ForegroundColor Blue
}

function Get-RegistrySetting([string]$Path, [String]$Key) {
    $Path = Get-RegistryPath $Path

    Return Get-ItemProperty -Path $Path -Name $Key
}

function Get-RegistryPath([string]$Path) {
    if ($Path -inotmatch "^Registry::") {
        return "Registry::$Path"
    }
    else {
        return $Path
    }
}