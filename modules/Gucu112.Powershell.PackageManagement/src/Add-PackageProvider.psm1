# TODO: Check if running as administrator in function body
# #requires -RunAsAdministrator
function Add-PackageProvider {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Alias('Name')]
        # TODO: Move list of available providers to configuration
        [ValidateSet('PowerShellGet', 'NuGet', 'ChocolateyGet')]
        [string]$ProviderName,

        [Parameter()]
        [switch]$Force = $false
    )
    #endregion

    #region Begin
    begin {
        if ($Force.IsPresent -or (-not (Get-PackageProvider -Name $ProviderName -ErrorAction Ignore))) {
            Install-PackageProvider -Name $ProviderName -Force:$Force
        }
    }
    #endregion
}
