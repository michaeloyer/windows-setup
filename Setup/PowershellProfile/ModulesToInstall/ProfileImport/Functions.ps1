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

function Show-Jwt([parameter(ValueFromPipeline)][string]$jwt, [switch]$IncludeHeader) {
    $parts = $jwt.Replace('-', '+').Replace('_', '/') -split '\.'
    if ($parts.Length -ne 3) {
        Write-Error "Invalid JWT '$jwt'"
        return
    }
    $header, $payload, $_ = `
        $parts | ForEach-Object { $_.PadRight($_.Length + (4 - $_.Length % 4) % 4, '=') }

    function Update-Properties([parameter(ValueFromPipeline)][PSCustomObject]$payload) {
        function UpdateTimeProperty($seconds) {
            "$seconds" + ':' + "   ($([DateTime]::UnixEpoch.AddSeconds($seconds).ToLocalTime().ToString('MMM d, h:mm:ss tt')))"
        }

        if ($null -ne $payload.nbf) {
            $payload.nbf = UpdateTimeProperty $payload.nbf
        }

        if ($null -ne $payload.exp) {
            $expireTime = ([DateTime]::UnixEpoch.AddSeconds($payload.exp) - [DateTime]::UtcNow)
            $expireOutput =
                if ($expireTime.TotalSeconds -lt 1)
                    { 'EXPIRED' }
                else
                    { "Expires in $([System.Math]::Floor($expireTime.TotalHours))h $($expireTime.Minutes)m $($expireTime.Seconds)s" }
            $payload.exp = "$(UpdateTimeProperty $payload.exp)   ($expireOutput)"
        }

        if ($null -ne $payload.iat) {
            $payload.iat = UpdateTimeProperty $payload.iat
        }

        return $payload
    }

    if ($IncludeHeader) {
        Write-Host ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($header))
            | ConvertFrom-Json | ConvertTo-Json) -ForegroundColor Blue
    }
    Write-Host ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload))
        | ConvertFrom-Json | Update-Properties | ConvertTo-Json) -ForegroundColor Green
}

function New-Jwt(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Secret,
    [ValidateSet('SHA256', 'SHA512')][string]$Algorithm ='SHA256',
    [string]$Issuer='https://auth.michaeloyer.dev',
    [string]$Audience='https://auth.michaeloyer.dev',
    [DateTime]$IssueOn=[DateTime]::UtcNow,
    [timespan]$ExpiresIn=[TimeSpan]::FromHours(1),
    #Order is important due to hashing
    [System.Collections.Specialized.OrderedDictionary]$Properties = [ordered]@{}
) {
    $Header = [ordered]@{
        'alg' = switch ($Algorithm) {
            'SHA256' { 'HS256' }
            'SHA512' { 'HS512' }
        }
        'typ'='JWT'
    } | ConvertTo-Json -Compress

    $IssueTime = [int]$($IssueOn - [DateTime]::UnixEpoch).TotalSeconds
    $Payload =
        ($Properties + [ordered]@{
            "nbf" = $IssueTime
            "exp" = $IssueTime + [int]$ExpiresIn.TotalSeconds
            "iat" = $IssueTime
            "iss" = $Issuer
            "aud" = $Audience
        })
        | ConvertTo-Json -Depth 100 -Compress

    function toBytes([parameter(ValueFromPipeline)][string]$text) {
        return [System.Text.Encoding]::Utf8.GetBytes($text)
    }

    function toBase64 ([parameter(ValueFromPipeline=$true)][byte[]]$bytes) {
        return [System.Convert]::ToBase64String($input)
    }

    function toWebBase64([parameter(ValueFromPipeline)][string]$base64Text) {
        return $base64Text.Replace('+', '-').Replace('/', '_').Replace('=','')
    }

    $Data = "$($Header | toBytes | toBase64 | toWebBase64).$($Payload | toBytes | toBase64 | toWebBase64)"

    $sha = switch ($Algorithm) {
        'SHA256' { [System.Security.Cryptography.HMACSHA256]::new((toBytes $Secret)) }
        'SHA512' { [System.Security.Cryptography.HMACSHA512]::new((toBytes $Secret)) }
    }

    $Signature = $sha.ComputeHash($($Data | toBytes)) | toBase64 | toWebBase64
    $sha.Dispose()

    return "$Data.$Signature"
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
