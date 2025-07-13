Push-Location
try {
    Set-Location $PSScriptRoot
    Write-Verbose "Publishing Gucu112.Powershell.Utility module assemblies..."
    $modulePath = (Resolve-Path '..\..\modules\Gucu112.Powershell.Utility').Path
    dotnet publish "Gucu112.Powershell.Utility.csproj" -c Release -o "$modulePath\lib"
}
finally {
    Pop-Location
}
