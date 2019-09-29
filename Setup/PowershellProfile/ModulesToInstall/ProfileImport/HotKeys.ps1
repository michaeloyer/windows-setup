if ($PSVersionTable.PSVersion -ge '5.1')
{
    Set-PSReadlineKeyHandler -Chord Alt+F4 -Function ViExit
}