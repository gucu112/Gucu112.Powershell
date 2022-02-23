function Add-PackageSource {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param(
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
            PowerShellGet = '2.2.5'
            NuGet = '2.8.5.201'
            ChocolateyGet = '3.1.1'
        }

        if (-not (Get-PackageProvider -Name $ProviderName -ListAvailable -ErrorAction Ignore)) {
            Import-PackageProvider -Name $ProviderName -MinimumVersion $providerVersionMap[$ProviderName] -ErrorAction Stop
        }

        switch ($ProviderName) {
            'PowerShellGet' {
                # TODO: Consider adding Get-PSRepository to condition
                if ($Force.IsPresent) {
                    # TODO: Check which statement can be used here
                    # Unregister-PSRepository -Name $Name
                    Get-PSRepository -Name $Name -ErrorAction Ignore | Unregister-PSRepository
                }

                $installationPolicy = @('Untrusted', 'Trusted')[$Trusted.IsPresent]

                $repositoryParams = @{
                    Name = $Name
                    SourceLocation = $Location
                    InstallationPolicy = $installationPolicy
                }

                # TODO: Check if necessary
                # if ($Location -like '*powershellgallery.com/api/v2*') {
                #     $repositoryParams = @{
                #         Default = $true
                #         InstallationPolicy = $installationPolicy
                #     }
                # }

                Register-PSRepository @repositoryParams | Out-Null
            }
            default {
                if ($Force.IsPresent -and (Get-PackageSource -Name $Name -ErrorAction Ignore)) {
                    Unregister-PackageSource -Name $Name -Force
                }

                Register-PackageSource -Name $Name -ProviderName $ProviderName -Location $Location -Trusted:$Trusted -Force:$Force
            }
        }
    }
    #endregion
}
