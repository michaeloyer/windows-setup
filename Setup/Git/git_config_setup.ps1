$Path = (Resolve-Path .gitconfig).Path.Replace('\', '/')

if (git config --global --get include.path $Path) {
    Write-Host "include.path already set in .gitconfig" -ForegroundColor Yellow
} else {
    Write-Host "Setting include.path in .gitconfig" -ForegroundColor Yellow
    git config --global --add include.path $Path
}

git config set --global alias.open-setup-git-config "!code $($Path)"
