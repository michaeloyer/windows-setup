function Get-TabCompleteContext($wordToComplete, $commandAst) {
    if ($commandAst -notmatch ' ') {
        return ''
    }

    $subCommands = ($commandAst -split ' ', 2)[1].Trim() -replace '\s+', ' ' `
        -replace '(\B|\s)\-.*(?=\s\-)', ""

    $context = ($subCommands -replace ([Regex]::Escape($wordToComplete) + "$"), '').Trim() `
        -replace '\s+' + [Regex]::Escape($wordToComplete) + "$", ''

    return $context
}

Register-ArgumentCompleter -Native -CommandName 'scoop' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $context = Get-TabCompleteContext $wordToComplete $commandAst

    switch ($context) {
        'update' {
            $AppList = $(scoop list 6>$null) |
            Select-Object -ExpandProperty Name

            @('*') + $AppList |
            Where-Object { $_ -like "$wordToComplete*" }
        }

        '' {
            $(scoop help) |
            Where-Object { $_.FormatEntryInfo -ne $null } |
            ForEach-Object { $_.FormatEntryInfo.FormatPropertyFieldList[0].PropertyValue.TrimEnd() } |
            Where-Object { $_ -like "$wordToComplete*" }
        }
    }
}

Register-ArgumentCompleter -Native -CommandName 'ssh' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $context = Get-TabCompleteContext $wordToComplete $commandAst

    switch ($context) {
        '-i' {
            Get-ChildItem ~/.ssh |
            Select-Object -ExpandProperty FullName |
            ForEach-Object { "$wordToComplete $_".TrimStart() }
        }
        '' {
            $ssh_hosts =
            Get-Content ~/.ssh/config -ErrorAction Ignore |
            Select-String ^Host -Raw |
            ForEach-Object { $_ -split '\s+' | Where-Object { -not [string]::IsNullOrEmpty($_) } | Select-Object -Skip 1 } |
            Sort-Object -Property @{Expression = { [ipaddress]::TryParse($_, [ref]$null) } }, @{Expression = { $_ } }

            $known_hosts =
            Get-Content ~/.ssh/known_hosts -ErrorAction Ignore |
            ForEach-Object { $_ -split '\s' | Select-Object -First 1 } |
            ForEach-Object { $_ -split ',' } |
            ForEach-Object { $_ -replace '^\[' -replace '\]:\d+$' } |
            Sort-Object -Property @{Expression = { [ipaddress]::TryParse($_, [ref]$null) } }, @{Expression = { $_ } }

			($ssh_hosts + $known_hosts) |
            Select-Object -Unique |
            Where-Object { $_ -like "$wordToComplete*" }
        }
    }
}

Register-ArgumentCompleter -Native -CommandName 'npm' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $context = Get-TabCompleteContext $wordToComplete $commandAst

    switch ($context) {
        'run' {
            Get-Content .\package.json -Raw -ErrorAction Ignore |
            ConvertFrom-Json -AsHashtable -ErrorAction Ignore  |
            Select-Object -ExpandProperty scripts |
            ForEach-Object { $_.Keys } |
            Where-Object { $_ -like "$wordToComplete*" } |
            Sort-Object
        }
        '' {
            @('run', 'access', 'adduser', 'audit', 'bin', 'bugs', 'c', 'cache', 'ci', 'cit',
                'clean-install', 'clean-install-test', 'completion', 'config',
                'create', 'ddp', 'dedupe', 'deprecate', 'dist-tag', 'docs', 'doctor',
                'edit', 'explore', 'get', 'help', 'help-search', 'hook', 'i', 'init',
                'install', 'install-ci-test', 'install-test', 'it', 'link', 'list', 'ln',
                'login', 'logout', 'ls', 'org', 'outdated', 'owner', 'pack', 'ping', 'prefix',
                'profile', 'prune', 'publish', 'rb', 'rebuild', 'repo', 'restart', 'root',
                'run-script', 's', 'se', 'search', 'set', 'shrinkwrap', 'star',
                'stars', 'start', 'stop', 't', 'team', 'test', 'token', 'tst', 'un',
                'uninstall', 'unpublish', 'unstar', 'up', 'update', 'v', 'version', 'view',
                'whoami') |
            Where-Object { $_ -like "$wordToComplete*" }
        }
    }
}

Register-ArgumentCompleter -Native -CommandName 'nvm' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $context = Get-TabCompleteContext $wordToComplete $commandAst

    switch ($context) {
        '' {
            return nvm --help |
            Select-String 'nvm' |
            ForEach-Object { ($_ -split '\s+', 4)[2] } |
            Where-Object { $_ -like "$wordToComplete*" }
        }
        'use' {
            return nvm list |
            Where-Object { $_ -match '\d+' -and $_ -notmatch '\*' } |
            ForEach-Object { ($_ -split '[\*\s]+')[1] } |
            Where-Object { $_ -like "$wordToComplete*" }

        }
    }
}