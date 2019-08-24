Import-Module $PSScriptRoot\WindowsSetupInstallation -Force

if (Test-Command git) {
    PowerShellGet\Install-Module posh-git -Force -AllowPrerelease -Scope CurrentUser

    if ((Get-Module posh-git) -ne $null) {
        Write-Host 'Successfully installed ' -ForegroundColor Yellow -NoNewline
        Write-Host 'posh-git' -ForegroundColor Green
        Import-Module posh-git
    }

    Add-GitGlobalConfig -Property color.ui -Value true
    Add-GitGlobalConfig -Property color.status.changed -Value "magenta bold"
    Add-GitGlobalConfig -Property color.status.untracked -Value "magenta bold"
    Add-GitGlobalConfig -Property color.status.added -Value "green bold"
    Add-GitGlobalConfig -Property color.branch.current -Value "yellow bold reverse"
    Add-GitGlobalConfig -Property color.branch.local -Value "yellow bold"
    Add-GitGlobalConfig -Property color.branch.remote -Value "green bold"
}
else {
    Write-Host "Skipping Posh-Git installation and Git Config Installation" -ForegroundColor Yellow 
}

Install-ProfileImportModule -Path $PSScriptRoot\ProfileImport

Pause