Register-ArgumentCompleter -CommandName 'ssh' -ScriptBlock {
    param($commandName, $wordToComplete)

	switch -regex ($wordToComplete) {
		'^\s*ssh\s*$' {
			Get-Content ~/.ssh/config |
			Select-String ^Host -Raw |
			ForEach-Object { $_ -split '\s+' | Select -Skip 1 }
		}
	}
}