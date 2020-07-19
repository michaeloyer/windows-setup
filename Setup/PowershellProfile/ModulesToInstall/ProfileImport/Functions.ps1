function vi ($File, [switch]$Verbose) {
	$cmd = 'vi $(wslpath ' + "'$File'" + ')'
	if ($Verbose) { Write-Host "bash -c '$cmd'" -ForegroundColor Yellow }
	bash -c $cmd;
}

function ex ($Dir){
    if ($null -eq $Dir) { explorer . }
    else { explorer $Dir }
}

Set-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"

function cddev {
	Set-Location $Env:DEV
}

function GitToSsh {
	[CmdletBinding()]
	param (
		[ValidateScript({$_.Scheme -eq [Uri]::UriSchemeHttps }, ErrorMessage = 'Must be an HTTPS Uri')]
		[Uri]$uri
	) 

	switch ($uri.Host) {
		'github.com' { return "git@$($uri.Host):$($uri.AbsolutePath.Substring(1))" }
		Default { throw "Unsupported git host: $($uri.Host)"}
	}
}