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
        [ValidateSet('PowerShellGet', 'NuGet', 'ChocolateyGet')]
        [string]$ProviderName,

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
    }
    #endregion

    #region Process
    process {
        if ($Force.IsPresent -or (-not (Get-PackageProvider -Name $ProviderName -ErrorAction Ignore))) {
            $providerVersionMap = $PSCmdlet.MyInvocation.MyCommand.Module.PrivateData.Configuration.PackageProviderVersionMap

            if ($ProviderName -eq 'PowerShellGet') {
                Install-Module 'PowerShellGet' -MinimumVersion $providerVersionMap[$ProviderName] -AllowClobber -Force:$Force -ErrorAction $ErrorAction
            }

            Install-PackageProvider -Name $ProviderName -MinimumVersion $providerVersionMap[$ProviderName] -Force:$Force -ErrorAction $ErrorAction
        }
    }
    #endregion
}
