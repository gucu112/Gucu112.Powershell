function Add-PackageSource {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param(
        # TODO: Change to [string[]] and check if still working
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Name,

        [Parameter(Mandatory)]
        # TODO: Move list of available providers to configuration
        [ValidateSet('PowerShellGet', 'NuGet', 'ChocolateyGet')]
        [string]$ProviderName,

        [Parameter(Mandatory)]
        [Alias('SourceLocation')]
        [string]$Location,

        [Parameter()]
        [switch]$Trusted = $false,

        [Parameter()]
        [switch]$Force = $false
    )
    #endregion

    #region Begin
    begin {
        # TODO: Move to module configuration
        $providerVersionMap = @{
            PowerShellGet = '1.0.0.1'
            NuGet = '2.8.5.201'
            ChocolateyGet = '3.1.1'
        }

        if (-not (Get-PackageProvider -Name $ProviderName -ListAvailable -ErrorAction Ignore)) {
            Import-PackageProvider -Name $ProviderName -MinimumVersion $providerVersionMap[$ProviderName] -ErrorAction Stop
        }

        switch ($ProviderName) {
            'PowerShellGet' {
                if ($Force.IsPresent) {
                    Unregister-PSRepository -Name $Name
                }

                $installationPolicy = @('Untrusted', 'Trusted')[$Trusted.IsPresent]
                Register-PSRepository -Name $Name -SourceLocation $Location -InstallationPolicy $installationPolicy | Out-Null
            }
            default {
                if ($Force.IsPresent) {
                    # TODO: Check if it is working
                    Unregister-PackageSource -Name $Name
                    # Get-PackageSource -Name $Name -ErrorAction Ignore | Unregister-PackageSource
                }

                Register-PackageSource -Name $Name -ProviderName $ProviderName -Location $Location -Trusted:$Trusted
            }
        }
    }
    #endregion
}
