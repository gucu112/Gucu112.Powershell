Add-Type -Path "$PSScriptRoot\..\..\bin\Release\netstandard2.0\win-x64\publish\System.Security.Principal.Windows.dll"
Add-Type -Path "$PSScriptRoot\..\..\bin\Release\netstandard2.0\win-x64\publish\Gucu112.Powershell.Utility.dll"
$process = [Gucu112.Powershell.Utility.Windows.Process]::GetSystem()
$token = New-Object Gucu112.Powershell.Utility.Windows.Token($process)
$identity = $token.GetWindowsIdentity()
Write-Host $identity.Name
