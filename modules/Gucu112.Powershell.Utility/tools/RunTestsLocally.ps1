Import-Module 'Pester'

$configuration = [PesterConfiguration]@{
    Run = @{
        Path = (Join-Path $PSScriptRoot '..\tests')
    }
    Should = @{
        ErrorAction = 'Continue'
    }
    CodeCoverage = @{
        Enabled = $false
    }
    TestResult = @{
        Enabled = $true
        TestSuiteName = 'Gucu112.Powershell.Utility.Tests'
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
