using namespace Gucu112.Powershell.Utility.Windows
using namespace System.Security.Principal

function Get-WindowsIdentity {
    #region Documentation
    <#
    No documentation yet.
    See: https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsidentity.getcurrent?view=netframework-4.8#system-security-principal-windowsidentity-getcurrent
    #>
    #endregion

    #region Parameters
    [CmdletBinding(DefaultParameterSetName = 'Current', SupportsShouldProcess)]
    [OutputType([WindowsIdentity])]
    param(
        [Parameter(ParameterSetName = 'WindowsIdentity')]
        [Alias('WindowsIdentity')]
        [WindowsIdentity]$Identity,

        [Parameter(ParameterSetName = 'Current')]
        [Alias('CurrentIdentity')]
        [switch]$Current = [switch]::Present,

        [Parameter(ParameterSetName = 'Anonymous')]
        [Alias('AnonymousIdentity')]
        [switch]$Anonymous = [switch]::NotPresent,

        [Parameter(ParameterSetName = 'Explorer')]
        [Alias('ExplorerIdentity')]
        [switch]$Explorer = [switch]::NotPresent
    )
    #endregion

    #region Begin
    begin {
        switch ($PSCmdlet.ParameterSetName) {
            'Current' {
                $Token = New-Object Token ([Process]::GetCurrent())
                $Current = [switch]::Present
            }
            'Anonymous' {
                $Identity = [WindowsIdentity]::GetAnonymous()
                $Current = [switch]::NotPresent
                $Anonymous = [switch]::Present
            }
            'Explorer' {
                $Token = New-Object Token ([Process]::GetExplorer())
                $Current = [switch]::NotPresent
                $Explorer = [switch]::Present
            }
        }

        if ($null -eq $Identity) {
            if ($PSCmdlet.ShouldProcess('$Identity', 'Set-WindowsIdentity')) {
                $Identity = $Token.GetWindowsIdentity()
            }
        }

        if ($PSCmdlet.ShouldProcess('$Identity', 'Get-WindowsIdentity')) {
            $Identity
        }
    }
    #endregion
}


