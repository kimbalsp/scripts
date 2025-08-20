function Get-Globals() {
	param ($config)
	$scriptFiles = Get-ChildItem $config

	foreach ($script in $scriptFiles) {
		try {
			.$script.FullName
		} catch [System.Exception]{
			throw
		}
	}
}
