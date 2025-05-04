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
        [ValidateSet('PowerShellGet', 'NuGet', 'ChocolateyGet')]
        [string]$ProviderName,

        [Parameter(Mandatory)]
        [Alias('SourceLocation')]
        [string]$Location,

        [Parameter()]
        [switch]$Trusted = [switch]::NotPresent,

        [Parameter()]
        [switch]$Force = [switch]::NotPresent
    )
    #endregion

    #region Begin
    begin {
        $ErrorAction = $PSCmdlet.MyInvocation.BoundParameters.ErrorAction
        if ($null -eq $ErrorAction) {
            $ErrorAction = $ErrorActionPreference
        }

        $providerVersionMap = $PSCmdlet.MyInvocation.MyCommand.Module.PrivateData.Configuration.PackageProviderVersionMap

        if ($Force.IsPresent -or (-not (Get-PackageProvider -Name $ProviderName -ListAvailable -ErrorAction Ignore))) {
            Import-PackageProvider -Name $ProviderName -MinimumVersion $providerVersionMap[$ProviderName] -Force:$Force -ErrorAction Stop | Out-Null
        }
    }

    #region Process
    process {
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

                Register-PSRepository @repositoryParams -ErrorAction $ErrorAction | Out-Null
            }
            default {
                if ($Force.IsPresent -and (Get-PackageSource -Name $Name -ErrorAction Ignore)) {
                    Unregister-PackageSource -Name $Name -Force
                }

                Register-PackageSource -Name $Name -ProviderName $ProviderName -Location $Location -Trusted:$Trusted -Force:$Force -ErrorAction $ErrorAction
            }
        }
    }
    #endregion
}
