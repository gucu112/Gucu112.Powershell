Describe "New-ModuleScaffold" {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..\src\New-ModuleScaffold.psm1'
        Import-Module $modulePath
    }

    AfterAll {
        Remove-Module 'New-ModuleScaffold'
    }

    Context "unit tests" {
        # TODO: Change for BeforeAll and check what happen
        BeforeEach {
            Mock New-ModuleScaffold {} -ParameterFilter { $Path -like '.\Test*' }
        }

        It "works when single parameter provided" {
            $scriptBlock = { New-ModuleScaffold '.\Test' }

            $scriptBlock | Should -Not -Throw

            $null = Invoke-Command $scriptBlock

            Should -Invoke New-ModuleScaffold -Times 1 -ParameterFilter { $Path -eq '.\Test' }
        }

        It "works when multiple parameters provided" {
            $scriptBlock = { New-ModuleScaffold '.\Test1', '.\Test2', '.\Test3' }

            $scriptBlock | Should -Not -Throw

            $null = Invoke-Command $scriptBlock

            Should -Invoke New-ModuleScaffold -Times 1
        }

        # TODO: Not working properly - investigate
        It "works when parameters provided through pipeline" {
            # $scriptBlock = { 'Test1', 'Test2', 'Test3' | New-ModuleScaffold }

            # $scriptBlock | Should -Not -Throw

            # $null = Invoke-Command $scriptBlock

            # Should -Invoke New-ModuleScaffold -Times 3
        }
    }

    Context "e2e tests" {
        BeforeAll {
            $script:baseModulePath = 'TestDrive:\modules'
            $script:singleModulePath = Join-Path $baseModulePath 'Test'
            $script:multipleModulePath = 'Test1', 'Test2', 'Test3' | ForEach-Object {
                Join-Path $baseModulePath $_
            }

            New-Item -Path $baseModulePath -ItemType Directory | Out-Null
        }

        AfterAll {
            Remove-Item -Path $baseModulePath -Recurse -Force
        }

        It "works when single parameter provided" {
            # $scriptBlock = { New-ModuleScaffold -Path $singleModulePath }

            # $scriptBlock | Should -Not -Throw

            # $null = Invoke-Command $scriptBlock

            # $rootModulePath = Join-Path $singleModulePath 'Test.psd1'

            # $rootModulePath | Should -FileContentMatch "Module manifest for module 'Test'"
            # $rootModulePath | Should -FileContentMatch "Generated on: $(Get-Date -Format 'M/d/yyyy')"

            # $manifestParams = Test-ModuleManifest -Path $rootModulePath

            # $manifestParams | Write-Output

            # TODO: Assert params
        }

        It "works when multiple parameters provided" {
            # $scriptBlock = { $multipleModulePath | New-ModuleScaffold -PassThru }

            # $scriptBlock | Should -Not -Throw

            # $manifestParams = Invoke-Command $scriptBlock

            # $manifestParams | Write-Output

            # TODO: Assert params
        }
    }
}