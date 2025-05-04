Describe "Get-WindowsIdentity" {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..\src\Get-WindowsIdentity.psm1'
        Import-Module $modulePath
    }

    AfterAll {
        Remove-Module 'Get-WindowsIdentity' -Force
    }

    Context "unit tests" {
        BeforeEach {
            Mock Get-WindowsIdentity {}
        }

        It "works" {
            $scriptBlock = { Get-WindowsIdentity }

            $scriptBlock | Should -Not -Throw

            $null = Invoke-Command $scriptBlock

            Should -Invoke Get-WindowsIdentity -Times 1
        }
    }

    Context "e2e tests" {
        It "works" {
            # test
        }
    }
}
