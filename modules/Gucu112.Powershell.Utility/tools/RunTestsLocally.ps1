Import-Module 'Pester'

$configuration = [PesterConfiguration]@{
    Run = @{
        Path = (Join-Path $PSScriptRoot '..\tests')
    }
    TestResult = @{
        Enabled = $true
        TestSuiteName = 'Gucu112.Powershell.Utility.Tests'
    }
    CodeCoverage = @{
        Enabled = $false
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
