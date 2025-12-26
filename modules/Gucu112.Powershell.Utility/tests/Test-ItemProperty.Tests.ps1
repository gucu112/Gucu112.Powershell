Describe "Test-ItemProperty" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\Test-ItemProperty.psm1')

        $script:HKCU_Environment = "HKCU:\Environment"
        $script:HKCU_Software = "HKCU:\Software"
    }

    AfterAll {
        Remove-Module 'Test-ItemProperty' -Force
    }

    It "does have proper parameters" {
        Get-Command Test-ItemProperty | Should -HaveParameter Path -Type ([string]) -Mandatory
        Get-Command Test-ItemProperty | Should -HaveParameter Name -Type ([string])
    }

    Context "unit tests" {
        BeforeEach {
            Mock Test-ItemProperty {}
        }

        It "works" {
            $testPath = Join-Path $script:HKCU_Software "Test"

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "TestProperty" }

            $scriptBlock | Should -Not -Throw

            $null = Invoke-Command $scriptBlock

            Should -Invoke Test-ItemProperty -Times 1
        }
    }

    Context "e2e tests" {
        It "returns false for non-existent path" {
            $notExistentPath = "TestDrive:\NonExistentPath"

            $scriptBlock = { Test-ItemProperty -Path $notExistentPath -Name "SomeProperty" }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $false
        }

        It "returns true for existent path if property name not provided" {
            $testPath = $script:HKCU_Software

            $scriptBlock = { Test-ItemProperty -Path $testPath }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $true
        }

        It "returns false for existent path but non-existent property" {
            $testPath = $script:HKCU_Software

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "NonExistentProperty" }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $false
        }

        It "returns true for existent path and existent property" {
            $testPath = $script:HKCU_Environment

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "Path" }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $true
        }
    }
}
