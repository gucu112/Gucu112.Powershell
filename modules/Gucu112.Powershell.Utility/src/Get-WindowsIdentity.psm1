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
    [OutputType([System.Security.Principal.WindowsIdentity])]
    param(
        [Parameter(ParameterSetName = 'WindowsIdentity')]
        [Alias('WindowsIdentity')]
        [ValidateNotNull()]
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
        if ($PSCmdlet.ShouldProcess('$Identity', 'Set-WindowsIdentity')) {
            switch ($PSCmdlet.ParameterSetName) {
                'Current' {
                    $Identity = [WindowsIdentity]::GetCurrent()
                    $Current = [switch]::Present
                }
                'Anonymous' {
                    $Identity = [WindowsIdentity]::GetAnonymous()
                    $Anonymous = [switch]::Present
                }
                'Explorer' {
                    throw (New-Object NotImplementedException 'Not implemented yet.')
                }
            }
        }

        if (-not $Anonymous.IsPresent) {
            if ($PSCmdlet.ShouldProcess('$Identity.Token', 'New-WindowsIdentity')) {
                New-Object WindowsIdentity $Identity.Token
            }
        } else {
            if ($PSCmdlet.ShouldProcess('$Identity')) {
                $Identity
            }
        }
    }
    #endregion
}


