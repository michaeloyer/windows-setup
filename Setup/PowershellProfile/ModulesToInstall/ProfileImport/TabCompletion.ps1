Register-ArgumentCompleter -CommandName 'ssh' -ScriptBlock {
    param($commandName, $wordToComplete)

	switch -regex ($wordToComplete) {
		'^\s*ssh\s*[*\w]*$' {
			$match = [Regex]::Match($wordToComplete, 'ssh\s+([*\w]+)')
			$hasSubcommand = $match.Success
			$subcommand = $match.Groups[1].Value
			
			Get-Content ~/.ssh/config |
			Select-String ^Host -Raw |
			ForEach-Object { $_ -split '\s+' | Select -Skip 1 } |
			Where-Object { 
				if ($hasSubcommand) 
					{ $_ -like "$subcommand*" } 
				else 
					{ $true }
				
			} |
			Sort-Object 
		}
	}
}