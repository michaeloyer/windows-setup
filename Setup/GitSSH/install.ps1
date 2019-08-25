$sshPath = $(where.exe ssh | Select-Object -First 1)

#Add To Process and User Environment Variable

$EnvVar = 'GIT_SSH'
Write-Host 'Setting ' -ForegroundColor Yellow -NoNewline
Write-Host $EnvVar -ForegroundColor Green -NoNewline
Write-Host ' to value ' -ForegroundColor Yellow -NoNewline
Write-Host $sshPath -ForegroundColor Green

[System.Environment]::SetEnvironmentVariable($EnvVar, $sshPath)
[System.Environment]::SetEnvironmentVariable($EnvVar, $sshPath, 'USER')

Write-Host 'Set' -ForegroundColor Yellow