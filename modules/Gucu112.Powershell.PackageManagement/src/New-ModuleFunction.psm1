function New-ModuleFunction {
    #region Documentation
    <#
    No documentation yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('FunctionName')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter(Mandatory)]
        [Alias('ModulePath', 'ModuleBasePath')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter()]
        [switch]$ErrorHandling

        # TODO: Add TestFile switch functionality (additional file for tests)
        # [Parameter()]
        # [switch]$TestFile = $false
    )
    #endregion

    #region Begin
    begin {
        # TODO: Change string to ErrorRecord for error collection list
        $errorCollection = New-Object System.Collections.Generic.List[string]

        $moduleName = Split-Path $Path -Leaf
        $absolutePath = $Path
        $basePath = Resolve-Path (Join-Path $absolutePath 'src')

        $filePath = $Name | ForEach-Object {  }

        $functionCollection = $Name | ForEach-Object {
            $filePath = Join-Path $basePath "$_.psm1"

            if (Test-Path $filePath) {
                $errorCollection.Add("A function with the specified name $_ already exists in '$moduleName' module.")
                return
            }

            [PSCustomObject]@{
                Name = $_
                Path = $filePath
            }
        }

        $fileTemplate = Get-Content -Path (Join-Path $PSScriptRoot '..\data\NewFunction.template')

        $emptyBlock = "{`n`n    }"
        $beginBlock = $emptyBlock
        $endBlock = $emptyBlock

        if ($ErrorHandling.IsPresent) {
            $beginBlock = @'
        {
            # TODO: Change string to ErrorRecord for error collection list
            $errorCollection = New-Object System.Collections.Generic.List[string]
        }
'@

            $endBlock = @'
        {
            if ($errorCollection.Count -gt 0) {
                foreach ($message in $errorCollection) {
                    Write-Error $message
                }
                exit 1
            }
            exit 0
        }
'@
        }
    }
    #endregion

    #region Process
    process {
        $functionCollection | ForEach-Object {
            if ($PSCmdlet.ShouldProcess($_.Path)) {
                New-Item -Path $_.Path -ItemType File | Out-Null

                $fileContent = $fileTemplate -replace '{{FunctionName}}', $_.Name `
                    -replace '{{Documentation}}', 'No documentation yet.' `
                    -replace '{{AliasDefinition}}', [string]::Empty `
                    -replace '{{CmdletBindings}}', [string]::Empty `
                    -replace '{{Parameters}}', [string]::Empty `
                    -replace '{{BeginBlock}}', $beginBlock `
                    -replace '{{ProcessBlock}}', $emptyBlock `
                    -replace '{{EndBlock}}', $endBlock

                $fileContent | Set-Content -Path $_.Path -Encoding UTF8
            }

            # TODO: Update module manifest (add path to NestedModules and function name to FunctionsToExport)
            # $manifestParams = Get-ModuleManifest ???
            # Update-ModuleManifest @manifestParams
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