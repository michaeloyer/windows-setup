Import-Module $PSScriptRoot\GitSetupModule -Force

Add-GitGlobalConfig -Property core.editor -Value vim
Add-GitGlobalConfig -Property color.ui -Value true
Add-GitGlobalConfig -Property color.status.changed -Value "magenta bold"
Add-GitGlobalConfig -Property color.status.untracked -Value "magenta bold"
Add-GitGlobalConfig -Property color.status.added -Value "green bold"
Add-GitGlobalConfig -Property color.branch.current -Value "yellow bold reverse"
Add-GitGlobalConfig -Property color.branch.local -Value "yellow bold"
Add-GitGlobalConfig -Property color.branch.remote -Value "green bold"