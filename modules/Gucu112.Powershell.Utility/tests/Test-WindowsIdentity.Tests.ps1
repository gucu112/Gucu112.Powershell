Describe "Test-WindowsIdentity" {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..\src\Test-WindowsIdentity.psm1'
        Import-Module $modulePath
    }

    AfterAll {
        Remove-Module 'Test-WindowsIdentity' -Force
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
            # test
        }
    }
}
