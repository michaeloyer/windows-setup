using module .\PowershellPropertyEditor

Write-Host "Writing Color Properties" -ForegroundColor Yellow

WriteConsoleProperties -Properties @{
    FontSize = 18

    Black = 0, 0, 0
    DarkBlue = 0, 128, 255
    DarkGreen = 0, 128, 0
    DarkCyan = 0, 128, 128
    DarkRed = 200, 0, 0
    DarkMagenta = 160, 0, 160
    DarkYellow = 204, 119, 34
    Gray = 192, 192, 192
    DarkGray = 150, 150, 150
    Blue = 0, 175, 255
    Green = 0, 255, 0
    Cyan = 0, 255, 255
    Red = 255, 0, 0
    Magenta = 255, 0, 255
    Yellow = 255, 255, 0
    White = 255, 255, 255

    Screen = @{ 
        Text = [ColorTable]::White; 
        Background = [ColorTable]::Black
    } 

    Popup = @{ 
        Text = [ColorTable]::White; 
        Background = [ColorTable]::Black
    } 
}