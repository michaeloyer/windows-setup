function vi ($File, [switch]$Verbose) {
	$cmd = 'vi $(wslpath ' + "'$File'" + ')'
	if ($Verbose) { Write-Host "bash -c '$cmd'" -ForegroundColor Yellow }
	bash -c $cmd;
}

function ex ($Dir){
    if ($Dir -eq $null) { explorer . }
    else { explorer $Dir }
}

Set-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"

function cddev {
	cd $Env:DEV
}

function Verb-Noun {
	[CmdletBinding()]
	param (
		
	)
	
	begin {
		
	}
	
	process {
		
	}
	
	end {
		
	}
}

function Get-WhichFiles ($Path, [switch]$First) {
	if ($First) {
		where.exe $Path
	}
	else {
		where.exe $Path | Select-Object -First 1
	}
}

Set-Alias which Get-WhichFiles

function Get-FirstItems {
	param (
		[Parameter(ValueFromPipeline=$true)]
		[System.Object]$item,
        [Parameter(Position=1)]
        [ValidateRange(1, [int]::MaxValue)]
		[int]$Count = 1
	)

	begin { 
		$index = 0
	}

	process {
        if ($index -ge $Count) {
            return
        }

		$item
        $index++
	}
}

Set-Alias first Get-FirstItems

function Get-LastItems ([parameter(ValueFromPipeline)]$items, [int]$Count = 1) {
	$items | Select-Object -Last $Count
}

Set-Alias last Get-LastItems

function Get-FullHistory {
	Get-Content (Get-PSReadlineOption).HistorySavePath
}

Set-Alias history Get-FullHistory