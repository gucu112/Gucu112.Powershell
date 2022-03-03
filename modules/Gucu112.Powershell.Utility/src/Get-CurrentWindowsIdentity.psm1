# TODO: Check if it is working as expected
# using namespace System.Security.Principal
function Get-CurrentWindowsIdentity {
    #region Documentation
    <#
    No documentation yet.
    See: https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsidentity.getcurrent?view=netframework-4.8#system-security-principal-windowsidentity-getcurrent
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param()
    #endregion

    #region Begin
    begin {
        [System.Security.Principal.WindowsIdentity]::GetCurrent()
    }
    #endregion
}


