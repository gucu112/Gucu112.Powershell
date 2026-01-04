$publishPath = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\modules\Gucu112.Powershell.Utility\lib')).Path
Add-Type -Path "$publishPath\System.Security.Principal.Windows.dll"
Add-Type -Path "$publishPath\Gucu112.Powershell.Utility.dll"
$process = [Gucu112.Powershell.Utility.Windows.Process]::GetExplorer()
$token = New-Object Gucu112.Powershell.Utility.Windows.Token($process)
$identity = $token.GetWindowsIdentity()
Write-Host $identity.Name
