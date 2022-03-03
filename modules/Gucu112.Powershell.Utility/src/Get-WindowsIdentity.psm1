using namespace System.Security.Principal
function Get-WindowsIdentity {
    #region Documentation
    <#
    No documentation yet.
    Example: (Get-WindowsIdentity).Name -split '\\', 2 | Select-Object -Last 1
    See: https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsidentity.getcurrent?view=netframework-4.8#system-security-principal-windowsidentity-getcurrent
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias('WindowsIdentity')]
        [WindowsIdentity]$Identity = [WindowsIdentity]::GetCurrent()
    )
    #endregion

    #region Begin
    begin {
        $Identity
    }
    #endregion
}
