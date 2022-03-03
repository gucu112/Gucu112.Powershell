param()

Write-Verbose "Installing 'Gucu112.Powershell.Utility' required modules (dependencies)."
Install-Module -Name BetterTls -RequiredVersion 0.1.0

Write-Verbose "Installing 'Gucu112.Powershell.Utility' module."
Install-Module -Name Gucu112.Powershell.Utility -RequiredVersion 0.1.0
