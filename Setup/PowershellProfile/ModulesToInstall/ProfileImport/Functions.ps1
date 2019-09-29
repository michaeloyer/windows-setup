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

Function cddev {
	cd $Env:DEV
}