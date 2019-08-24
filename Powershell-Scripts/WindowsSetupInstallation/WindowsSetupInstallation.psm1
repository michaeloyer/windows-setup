function Install-ProfileImportModule ([string]$Path) {
    $Destination = ($env:PSModulePath -split ';' | Select-Object -First 1)
    Copy-Item -Path $Path -Destination $Destination -Force -Recurse

    Write-Host 'Copied ' -ForegroundColor Yellow -NoNewline
    Write-Host 'ProfileImport' -ForegroundColor Green -NoNewline
    Write-Host ' to User Modules folder ' -ForegroundColor Yellow -NoNewline
    Write-Host $Destination -ForegroundColor Green

    
    $profileScript = Get-Content $profile
    $importScriptLine = "Import-Module ProfileImport"
    if ($profileScript -inotcontains $importScriptLine) {
        $scriptLine = "Import-Module ProfileImport$([System.Environment]::NewLine)ImportForProfile"
        Add-Content -Path $profile -Value `
            "$([System.Environment]::NewLine)$scriptLine"

        Write-Host 'Adding ' -ForegroundColor Yellow
        Write-Host $scriptLine -ForegroundColor Magenta
        Write-Host 'To Profile script: ' -ForegroundColor Yellow -NoNewline
        Write-Host $profile -ForegroundColor Green
    }
}

function Test-Command($cmd) {
	$commandFound = (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null

    if (-not $commandFound) {
        Write-Host $cmd -ForegroundColor Red -NoNewline
        Write-Host " not found"
    }

    return $commandFound
}

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