function Get-ColorTableNumber(
    [ValidateSet(
    "Black",
    "DarkBlue",
    "DarkGreen",
    "DarkCyan",
    "DarkRed",
    "DarkMagenta",
    "DarkYellow",
    "Gray",
    "DarkGray",
    "Blue",
    "Green",
    "Cyan",
    "Red",
    "Magenta",
    "Yellow",
    "White")]$ColorTable)
{
    return @{
        Black = 0;
        DarkBlue = 1;
        DarkGreen = 2;
        DarkCyan = 3;
        DarkRed = 4;
        DarkMagenta = 5;
        DarkYellow = 6;
        Gray = 7;
        DarkGray = 8;
        Blue = 9;
        Green = 10;
        Cyan = 11;
        Red = 12;
        Magenta = 13;
        Yellow = 14;
        White = 15;
    }[$ColorTable]
}


function Get-ConsoleRegistryItem {
    return Get-ItemProperty 'HKCU:Console'
}

function Edit-Color(
    [ValidateSet(
    "Black",
    "DarkBlue",
    "DarkGreen",
    "DarkCyan",
    "DarkRed",
    "DarkMagenta",
    "DarkYellow",
    "Gray",
    "DarkGray",
    "Blue",
    "Green",
    "Cyan",
    "Red",
    "Magenta",
    "Yellow",
    "White")]$ColorTable, 
    [ValidateRange(0,255)][int]$Red = -1, 
    [ValidateRange(0,255)][int]$Green = -1, 
    [ValidateRange(0,255)][int]$Blue = -1) {

    Edit-GlobalConsoleProperty `
        -Name ("ColorTable{0:00}" -f $(Get-ColorTableNumber $ColorTable)) `
        -Value (($Red -shl 0) + ($Green -shl 8) + ($Blue -shl 16)) `
        -Type DWord
}

function Edit-BackgroundAndText(
    [ValidateSet("Screen", "Popup")]$Type, 
    [ValidateSet(
    "Black",
    "DarkBlue",
    "DarkGreen",
    "DarkCyan",
    "DarkRed",
    "DarkMagenta",
    "DarkYellow",
    "Gray",
    "DarkGray",
    "Blue",
    "Green",
    "Cyan",
    "Red",
    "Magenta",
    "Yellow",
    "White")]$Background, 
    [ValidateSet(
    "Black",
    "DarkBlue",
    "DarkGreen",
    "DarkCyan",
    "DarkRed",
    "DarkMagenta",
    "DarkYellow",
    "Gray",
    "DarkGray",
    "Blue",
    "Green",
    "Cyan",
    "Red",
    "Magenta",
    "Yellow",
    "White")]$Text) {

    Edit-GlobalConsoleProperty `
        -Name "$($Type)Colors" `
        -Value (((Get-ColorTableNumber $Background) -shl 4) + (((Get-ColorTableNumber $Text) -shl 0)))  `
        -Type DWord
}

function Edit-Font([ValidateRange(5, 72)][int]$Size = -1) {

    Edit-GlobalConsoleProperty `
        -Name 'FontSize' `
        -Value ($Size -shl 16) `
        -Type DWord
}

function Edit-QuickEditMode([ValidateRange(0,1)][int]$QuickEditMode = -1) {

    Edit-GlobalConsoleProperty `
        -Name 'QuickEdit' `
        -Value $QuickEditMode  `
        -Type DWord
}

function Edit-GlobalConsoleProperty ($Name, $Value, [Microsoft.Win32.RegistryValueKind]$Type)
{
    Get-ConsoleRegistryItem | 
        New-ItemProperty -Name $Name -Value $Value -Force |
        Out-Null

    #Includes removing the same property from all other child properties so this new property takes precedence
    Get-ConsoleRegistryItem | 
        Get-ChildItem | 
        foreach { 
            Remove-ItemProperty -Path $_.PSPath -Name $Name -ErrorAction SilentlyContinue
        }
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
    Write-Host $ShortcutPath -ForegroundColor Yellow
    Remove-Item $ShortcutPath
    $shell = New-Object -ComObject WScript.Shell 
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    
    $shortcut.TargetPath = GetPowershellPath

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
        $shortcut.Arguments += '-NoLogo'
    }
    
    $shortcut.Save()
}

function GetPowershellPath() 
{
    return @("$env:ProgramFiles\PowerShell\6\pwsh.exe",
        "$((Get-Command powershell.exe).Definition)") | 
    foreach { $(Resolve-Path $_).Path } | 
    where { Test-Path $_ } | 
    select -First 1
}

