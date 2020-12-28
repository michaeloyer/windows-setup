Import-Module $PSScriptRoot\GitSetupModule -Force

Add-GitGlobalConfig -Property 'core.editor' -Value 'vim'

Add-GitGlobalConfig -Property 'color.ui' -Value 'true'
Add-GitGlobalConfig -Property 'color.status.changed' -Value "magenta bold"
Add-GitGlobalConfig -Property 'color.status.untracked' -Value "magenta bold"
Add-GitGlobalConfig -Property 'color.status.added' -Value "green bold"
Add-GitGlobalConfig -Property 'color.branch.current' -Value "yellow bold reverse"
Add-GitGlobalConfig -Property 'color.branch.local' -Value "yellow bold"
Add-GitGlobalConfig -Property 'color.branch.remote' -Value "green bold"

Add-GitGlobalConfig -Property 'format.pretty' -Value "%C(auto)%h%d %s %C(bold yellow)(%C(bold magenta)%cN%Cblue %cD %C(bold green)%cr%C(bold yellow))"

Add-GitGlobalConfig -Property 'pull.rebase' -Value true
Add-GitGlobalConfig -Property 'rebase.autoStash' -Value true

Add-GitGlobalConfig -Property 'alias.c' -Value "commit -m"
Add-GitGlobalConfig -Property 'alias.ac' -Value "!git add . && git commit -m"
Add-GitGlobalConfig -Property 'alias.co' -Value "checkout"
Add-GitGlobalConfig -Property 'alias.nb' -Value "checkout -b"

Add-GitGlobalConfig -Property 'init.defaultbranch' -Value "main"