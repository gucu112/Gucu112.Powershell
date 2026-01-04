Import-Module 'Pester'

$configuration = [PesterConfiguration]@{
    Run = @{
        Path = (Join-Path $PSScriptRoot '..\tests')
    }
    Output = @{
        Verbosity = 'Detailed'
    }
    TestResult = @{
        Enabled = $true
        TestSuiteName = 'Gucu112.Powershell.PackageManagement.Tests'
        OutputPath = 'logs\testResults.xml'
    }
    CodeCoverage = @{
        Enabled = $false
        Path = (Join-Path $PSScriptRoot '..\src')
        OutputPath = 'logs\coverage.xml'
    }
}

Push-Location
try {
    Set-Location (Join-Path $PSScriptRoot '..')
    Invoke-Pester -Configuration $configuration
}
finally {
    Pop-Location
}
