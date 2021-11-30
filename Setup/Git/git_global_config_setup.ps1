Import-Module $PSScriptRoot\GitSetupModule -Force

Add-GitGlobalConfig -Property 'core.editor' -Value 'vim'
Add-GitGlobalConfig -Property 'core.autocrlf' -Value 'false'

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
Add-GitGlobalConfig -Property 'alias.cob' -Value "checkout -b"
Add-GitGlobalConfig -Property 'alias.stashstaged' -Value '!git stash push -- $(git diff --staged --name-only)'
Add-GitGlobalConfig -Property 'alias.amend' -Value 'commit --amend --no-edit'
Add-GitGlobalConfig -Property 'alias.patch' -Value 'add --patch'
Add-GitGlobalConfig -Property 'alias.pushu' -Value '!git push --set-upstream origin $(git branch --show-current)'
Add-GitGlobalConfig -Property 'alias.bd' -Value 'branch -d'
Add-GitGlobalConfig -Property 'alias.skip' -Value '!git update-index --skip-worktree $1'
Add-GitGlobalConfig -Property 'alias.unskip' -Value '!git update-index --no-skip-worktree $1'
Add-GitGlobalConfig -Property 'alias.skipped' -Value '!git ls-files -v | grep ^S | cut -d '' '' -f 2-'
Add-GitGlobalConfig -Property 'alias.branches' -Value 'for-each-ref --sort=-committerdate refs/heads/ --format=''%(color:bold blue)%(committerdate:short) %(color:bold yellow)%(refname:short)'''
Add-GitGlobalConfig -Property 'alias.alias' -Value '!git config --list | grep ^alias\. | sed ''s/alias\.//g'' | sed ''s/=/\t/'' | sort | column -t -s $''\t'''
Add-GitGlobalConfig -Property 'alias.diffs' -Value 'diff --staged'

Add-GitGlobalConfig -Property 'init.defaultbranch' -Value "main"
