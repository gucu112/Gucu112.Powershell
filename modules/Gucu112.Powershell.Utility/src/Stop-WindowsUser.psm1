function Stop-WindowsUser {
    #region Documentation
    <#
    .DESCRIPTION
    No description yet.
    #>
    #endregion
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [switch]$Force = [switch]::NotPresent
    )

    process {
        if ($PSCmdlet.ShouldProcess("Stop-WindowsUser")) {
            $flags = @(0, 4)[$Force.IsPresent]
            Invoke-CimMethod -ClassName Win32_OperatingSystem -MethodName Win32Shutdown -Arguments @{ Flags = $flags }
        }
    }
}
