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

        if ($Force.IsPresent -or (-not (Get-PackageProvider -Name $ProviderName -ListAvailable -ErrorAction Ignore))) {
            Import-PackageProvider -Name $ProviderName -MinimumVersion $providerVersionMap[$ProviderName] -ErrorAction Stop -Force:$Force | Out-Null
        }

        switch ($ProviderName) {
            'PowerShellGet' {
                if ($Force.IsPresent -and (Get-PSRepository -Name $Name -ErrorAction Ignore)) {
                    Unregister-PSRepository -Name $Name
                }

                $installationPolicy = @('Untrusted', 'Trusted')[$Trusted.IsPresent]

                $repositoryParams = @{
                    Name = $Name
                    SourceLocation = $Location
                    InstallationPolicy = $installationPolicy
                }

                if ($Location -like '*powershellgallery.com/api/v2*') {
                    $repositoryParams = @{
                        Default = $true
                        InstallationPolicy = $installationPolicy
                    }
                }

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
