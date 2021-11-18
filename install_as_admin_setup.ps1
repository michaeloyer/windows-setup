$ModulesDirectory = Join-Path $PSScriptRoot Modules

Import-Module $ModulesDirectory\InstallSetupModule

Write-Host "Installing " -ForegroundColor Yellow -NoNewLine
Write-Host "PowerShellGet" -ForegroundColor Green
Install-Module PowerShellGet -Force

if (Test-Command git) {
    #Allowing Prerelease based on Posh-Git Repo Recommendation. Should remove after 1.0.0 is fully released
    Install-Module Posh-Git -Force
}
else {
    Write-Host 'git not found in Path, skipping install of Posh-Git'
}

If((Get-Service ssh-agent) -eq $null) {
	Write-Host "Installing SSH Client" -ForegroundColor Yellow
	Add-WindowsCapability -Online -Name OpenSSH.Client* | Format-Table -Property Online,RestartNeeded
	Write-Host "Installed" -ForegroundColor Blue
}

Write-Host "Starting SSH Agent Service" -ForegroundColor Yellow
Get-Service ssh-agent | 
	Set-Service -StartupType Automatic | 
	Start-Service

Get-Service ssh-agent | Format-Table

if (Test-Command ssh) {
	Write-Host "ssh" -ForegroundColor Green -NoNewLine
	Write-Host " available" -ForegroundColor Yellow
}

Pause