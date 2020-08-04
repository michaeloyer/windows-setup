function Get-PowershellPath() 
{
    $PowershellCore = Get-PowershellCorePath
    $PowershellFramework = Get-PowershellFrameworkPath
    return @($PowershellCore, $PowershellFramework) | 
        foreach { $(Resolve-Path $_).Path } | 
        where { Test-Path $_ } | 
        select -First 1
}

function Get-PowershellCorePath() {
    return Get-ChildItem $env:ProgramFiles\PowerShell -ErrorAction SilentlyContinue | 
        Where-Object { [Regex]::IsMatch($_.Name, "^\d+$") } |
        Where-Object { Test-Path (Join-Path $_.FullName "pwsh.exe") } |
        Sort-Object { [Convert]::ToInt32($_.Name) } -Descending |
        ForEach-Object { Get-Item (Join-Path $_.FullName "pwsh.exe") } |
        Select-Object -First 1
}

function Get-PowershellFrameworkPath {
    return $((Get-Command powershell.exe).Definition)
}

#Powershell Shortcut when using Windows-X, I
function Get-PowershellDefaultShortcutPath {
    return Join-Path $env:APPDATA '\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk'
}

#If you 'Pin' powershell to the task bar this shortcut will be created
function Get-PowershellTaskbarShortcutPath {
    return Join-Path $env:APPDATA '\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Windows PowerShell.lnk'
}

function New-Shortcut($ShortcutPath, [string]$WorkingDirectory, [switch]$NoLogo)
{
    Remove-Item $ShortcutPath
    $shell = New-Object -ComObject WScript.Shell 
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    
    $shortcut.TargetPath = Get-PowershellPath

    $shortcut.WorkingDirectory = $WorkingDirectory
    if (Test-Path ([Environment]::ExpandEnvironmentVariables($WorkingDirectory)) -PathType Container)
    {
        $shortcut.WorkingDirectory = $WorkingDirectory
    }
    else {
        $shortcut.WorkingDirectory = "%USERPROFILE%"
        Write-Host 'Cannot find ' -ForegroundColor Red -NoNewline
        Write-Host $WorkingDirectory -ForegroundColor Yellow -NoNewline
        Write-Host ". Setting Working Directory to User Profile" -ForegroundColor Red
    }

    if ($NoLogo)
    {
        $shortcut.Arguments += '-NoLogo -NoProfile'
    }
    
    $shortcut.Save()
    
    Write-Host "Updated Shortcut File: " -ForegroundColor Yellow -NoNewLine
    Write-Host $ShortcutPath -ForegroundColor Green
}