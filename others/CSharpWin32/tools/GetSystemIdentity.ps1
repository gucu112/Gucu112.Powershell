# TODO: Check if it is working with elevated privileges
$process = [Gucu112.Powershell.Utility.WindowsProcess]::GetSystem()
$token = New-Object Gucu112.Powershell.Utility.WindowsToken($process)
$Identity = $token.GetWindowsIdentity()
$System = [switch]::Present
