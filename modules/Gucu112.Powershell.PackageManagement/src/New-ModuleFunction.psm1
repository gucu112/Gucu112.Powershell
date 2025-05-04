using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation
function New-ModuleFunction {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [Alias('ModulePath', 'ModuleBasePath')]
        # TODO: Consider custom validator
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('FunctionName')]
        # TODO: Consider custom validator
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter()]
        [switch]$ErrorHandling = [switch]::Present,

        [Parameter()]
        [Alias('AddTestFile')]
        [switch]$TestFile = [switch]::Present
    )
    #endregion

    #region Begin
    begin {
        $errorCollection = New-Object List[ErrorRecord]
        $functionCollection = New-Object List[PSCustomObject]

        $basePath = Resolve-Path $Path
        $moduleName = Split-Path $basePath -Leaf
        # $moduleManifestPath = Join-Path $basePath "$moduleName.psd1"

        $regularFileTemplate = Get-Content -Path (Join-Path $PSScriptRoot '..\data\FunctionFile.template')

        if ($TestFile.IsPresent) {
            $testFileTemplate = Get-Content -Path (Join-Path $PSScriptRoot '..\data\FunctionTestFile.template')
        }

        $emptyBlock = "{`n`n    }"
        $beginBlock = $emptyBlock
        $endBlock = $emptyBlock

        if ($ErrorHandling.IsPresent) {
            $beginBlock = @'
{
        $errorCollection = New-Object System.Collections.Generic.List[System.Management.Automation.ErrorRecord]
    }
'@

            $endBlock = @'
{
        if ($errorCollection.Count -gt 0) {
            foreach ($errorRecord in $errorCollection | Select-Object -SkipLast 1) {
                Write-Error $errorRecord
                # TODO: Extract exception and inner exception if necessary
            }
            throw $errorCollection | Select-Object -Last 1
        }
    }
'@
        }
    }
    #endregion

    #region Process
    process {
        $functionCollection.Add(@{
            Name = $Name
            Path = Join-Path $basePath ".\src\$Name.psm1"
        })
    }
    #endregion

    #region End
    end {
        $functionCollection | ForEach-Object {
            if (Test-Path $PSItem.Path) {
                $exception = New-Object FileFoundException `
                    "A function with the specified name $($PSItem.Name) already exists in '$moduleName' module."
                $errorCollection.Add((New-Object ErrorRecord $exception, 'New-ModuleFunction', 'ResourceExists', $PSItem))
                return
            }

            if ($PSCmdlet.ShouldProcess($PSItem.Path, 'New-ModuleFunctionFile')) {
                New-Item -Path $PSItem.Path -ItemType File | Out-Null

                $fileContent = $regularFileTemplate -replace '{{FunctionName}}', $PSItem.Name `
                    -replace '{{Documentation}}', 'No documentation yet.' `
                    -replace '{{AliasDefinition}}', [string]::Empty `
                    -replace '{{CmdletBindings}}', [string]::Empty `
                    -replace '{{Parameters}}', [string]::Empty `
                    -replace '{{BeginBlock}}', $beginBlock `
                    -replace '{{ProcessBlock}}', $emptyBlock `
                    -replace '{{EndBlock}}', $endBlock

                $fileContent | Set-Content -Path $PSItem.Path -Encoding UTF8
            }

            $testFilePath = Join-Path $basePath ".\tests\$functionName.Tests.ps1"
            if ($TestFile.IsPresent -and $PSCmdlet.ShouldProcess($testFilePath, 'New-ModuleFunctionTestFile')) {
                New-Item -Path $testFilePath -ItemType File | Out-Null

                $testFileContent = $testFileTemplate -replace '{{FunctionName}}', $PSItem.Name

                $testFileContent | Set-Content -Path $testFilePath -Encoding UTF8
            }

            # TODO: Resolve issue with formatting and missing configuration properties after update
            # if ($PSCmdlet.ShouldProcess($moduleManifestPath, 'Update-ModuleManifest')) {
            #     $manifestParams = Get-ModuleManifest -Path $moduleManifestPath

            #     $nestedModules = @(@(@(), $manifestParams.NestedModules)[$null -ne $manifestParams.NestedModules])
            #     $functionsToExport = @(@(@(), $manifestParams.FunctionsToExport)[$null -ne $manifestParams.FunctionsToExport])

            #     $updateManifestParams = @{
            #         Path = $moduleManifestPath
            #         NestedModules = $nestedModules + ".\src\$($PSItem.Name).psm1" | Sort-Object
            #         FunctionsToExport = $functionsToExport + $PSItem.Name | Sort-Object
            #     }

            #     # TODO: Investigate why configuration hashtable is broken
            #     Update-ModuleManifest @updateManifestParams
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
