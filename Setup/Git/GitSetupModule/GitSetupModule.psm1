function Add-GitGlobalConfig([string]$Property, [string]$Value)
{
	$CurrentValue = (git config --global --get $Property)
	if ($CurrentValue -ne $Value){
		if ($CurrentValue -ne $null) {
            Write-Host "Removing Git Config Property " -ForegroundColor Yellow -NoNewline
            Write-Host $Property -ForegroundColor Red -NoNewline
            Write-Host " with Value " -ForegroundColor Yellow -NoNewline
            Write-Host $CurrentValue -ForegroundColor Red
			git config --global --unset $Property
		}
		
        Write-Host "Adding Git Config Property " -ForegroundColor Yellow -NoNewline
        Write-Host $Property -ForegroundColor Green -NoNewline
        Write-Host " with Value " -ForegroundColor Yellow -NoNewline
        Write-Host $Value -ForegroundColor Green
		git config --global --add $Property $Value
	}
    else {
        Write-Host "Git Config Property " -ForegroundColor Yellow -NoNewline
        Write-Host $Property -ForegroundColor Blue -NoNewline
        Write-Host " with Value " -ForegroundColor Yellow -NoNewline
        Write-Host $Value -ForegroundColor Blue -NoNewline
        Write-Host " already exists" -ForegroundColor Yellow
    }
}