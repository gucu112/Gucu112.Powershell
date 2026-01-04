using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation

function Get-ModuleManifest {
    #region Documentation
    <#
    .DESCRIPTION
    No description yet.
    #>
    #endregion

    #region Parameters
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('ModulePath', 'ModuleManifestPath', 'FullName')]
        [string[]]$Path
    )
    #endregion

    #region Begin
    begin {
        $errorCollection = New-Object List[ErrorRecord]
        $moduleManifestCollection = New-Object List[string]
    }
    #endregion

    #region Process
    process {
        $moduleManifestCollection.Add($Path)
    }
    #endregion

    #region End
    end {
        $moduleManifestCollection | ForEach-Object {
            if (-not (Test-Path $PSItem -PathType Leaf)) {
                $exception = New-Object FileNotFoundException `
                    "Cannot find module manifest file '$PSItem' because it does not exist."
                $errorCollection.Add((New-Object ErrorRecord $exception, 'Get-ModuleManifest', 'ObjectNotFound', $PSItem))
                return
            }

            $moduleManifestPath = Resolve-Path $PSItem
            $moduleManifestContent = Get-Content -Path $moduleManifestPath |
                ForEach-Object { $PSItem -replace '^(.*)\s*#.*$', '$1' } |
                Where-Object { -not [string]::IsNullOrWhitespace($PSItem) }
            $moduleManifestScriptBlock = [scriptblock]::Create(($moduleManifestContent -join "`n"))

            @{ Path = $moduleManifestPath } + (Invoke-Command $moduleManifestScriptBlock)
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
