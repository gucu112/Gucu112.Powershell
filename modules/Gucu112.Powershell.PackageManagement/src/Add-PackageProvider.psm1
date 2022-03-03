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
            # TODO: Check if prompt is running with elevated privileges
            # Message: Administrator rights are required to install '$ProviderName' package provider.
            # Log on to the computer with an account that has Administrator rights, and then try again.
            # You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).

            if ($ProviderName -eq 'PowerShellGet') {
                Install-Module 'PowerShellGet' -AllowClobber -Force:$Force
            }

            Install-PackageProvider -Name $ProviderName -Force:$Force
        }
    }
    #endregion
}
