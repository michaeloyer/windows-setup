$Destination = ($env:PSModulePath -split ';' | Select-Object -First 1)

Get-ChildItem $PSScriptRoot\ModulesToInstall -Directory | % { 
    Copy-Item -Path $_.FullName -Destination $Destination -Force -Recurse

    Write-Host 'Copied ' -ForegroundColor Yellow -NoNewline
    Write-Host 'ProfileImport' -ForegroundColor Green -NoNewline
    Write-Host ' to User Modules folder ' -ForegroundColor Yellow -NoNewline
    Write-Host $Destination -ForegroundColor Green
}