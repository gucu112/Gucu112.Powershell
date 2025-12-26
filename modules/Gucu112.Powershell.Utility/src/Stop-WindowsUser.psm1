function Stop-WindowsUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [switch]$Force = [switch]::NotPresent
    )

    process {
        if ($PSCmdlet.ShouldProcess("Stop-WindowsUser")) {
            $flags = @(0, 4)[$Force.IsPresent]
            (Get-WmiObject Win32_OperatingSystem).Win32Shutdown($flags)
        }
    }
}
