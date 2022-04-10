using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation
function New-ModuleScaffold {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding(SupportsShouldProcess, PositionalBinding = $false)]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ModulePath', 'ModuleBasePath', 'FullName')]
        [string[]]$Path,

        [Parameter(Position = 1)]
        [Alias('ModuleVersion', 'RequiredVersion')]
        [version]$Version = '0.1.0',

        # TODO: Use function from Utility module instead - (Get-WindowsUser).Name
        [Parameter()]
        [Alias('ModuleAuthor')]
        [ValidateNotNullOrEmpty()]
        [string]$Author = ((Get-CimInstance Win32_ComputerSystem).UserName -split '\\', 2 | Select-Object -Last 1),

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

        # TODO: Check if it is working correctly with object[] type
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

        # TODO: Implement adding configuration object
        # [Parameter()]
        # [object]$Configuration = @{},

        [Parameter(Position = 2)]
        [Alias('Loader')]
        [switch]$LoaderModule = [switch]::NotPresent,

        [Parameter()]
        [switch]$PassThru = [switch]::NotPresent
    )
    #endregion

    #region Begin
    begin {
        $errorCollection = New-Object List[ErrorRecord]
        $moduleCollection = New-Object List[PSCustomObject]

        $copyrightOwner = @($Author, $Company)[$Company -ne 'Unknown']
        $copyrightText = @("(c) $(Get-Date -Format 'yyyy') $copyrightOwner. All rights reserved.", $Copyright)[$null -ne $Copyright]

        if ($LoaderModule.IsPresent) {
            $loaderManifestTemplate = Get-Content -Path (Join-Path $PSScriptRoot '..\data\LoaderModuleManifest.template')
            $loaderScriptTemplate = Get-Content -Path (Join-Path $PSScriptRoot '..\data\InstallModuleScript.template')
        }

        # TODO: Introduce new parameters
        # See (tutorial): https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-5.1
        # See (function): https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-modulemanifest?view=powershell-5.1
        $baseManifestParams = @{
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
            PassThru           = $PassThru
        }
    }
    #endregion

    #region Process
    process {
        $moduleCollection.Add([PSCustomObject]@{
            Name = Split-Path $Path -Leaf
            Path = $Path
        })
    }
    #endregion

    #region End
    end {
        $moduleCollection | ForEach-Object {
            $newManifestParams = $baseManifestParams + @{
                Path               = Join-Path $PSItem.Path "$($PSItem.Name).psd1"
                RootModule         = "$($PSItem.Name).psm1"
            }

            # TODO: Replace with Get-Path -Absolute
            $baseModulePath = Join-Path $PSItem.Path '..'
            if (-not (Test-Path $baseModulePath -PathType Container)) {
                $exception = New-Object DirectoryNotFoundException `
                    "Cannot find directory '$baseModulePath' because it does not exist."
                $errorCollection.Add((New-Object ErrorRecord $exception, 'New-ModuleScaffold', 'ObjectNotFound', $PSItem))
                return
            }

            if (Test-Path $PSItem.Path) {
                $exception = New-Object DirectoryFoundException `
                    "A module with the specified name $($PSItem.Name) already exists in '$($PSItem.Path)' directory."
                $errorCollection.Add((New-Object ErrorRecord $exception, 'New-ModuleScaffold', 'ResourceExists', $PSItem))
                return
            }

            if ($PSCmdlet.ShouldProcess($PSItem.Path)) {
                New-Item -Path $PSItem.Path -ItemType Directory | Out-Null
                New-Item -Path (Join-Path $PSItem.Path '.\src') -ItemType Directory | Out-Null
                New-Item -Path (Join-Path $PSItem.Path '.\tests') -ItemType Directory | Out-Null
                New-Item -Path (Join-Path $PSItem.Path '.\tools') -ItemType Directory | Out-Null
                New-Item -Path (Join-Path $PSItem.Path $newManifestParams.RootModule) -ItemType File | Out-Null
            }

            $loaderScriptPath = (Join-Path $PSItem.Path ".\tools\InstallModule.ps1")
            if ($LoaderModule.IsPresent -and $PSCmdlet.ShouldProcess($loaderScriptPath, 'New-ScriptFile')) {
                New-Item -Path $loaderScriptPath -ItemType File | Out-Null

                $scriptContent = $loaderScriptTemplate -replace '{{ModuleName}}', $PSItem.Name `
                	-replace '{{Version}}', $newManifestParams.ModuleVersion

                $scriptContent | Set-Content -Path $loaderScriptPath -Encoding UTF8
            }

            $loaderModulePath = (Join-Path $PSItem.Path "$($PSItem.Name).Loader.psd1")
            if ($LoaderModule.IsPresent -and $PSCmdlet.ShouldProcess($loaderModulePath, 'New-ModuleLoaderManifest')) {
                New-Item -Path $loaderModulePath -ItemType File | Out-Null

                $loaderContent = $loaderManifestTemplate -replace '{{NewGuid}}', (New-Guid) `
                	-replace '{{Version}}', $newManifestParams.ModuleVersion `
                    -replace '{{Author}}', $newManifestParams.Author `
                    -replace '{{Company}}', $newManifestParams.CompanyName `
                    -replace '{{Copyright}}', $newManifestParams.Copyright `
                    -replace '{{Description}}', "$($PSItem.Name) module loader." `
                    -replace '{{PSVersion}}', $newManifestParams.PowerShellVersion `
                    -replace '{{ScriptsToProcess}}', "'.\tools\InstallModule.ps1'"

                $loaderContent | Set-Content -Path $loaderModulePath -Encoding UTF8
            }

            if ($PSCmdlet.ShouldProcess($newManifestParams.Path, 'New-ModuleManifest')) {
                New-ModuleManifest @newManifestParams
            }

            # TODO: Resolve issue with formatting
            # if ($PSCmdlet.ShouldProcess($newManifestParams.Path, 'Update-ModuleManifest')) {
            #     $updateModuleManifest = @{
            #         Path = $newManifestParams.Path
            #         RequireLicenseAcceptance = $false
            #     }

            #     if ($newManifestParams.RequiredModules.Count -gt 0) {
            #         $updateModuleManifest.Add('RequiredModules', $newManifestParams.RequiredModules)
            #         $updateModuleManifest.Add('ExternalModuleDependencies', $newManifestParams.RequiredModules)
            #     }

            #     Update-ModuleManifest @updateModuleManifest
            # }

            # TODO: Resolve issue with formatting and missing configuration properties after update
            # if ($PSCmdlet.ShouldProcess($newManifestParams.Path, 'Update-ModuleManifestConfiguration') {
            #     $updateModuleManifest = @{
            #         PrivateData = @{
            #             Configuration = '{{Configuration}}'
            #         }
            #         PassThru = $true
            #     }

            #     $moduleManifestTemplate = Update-ModuleManifest @updateModuleManifest

            #     $moduleManifestContent = $moduleManifestTemplate `
            #         -replace '#Configuration', '# Custom configuration properties' `
            #         -replace "'{{Configuration}}'", "@{`n`n        Name = 'Value'`n`n    } # End of Configuration hashtable"

            #     if ($newManifestParams.CmdletsToExport.Count -eq 0) {
            #         $moduleManifestContent = $moduleManifestContent -replace '^CmdletsToExport', '# CmdletsToExport'
            #     }

            #     if ($newManifestParams.AliasesToExport.Count -eq 0) {
            #         $moduleManifestContent = $moduleManifestContent -replace '^AliasesToExport', '# AliasesToExport'
            #     }

            #     $moduleManifestContent | Set-Content -Path $updateModuleManifest.Path -Encoding UTF8
            # }
        }

        if ($errorCollection.Count -gt 0) {
            foreach ($errorRecord in $errorCollection | Select-Object -SkipLast 1) {
                Write-Error $errorRecord
            }
            throw $errorCollection | Select-Object -Last 1
        }
    }
    #endregion
}
