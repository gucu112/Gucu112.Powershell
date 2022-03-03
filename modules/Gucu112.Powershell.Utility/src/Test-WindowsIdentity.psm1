using namespace System.Security.Principal
function Test-WindowsIdentity {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias('WindowsIdentity')]
        [WindowsIdentity]$Identity = (Get-WindowsIdentity),

        [Parameter()]
        [WindowsBuiltInRole]$Role = [WindowsBuiltInRole]::Administrator
    )
    #endregion

    #region Begin
    begin {
        (New-Object WindowsPrincipal $Identity).IsInRole($Role)
    }
    #endregion
}


