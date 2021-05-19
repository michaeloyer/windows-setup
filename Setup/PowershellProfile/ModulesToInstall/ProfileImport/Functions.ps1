function vi ($File, [switch]$Verbose) {
    $cmd = 'vi $(wslpath ' + "'$File'" + ')'
    if ($Verbose) { Write-Host "bash -c '$cmd'" -ForegroundColor Yellow }
    bash -c $cmd;
}

function ex ($Dir) {
    if ($null -eq $Dir) { explorer . }
    else { explorer $Dir }
}

function cddev {
    Set-Location $Env:DEV
}

function GitToSsh {
    [CmdletBinding()]
    param (
        [ValidateScript( { $_.Scheme -eq [Uri]::UriSchemeHttps }, ErrorMessage = 'Must be an HTTPS Uri')]
        [Uri]$uri
    )

    switch ($uri.Host) {
        'github.com' { return "git@$($uri.Host):$($uri.AbsolutePath.Substring(1))" }
        Default { throw "Unsupported git host: $($uri.Host)" }
    }
}

function New-TempDirectory() {
    $arr = 'A'..'Z' + 'a'..'z' + 0..9
    do {
        $name = "##" + ((1..8 | ForEach-Object { $arr | Get-Random }) -join '')
        $dir = Join-Path $env:TEMP dirs $name
    } while ((Test-Path $dir -PathType Container) -or (-not (New-Item $dir -Force -ItemType Directory -ErrorAction SilentlyContinue)))

    Set-Location $dir
}

function Get-TempDirectory([string]$Directory, [switch]$cd) {
    if ($Directory) {
        $dir = Join-Path $env:TEMP dirs $Directory
        if ($cd) {
            Set-Location $dir
        }
        else {
            $dir
        }
    }
    else {
        Join-Path $env:TEMP dirs |
        Get-ChildItem |
        Sort-Object LastWriteTime -Descending
    }
}

Register-ArgumentCompleter -CommandName "Get-TempDirectory" -ScriptBlock {
    Join-Path $env:TEMP dirs |
    Get-ChildItem |
    Sort-Object LastWriteTime -Descending |
    Select-Object -ExpandProperty Name |
    ForEach-Object { '"' + $_ + '"' }
}

function Show-Jwt([string]$jwt, [switch]$IncludeHeader) {
    $parts = $jwt.Replace('-', '+').Replace('_', '/') -split '\.'
    if ($parts.Length -ne 3) {
        Write-Error "Invalid JWT '$jwt'"
    }
    $header, $payload, $_ = `
        $parts | ForEach-Object { $_.PadRight($_.Length + (4 - $_.Length % 4) % 4, '=') }

    if ($IncludeHeader) {
        Write-Host ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($header))
            | ConvertFrom-Json | ConvertTo-Json) -ForegroundColor Blue
    }
    Write-Host ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload))
        | ConvertFrom-Json | ConvertTo-Json) -ForegroundColor Green
}

function cdgit() {
    $Directory = Get-Item .
    while ($null -ne $Directory -and -not (Test-Path (Join-Path $Directory ".git"))) {
        $Directory = $Directory.Parent
    }

    if ($null -ne $Directory) {
        Set-Location $Directory
    }
    else {
        Write-Host ".git folder not found" -ForegroundColor Yellow
    }
}
