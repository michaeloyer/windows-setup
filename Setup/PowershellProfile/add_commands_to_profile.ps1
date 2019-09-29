$profileScript = Get-Content $profile

$importScriptLine = "Import-Module ProfileImport"
if ($profileScript -inotcontains $importScriptLine) {
    $scriptLine = "Import-Module ProfileImport"
    Add-Content -Path $profile -Value `
        "$([System.Environment]::NewLine)$scriptLine"

    Write-Host 'Adding ' -ForegroundColor Yellow
    Write-Host $scriptLine -ForegroundColor Magenta
    Write-Host 'To Profile script: ' -ForegroundColor Yellow -NoNewline
    Write-Host $profile -ForegroundColor Green
}