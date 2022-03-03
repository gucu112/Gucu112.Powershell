function Get-CurrentWindowsComputer {
    #region Documentation
    <#
    No documentation yet.
    See: https://docs.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-5.1
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param()
    #endregion

    #region Begin
    begin {
        # TODO: Improve to call on remote computer (ComputerName parameter)
        # See: https://docs.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-5.1#example-7--get-cim-instances-from-remote-computer
        Get-CimInstance Win32_ComputerSystem
    }
    #endregion
}


