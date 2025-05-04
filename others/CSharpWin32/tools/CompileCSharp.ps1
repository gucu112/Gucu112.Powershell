param()

# Start-Job -Name 'CompileCSharp' -ScriptBlock $sb | Receive-Job -AutoRemoveJob -Wait
# Start-Process 'powershell' -ArgumentList '-EncodedCommand (Get-EncodedCommand $sb)'

Push-Location
try {
    # TODO: Implement workaround for working directory if called in different context
    Set-Location (Join-Path $PSScriptRoot '..')

    $win32Content = Get-Content -Path '.\src\Gucu112.Powershell.Utility.Win32.cs' -Raw
    Add-Type -TypeDefinition $win32Content -Language CSharp -OutputAssembly '.\bin\Gucu112.Powershell.Utility.Win32.dll'

    Get-ChildItem -Path '.\src\Gucu112.Powershell.Utility.*.cs' -Exclude '*.Utility.Win32.cs' | ForEach-Object {
        $content = Get-Content -Path $PSItem -Raw
        Add-Type -TypeDefinition $content -Language CSharp `
            -ReferencedAssemblies (Resolve-Path '.\bin\Gucu112.Powershell.Utility.Win32.dll') `
            -OutputAssembly (Join-Path '.\bin' ($PSItem.Name -replace '.cs$', '.dll'))
    }
} catch {
    # TODO: Add information about restarting session
    throw $PSItem
} finally {
    Pop-Location
}

# TODO: Add dlls to required assemblies of the module
# RequiredAssemblies = @(
#     '..\bin\Gucu112.Powershell.Utility.Win32.dll',
#     '..\bin\Gucu112.Powershell.Utility.WindowsProcess.dll',
#     '..\bin\Gucu112.Powershell.Utility.WindowsToken.dll',
# )
