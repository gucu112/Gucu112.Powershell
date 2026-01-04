function Get-LocalDomain {
    #region Documentation
    <#
    .DESCRIPTION
    No description yet.
    #>
    #endregion
    [CmdletBinding(SupportsShouldProcess)]
    param ()

    process {
        if ($PSCmdlet.ShouldProcess("Get-LocalDomain")) {
            (Get-CimInstance Win32_ComputerSystem).DNSHostName
        }
    }
}
