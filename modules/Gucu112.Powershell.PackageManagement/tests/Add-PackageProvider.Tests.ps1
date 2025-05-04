Describe "Add-PackageProvider" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\Add-PackageProvider.psm1')
    }

    AfterAll {
        Remove-Module 'Add-PackageProvider' -Force
    }

    It "does have proper parameters" {
        Get-Command Add-PackageProvider | Should -HaveParameter ProviderName -Type ([string])
    }

    Context "unit tests" {
        BeforeEach {
            Mock Add-PackageProvider {}
        }

        It "works with <_> provider" -ForEach @('PowerShellGet', 'NuGet', 'ChocolateyGet') {
            $scriptBlock = { Add-PackageProvider -Name $PSItem }

            $scriptBlock | Should -Not -Throw

            Should -Invoke Add-PackageProvider -Times 1
        }
    }

    Context "e2e tests" {
        It "works" {
            # test goes here
        }

        It "does not work" {
            # test goes here
        }
    }
}
