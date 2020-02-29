Import-Module $PSScriptRoot\..\..\Modules\PowershellPropertyEditor -Force
Import-Module $PSScriptRoot\..\..\Modules\PowershellFiles -Force

Write-Host "Writing Console Properties to User Registry" -ForegroundColor Yellow

Edit-Font -Size 18

Edit-Color Black -Red 0 -Green 0 -Blue 0
Edit-Color DarkBlue -Red 0 -Green 128 -Blue 255
Edit-Color DarkGreen -Red 0 -Green 128 -Blue 0
Edit-Color DarkCyan -Red 0 -Green 128 -Blue 128
Edit-Color DarkRed -Red 200 -Green 0 -Blue 0
Edit-Color DarkMagenta -Red 160 -Green 0 -Blue 160
Edit-Color DarkYellow -Red 204 -Green 119 -Blue 34
Edit-Color Gray -Red 192 -Green 192 -Blue 192
Edit-Color DarkGray -Red 150 -Green 150 -Blue 150
Edit-Color Blue -Red 0 -Green 175 -Blue 255
Edit-Color Green -Red 0 -Green 255 -Blue 0
Edit-Color Cyan -Red 0 -Green 255 -Blue 255
Edit-Color Red -Red 255 -Green 0 -Blue 0
Edit-Color Magenta -Red 255 -Green 0 -Blue 255
Edit-Color Yellow -Red 255 -Green 255 -Blue 0
Edit-Color White -Red 255 -Green 255 -Blue 255

Edit-BackgroundAndText Screen -Background Black -Text White
Edit-BackgroundAndText Popup -Background White -Text Black

@((Get-PowershellDefaultShortcutPath), (Get-PowershellTaskbarShortcutPath)) |
    where { return (Test-Path $_) } |
    foreach { New-Shortcut -ShortcutPath $_ -WorkingDirectory "%USERPROFILE%\Dev" -NoLogo }
