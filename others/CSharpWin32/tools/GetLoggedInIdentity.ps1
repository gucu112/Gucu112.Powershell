$process = [Gucu112.Powershell.Utility.WindowsProcess]::GetExplorer()
$token = New-Object Gucu112.Powershell.Utility.WindowsToken($process)
$Identity = $token.GetWindowsIdentity()
$LoggedIn = [switch]::Present
