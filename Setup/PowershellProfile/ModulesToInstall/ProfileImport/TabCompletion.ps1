Register-ArgumentCompleter -CommandName 'ssh' -ScriptBlock {
    param($commandName, $wordToComplete)
	
	function Get-Hosts() {	
		$ssh_hosts = 
			Get-Content ~/.ssh/config -ErrorAction Ignore |
			Select-String ^Host -Raw |
			ForEach-Object { $_ -split '\s+' | Where-Object { -not [string]::IsNullOrEmpty($_) } | Select-Object -Skip 1 } |
			Sort-Object -Property @{Expression={[ipaddress]::TryParse($_, [ref]$null) }}, @{Expression={$_}}
					
		$known_hosts = 
			Get-Content ~/.ssh/known_hosts  -ErrorAction Ignore | 
			ForEach-Object { $_ -split '\s' | Select-Object -First 1 } | 
			ForEach-Object { $_ -split ',' } |
			ForEach-Object { $_ -replace '^\[' -replace '\]:\d+$' } |
			Sort-Object -Property @{Expression={[ipaddress]::TryParse($_, [ref]$null) }}, @{Expression={$_}}
			
		($ssh_hosts + $known_hosts) | Select-Object -Unique
	}
	
	switch -regex ($wordToComplete) {
		'-i$' {
			Get-ChildItem ~/.ssh | Select -ExpandProperty FullName
		}
		'\s[\*\w\.]+$' {
			$partialHost = $($wordToComplete -split ' ' | Select-Object -Last 1)
			Get-Hosts | Where-Object { $_ -like "$partialHost*" }
		}
		default { 
			Get-Hosts 
		}
	}
}

Register-ArgumentCompleter -CommandName 'npm' -ScriptBlock {
    param($commandName, $wordToComplete)

	switch -regex ($wordToComplete) {
		'^\s*npm\s+run\s*$' {
			Get-Content .\package.json -Raw | 
			ConvertFrom-Json -AsHashtable | 
			Select-Object -ExpandProperty scripts | 
			ForEach-Object { $_.Keys } |
			Sort-Object 
		}
	}
}