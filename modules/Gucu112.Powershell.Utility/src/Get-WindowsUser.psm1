using namespace System.Security.Principal

function Get-WindowsUser {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding(DefaultParameterSetName = 'LocalUser')]
    param(
        [Parameter(ValueFromPipeline)]
        [Alias('WindowsIdentity')]
        # TODO: Try custom validator or something like ValidateNotEmpty()
        # [ValidateNotNull()]
        [WindowsIdentity[]]$Identity = @(Get-WindowsIdentity -Current),

        [Parameter(ParameterSetName = 'LocalUser')]
        [Alias('LocalUser')]
        [switch]$Local = [switch]::IsPresent
    )
    #endregion

    #region Begin
    begin {
        $userPropertySet = @('Domain', 'Name', 'Description', 'SID', 'Enabled', 'IsAdministrator', 'LastLogon')

        # TODO: Move to separate function (Get-DnsDomain)
        $domain = [System.Net.Dns]::GetHostName()
    }
    #endregion

    #region Process
    process {
        $Identity | ForEach-Object {
            Get-LocalUser -SID ($PSItem.User.Value) |
                Add-Member NoteProperty -Name 'Domain' -Value $domain -PassThru |
                Add-Member NoteProperty -Name 'IsAdministrator' -Value (Test-WindowsIdentity $PSItem) -PassThru |
                Select-Object -Property $userPropertySet
        }
    }
    #endregion
}


