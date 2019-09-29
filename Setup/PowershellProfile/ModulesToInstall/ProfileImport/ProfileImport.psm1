﻿function ImportForProfile {
    Import-PoshGit
    Add-Hotkeys
}

function Add-Hotkeys {
	if ($PSVersionTable.PSVersion -ge '5.1')
    {
        Set-PSReadlineKeyHandler -Chord Alt+F4 -Function ViExit
    }
}

function Import-PoshGit {
	Import-Module posh-git
    $poshGit = $(Get-Module posh-git)

    if ($poshGit -ne $null) {
        $GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
        $GitPromptSettings.DefaultPromptWriteStatusFirst = $true
        $GitPromptSettings.WorkingColor.ForegroundColor = [System.ConsoleColor]::Magenta
        $GitPromptSettings.LocalWorkingStatusSymbol.ForegroundColor = [System.ConsoleColor]::Magenta
        $GitPromptSettings.IndexColor.ForegroundColor = [System.ConsoleColor]::Green
        $GitPromptSettings.LocalStagedStatusSymbol.ForegroundColor = [System.ConsoleColor]::Green
        $GitPromptSettings.DefaultPromptPrefix = '`n'
    }
    else {
        Write-Host 'posh-git not installed. Skipping Posh-Git Setup' -ForegroundColor Red
    }
}