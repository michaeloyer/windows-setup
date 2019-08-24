Class RGB {
    [byte]$Red
    [byte]$Green
    [byte]$Blue

    RGB([object[]] $arr) { 
        $this.Red = $arr[0]
        $this.Green = $arr[1] 
        $this.Blue = $arr[2]
    }
    
    [string]ToString() { return "$this.Red, $this.Green, $this.Blue" }
}

Enum ColorTable {
    Null = -1
    Black
    DarkBlue
    DarkGreen
    DarkCyan
    DarkRed
    DarkMagenta
    DarkYellow
    Gray
    DarkGray
    Blue
    Green
    Cyan
    Red
    Magenta
    Yellow
    White
}

Class BackgroundAndText {
    [ColorTable]$Background = [ColorTable]::Null
    [ColorTable]$Text = [ColorTable]::Null

    [byte]ToByte() { 
        return (([byte]$this.Background -shl 4) + [byte]$this.Text) 
    }
}

Class ConsoleProperties {
    [byte]$FontSize

    [RGB]$Black 
    [RGB]$DarkBlue 
    [RGB]$DarkGreen 
    [RGB]$DarkCyan 
    [RGB]$DarkRed 
    [RGB]$DarkMagenta 
    [RGB]$DarkYellow 
    [RGB]$Gray 
    [RGB]$DarkGray 
    [RGB]$Blue
    [RGB]$Green 
    [RGB]$Cyan
    [RGB]$Red 
    [RGB]$Magenta 
    [RGB]$Yellow
    [RGB]$White

    [BackgroundAndText]$Screen
    [BackgroundAndText]$Popup
}

function GetDefaultShortcutPath() {
    return Join-Path $env:APPDATA '\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk'
}


#Currently only supports editing the Powershell Shortcut File, not the Registry Settings
function WriteConsoleProperties([string]$ShortcutPath, [ConsoleProperties]$Properties) {
    if ([String]::IsNullOrEmpty($ShortcutPath))
    {
        $ShortcutPath = GetDefaultShortcutPath
    }

    $stream = [System.IO.FileStream]::new($ShortcutPath, [System.IO.FileMode]::Open)

    function WriteByte ($byte, $position) {
        $stream.Position = $position
        $stream.WriteByte($byte)
    }

    function WriteRGB([RGB]$rgb, $position) {
        if ($rgb -ne $null) {
            $stream.Position = $position
            $stream.WriteByte($rgb.Red)
            $stream.WriteByte($rgb.Green)
            $stream.WriteByte($rgb.Blue)
        }
    }

    function WriteBackgroundAndText([BackgroundAndText]$bANDt, $position) {
        if ($bANDt -ne $null -and $bANDt.Background -ne [ColorTable]::Null -and $bANDt.Text -ne [ColorTable]::Null) {
            WriteByte $bANDt.ToByte() -position $position
        }
    }

    WriteRGB $properties.Black -position 2175
    WriteRGB $properties.DarkBlue -position 2179
    WriteRGB $properties.DarkGreen -position 2183
    WriteRGB $properties.DarkCyan -position 2187
    WriteRGB $properties.DarkRed -position 2191
    WriteRGB $properties.DarkMagenta -position 2195
    WriteRGB $properties.DarkYellow -position 2199
    WriteRGB $properties.Gray -position 2203
    WriteRGB $properties.DarkGray -position 2207
    WriteRGB $properties.Blue -position 2211
    WriteRGB $properties.Green -position 2215
    WriteRGB $properties.Cyan -position 2219
    WriteRGB $properties.Red -position 2223
    WriteRGB $properties.Magenta -position 2227
    WriteRGB $properties.Yellow -position 2231
    WriteRGB $properties.White -position 2235

    if ($FontSize -ge 5 -and $FontSize -le 72) {
        WriteByte $FontSize -position 2069
    }

    WriteBackgroundAndText $properties.Screen -position 2043
    WriteBackgroundAndText $properties.Popup -position 2045 

    $stream.Dispose()
}