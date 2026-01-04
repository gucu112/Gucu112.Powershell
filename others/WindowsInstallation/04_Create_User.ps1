param(
    [string]$UserName = "User",
    [string]$FullName = [string]::Empty,
    [string]$Description = [string]::Empty
)

$modulePath = '..\..\modules\Gucu112.Powershell.Utility\tools\InstallModule.ps1'
Invoke-Expression -Command "& $((Resolve-Path (Join-Path $PSScriptRoot $modulePath)).Path)"

if (-not (Test-WindowsIdentity -Administrator)) {
    Start-Process -FilePath "powershell" -Verb "RunAs" `
        -ArgumentList @("-File", $($MyInvocation.MyCommand.Path)) `
        -WorkingDirectory $PSScriptRoot
    exit
}

# TODO: Check if password does not need to be set
New-LocalUser -Name $UserName -FullName $FullName -Description $Description `
    -NoPassword -AccountNeverExpires
Add-LocalGroupMember -Group "Users" -Member $UserName
