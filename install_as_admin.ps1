Install-Module PowerShellGet -Force

if (where.exe git /Q) {
    #Allowing Prerelease based on Posh-Git Repo Recommendation. Should remove after 1.0.0 is fully released
    Install-Module Posh-Git -Force -AllowPrerelease

    Add-PoshGitToProfile
}
else {
    Write-Host 'git not found in Path, skipping install of Posh-Git'
}
