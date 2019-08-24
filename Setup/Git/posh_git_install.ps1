Write-Host 'Installing ' -ForegroundColor Yellow -NoNewline
Write-Host 'posh-git' -ForegroundColor Red

PowerShellGet\Install-Module posh-git -Force -AllowPrerelease -Scope CurrentUser

if ((Get-Module posh-git) -ne $null) {
    Write-Host 'Successfully installed ' -ForegroundColor Yellow -NoNewline
    Write-Host 'posh-git' -ForegroundColor Green
    Import-Module posh-git
}