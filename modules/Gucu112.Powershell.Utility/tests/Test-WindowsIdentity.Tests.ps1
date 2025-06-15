using namespace System.Security.Principal

Describe "Test-WindowsIdentity" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\Get-WindowsIdentity.psm1')
        Import-Module (Join-Path $PSScriptRoot '..\src\Test-WindowsIdentity.psm1')
    }

    AfterAll {
        Remove-Module 'Test-WindowsIdentity' -Force
        Remove-Module 'Get-WindowsIdentity' -Force
    }

    It "does have proper parameters" {
        Get-Command Test-WindowsIdentity | Should -HaveParameter Identity -Type ([WindowsIdentity])
        Get-Command Test-WindowsIdentity | Should -HaveParameter Role -Type ([WindowsBuiltInRole])
        Get-Command Test-WindowsIdentity | Should -HaveParameter Administrator -Type ([switch])
        Get-Command Test-WindowsIdentity | Should -HaveParameter User -Type ([switch])
        Get-Command Test-WindowsIdentity | Should -HaveParameter Guest -Type ([switch])
    }

    Context "unit tests" {
        BeforeEach {
            Mock Test-WindowsIdentity {}
        }

        It "works" {
            $scriptBlock = { Test-WindowsIdentity }

            $scriptBlock | Should -Not -Throw

            $null = Invoke-Command $scriptBlock

            Should -Invoke Test-WindowsIdentity -Times 1
        }
    }

    Context "e2e tests" {
        It "works" {
            $scriptBlock = { Test-WindowsIdentity }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -BeIn @($true, $false)
        }
    }
}
