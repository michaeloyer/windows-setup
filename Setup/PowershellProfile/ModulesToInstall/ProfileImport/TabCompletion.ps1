Register-ArgumentCompleter -Native -CommandName 'ssh' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
	
	switch -Wildcard ($commandAst) {
		'*-i' {
			Get-ChildItem ~/.ssh | 
			Select -ExpandProperty FullName |
			ForEach-Object { "$wordToComplete $_".TrimStart() }
		}
		default {
			$ssh_hosts = 
				Get-Content ~/.ssh/config -ErrorAction Ignore |
				Select-String ^Host -Raw |
				ForEach-Object { $_ -split '\s+' | Where-Object { -not [string]::IsNullOrEmpty($_) } | Select-Object -Skip 1 } |
				Sort-Object -Property @{Expression={[ipaddress]::TryParse($_, [ref]$null) }}, @{Expression={$_}}
					
			$known_hosts =
				Get-Content ~/.ssh/known_hosts -ErrorAction Ignore |
				ForEach-Object { $_ -split '\s' | Select-Object -First 1 } |
				ForEach-Object { $_ -split ',' } |
				ForEach-Object { $_ -replace '^\[' -replace '\]:\d+$' } |
				Sort-Object -Property @{Expression={[ipaddress]::TryParse($_, [ref]$null) }}, @{Expression={$_}}
				
			($ssh_hosts + $known_hosts) |
			Select-Object -Unique |
			Where-Object { $_ -like "$wordToComplete*" }
		}
	}
}

Register-ArgumentCompleter -Native -CommandName 'npm' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

	switch -Regex ($commandAst) {
		"^npm\s+run\b" {
			Get-Content .\package.json -Raw -ErrorAction Ignore |
			ConvertFrom-Json -AsHashtable -ErrorAction Ignore  |
			Select-Object -ExpandProperty scripts |
			ForEach-Object { $_.Keys } |
			Where-Object { $_ -like "$wordToComplete*" } |
			Sort-Object
		}
	}
}
