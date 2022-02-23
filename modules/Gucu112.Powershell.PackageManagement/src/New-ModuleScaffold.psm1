function New-ModuleScaffold {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ModulePath', 'FullName')]
        [string[]]$Path,

        [Parameter()]
        [Alias('RequiredVersion')]
        [version]$Version = '0.1.0',

        # TODO: Move to Utility module and name somehow (Get-[LoggedIn]WindowsUser, Get-[Current]WindowsIdentity)
        [Parameter()]
        [Alias('ModuleAuthor')]
        [ValidateNotNullOrEmpty()]
        [string]$Author = ((Get-CIMInstance Win32_ComputerSystem).UserName -split '\\', 2 | Select-Object -Last 1),

        [Parameter()]
        [Alias('CompanyName')]
        [ValidateNotNullOrEmpty()]
        [string]$Company = 'Unknown',

        [Parameter()]
        [Alias('CopyrightText')]
        [ValidateNotNullOrEmpty()]
        [string]$Copyright = $null,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description = 'No description yet.',

        [Parameter()]
        [object[]]$RequiredModules = @(),

        [Parameter()]
        [string[]]$RequiredAssemblies = @(),

        [Parameter()]
        [string[]]$FunctionsToExport = @(),

        [Parameter()]
        [string[]]$CmdletsToExport = @(),

        [Parameter()]
        [string[]]$VariablesToExport = @(),

        [Parameter()]
        [string[]]$AliasesToExport = @(),

        [Parameter()]
        [switch]$PassThru = $false
    )
    #endregion

    #region Begin
    begin {
        # TODO: Change string to ErrorRecord for error collection list
        $errorCollection = New-Object System.Collections.Generic.List[string]

        $moduleCollection = $Path | ForEach-Object {
            # TODO: Move to Utility module and create Get-Path function
            # (of course -Path as string, -PathType enum, -IsValid false switch, -Absolute true switch)
            # $absolutePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($_)
            $absolutePath = $_
            $basePath = Resolve-Path (Split-Path $absolutePath -Parent)

            $moduleName = Split-Path $absolutePath -Leaf
            if (Test-Path $absolutePath) {
                $errorCollection.Add("A module with the specified name $moduleName already exists in '$basePath' directory.")
                return
            }

            [PSCustomObject]@{
                Name       = $moduleName
                Path       = $absolutePath
                RootModule = "$moduleName.psm1"
            }
        }

        #if ($Company -ne 'Unknown') { $Company } else { $Author }
        $copyrightOwner = @($Author, $Company)[$Company -ne 'Unknown']
        #if ($null -ne $Copyright) { $Copyright } else { 'Default' }
        $copyrightText = @("(c) $(Get-Date -Format 'yyyy') $copyrightOwner. All rights reserved.", $Copyright)[$null -ne $Copyright]
    }
    #endregion

    #region Process
    process {
        $moduleCollection | ForEach-Object {
            # TODO: Introduce new parameters
            # See (tutorial): https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-5.1
            # See (function): https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-modulemanifest?view=powershell-5.1
            $manifestParams = @{
                Path               = Join-Path $_.Path "$($_.Name).psd1"
                RootModule         = $_.RootModule
                Author             = $Author
                CompanyName        = $Company
                Copyright          = $copyrightText
                ModuleVersion      = $Version
                Description        = $Description
                PowerShellVersion  = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
                RequiredModules    = $RequiredModules
                RequiredAssemblies = $RequiredAssemblies
                # NestedModules
                FunctionsToExport  = $FunctionsToExport
                CmdletsToExport    = $CmdletsToExport
                VariablesToExport  = $VariablesToExport
                AliasesToExport    = $AliasesToExport
                # ModuleList
                # FileList
                PassThru           = $PassThru.IsPresent
            }

            # TODO: Remove after full implementation
            # $manifestParams | Format-Table | Out-Host

            if ($PSCmdlet.ShouldProcess($_.Path)) {
                New-Item -Path $_.Path -ItemType Directory | Out-Null
                New-Item -Path (Join-Path $_.Path 'src') -ItemType Directory | Out-Null
                New-Item -Path (Join-Path $_.Path 'tests') -ItemType Directory | Out-Null
                # TODO: Provide enum -RootModuleType to create additional/replace current root module file (different extensions of file)
                # See (-RootModule): https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-modulemanifest?view=powershell-5.1
                New-Item -Path (Join-Path $absolutePath "$moduleName.psm1") -ItemType File | Out-Null
            }

            if ($PSCmdlet.ShouldProcess($manifestParams.Path, 'New-ModuleManifest')) {
                New-ModuleManifest @manifestParams
            }
        }
    }
    #endregion

    #region End
    end {
        if ($errorCollection.Count -gt 0) {
            foreach ($message in $errorCollection) {
                Write-Error $message
            }
            exit 1
        }
        exit 0
    }
    #endregion
}