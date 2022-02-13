Describe "Add-PackageProvider" {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..\src\Add-PackageProvider.psm1'
        Import-Module $modulePath
    }

    AfterAll {
        Remove-Module 'Add-PackageProvider'
    }

    Context "unit tests" {
        BeforeEach {
            Mock Add-PackageProvider {}
        }

        It "works" {
            $scriptBlock = { Add-PackageProvider -Name 'NuGet' }

            $scriptBlock | Should -Not -Throw
        }
    }

    Context "e2e tests" {
        BeforeAll {
            # setup
        }

        AfterAll {
            # teardown
        }

        It "works" {
            # test
        }
    }
}