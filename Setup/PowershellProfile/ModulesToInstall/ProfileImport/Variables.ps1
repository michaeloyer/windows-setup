function Set-Path([string]$variable, [string]$path) {
    $path = (Resolve-Path $path).Path
    if (Test-Path $path) {
        Set-Variable -Name $variable -Value $path -Scope global
    }
    else {
        Write-Host "Unable to set " -ForegroundColor Yellow -NoNewLine
        Write-Host ('$' + "$variable") -ForegroundColor Green -NoNewLine
        Write-Host " to " -ForegroundColor Yellow -NoNewLine
        Write-Host $path -ForegroundColor Yellow
    }
}

Set-Path dev "~/dev"
Set-Path bin "~/bin"
Set-Path sshconfig "~/.ssh/config"
Set-Path gitconfig "~/.gitconfig"