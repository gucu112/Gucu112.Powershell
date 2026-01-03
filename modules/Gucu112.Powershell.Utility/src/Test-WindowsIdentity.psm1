using namespace System.Security.Principal

function Test-WindowsIdentity {
    #region Documentation
    <#
    .DESCRIPTION
    No description yet.
    See: https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsbuiltinrole?view=netframework-4.8
    See: https://docs.microsoft.com/en-us/dotnet/api/system.security.principal.windowsprincipal.isinrole?view=netframework-4.8
    #>
    #endregion

    #region Parameters
    [CmdletBinding(DefaultParameterSetName = 'Administrator', SupportsShouldProcess)]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0)]
        [Alias('WindowsIdentity')]
        [ValidateNotNull()]
        [WindowsIdentity]$Identity = (Get-WindowsIdentity -Current),

        [Parameter(ParameterSetName = 'WindowsBuiltInRole')]
        [Alias('WindowsBuiltInRole')]
        [ValidateNotNull()]
        [WindowsBuiltInRole]$Role,

        [Parameter(ParameterSetName = 'Administrator')]
        [Alias('AdministratorRole')]
        [switch]$Administrator = [switch]::Present,

        [Parameter(ParameterSetName = 'User')]
        [Alias('UserRole')]
        [switch]$User = [switch]::NotPresent,

        [Parameter(ParameterSetName = 'Guest')]
        [Alias('GuestRole')]
        [switch]$Guest = [switch]::NotPresent
    )
    #endregion

    #region Begin
    begin {
        if ($PSCmdlet.ShouldProcess('$Role', 'Set-WindowsRole')) {
            if ($Administrator.IsPresent) {
                $Role = [WindowsBuiltInRole]::Administrator
            } elseif ($User.IsPresent) {
                $Role = [WindowsBuiltInRole]::User
            } elseif ($Guest.IsPresent) {
                $Role = [WindowsBuiltInRole]::Guest
            }
        }

        if ($PSCmdlet.ShouldProcess('$Identity, $Role', 'Test-WindowsRole')) {
            $Principal = New-Object WindowsPrincipal $Identity
            $Principal.IsInRole($Role)
        }
    }
    #endregion
}


