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
        $ErrorAction = $PSCmdlet.MyInvocation.BoundParameters.ErrorAction
        if ($null -eq $ErrorAction) {
            $ErrorAction = $ErrorActionPreference
        }
    }
    #endregion

    #region Process
    process {
        if ($Force.IsPresent -or (-not (Get-PackageProvider -Name $ProviderName -ErrorAction Ignore))) {
            if ($ProviderName -eq 'PowerShellGet') {
                Install-Module 'PowerShellGet' -AllowClobber -Force:$Force -ErrorAction $ErrorAction
            }

            Install-PackageProvider -Name $ProviderName -Force:$Force -ErrorAction $ErrorAction
        }
    }
    #endregion
}
