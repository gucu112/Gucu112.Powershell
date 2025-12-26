Describe "Test-ItemProperty" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\Test-ItemProperty.psm1')

        $script:HKCU_Environment = "HKCU:\Environment"
        $script:HKCU_Software = "HKCU:\Software"
        $script:TestRegistry_Network = "TestRegistry:\Network"

        New-Item -Path $script:TestRegistry_Network -Type "Container" -Force | Out-Null
        New-ItemProperty -Path $script:TestRegistry_Network -Name "Channel" -Value 10
    }

    AfterAll {
        Remove-ItemProperty -Path $script:TestRegistry_Network -Name "Channel" -ErrorAction Ignore
        Remove-Module 'Test-ItemProperty' -Force -ErrorAction Ignore
    }

    It "does have proper parameters" {
        Get-Command Test-ItemProperty | Should -HaveParameter Path -Type ([string]) -Mandatory
        Get-Command Test-ItemProperty | Should -HaveParameter Name -Type ([string])
        Get-Command Test-ItemProperty | Should -HaveParameter PropertyType -Type ([string]) -Alias "Type"
        Get-Command Test-ItemProperty | Should -HaveParameter Value -Type ([object])
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

        It "returns false if property type does not match" {
            $testPath = $script:HKCU_Environment

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "Path" -PropertyType "Binary" }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $false
        }

        It "returns true if property type does match" {
            $testPath = $script:HKCU_Environment

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "Path" -PropertyType "ExpandString" }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $true
        }

        It "returns false if property value does not match" {
            $testPath = $script:TestRegistry_Network

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "Channel" -Value "10" }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $false
        }

        It "returns true if property value does match" {
            $testPath = $script:TestRegistry_Network

            $scriptBlock = { Test-ItemProperty -Path $testPath -Name "Channel" -Value 10 }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -Be $true
        }
    }
}
