function Test-Command($cmd) {
	$commandFound = (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null

    if (-not $commandFound) {
        Write-Host $cmd -ForegroundColor Red -NoNewline
        Write-Host " not found"
    }

    return $commandFound
}