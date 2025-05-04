Describe "New-ModuleFunction" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\New-ModuleFunction.psm1')
        Import-Module (Join-Path $PSScriptRoot '..\src\New-ModuleScaffold.psm1')
    }

    AfterAll {
        Remove-Module 'New-ModuleFunction' -Force
        Remove-Module 'New-ModuleScaffold' -Force
    }

    It "does have proper parameters" {
        Get-Command New-ModuleFunction | Should -HaveParameter Path -Type ([string])
        Get-Command New-ModuleFunction | Should -HaveParameter Name -Type ([string[]])
        Get-Command New-ModuleFunction | Should -HaveParameter ErrorHandling -Type ([switch])
        Get-Command New-ModuleFunction | Should -HaveParameter TestFile -Type ([switch])
    }

    Context "unit tests" {
        BeforeAll {
            Mock New-ModuleFunction {}
        }

        It "works when single parameter provided" -ForEach @(
            @{scriptBlock = { New-ModuleFunction '.\Test' 'New-Thing' }}
            @{scriptBlock = { New-ModuleFunction -Path '.\Test' 'New-Thing' }}
            @{scriptBlock = { New-ModuleFunction '.\Test' -Name 'New-Thing' }}
            @{scriptBlock = { New-ModuleFunction -Path '.\Test' -Name 'New-Thing' }}
        ) {
            $scriptBlock | Should -Not -Throw

            Should -Invoke New-ModuleFunction -Times 1
        }

        It "works when multiple parameter provided" -ForEach @(
            @{scriptBlock = { New-ModuleFunction '.\Test' 'Get-Thing', 'New-Thing', 'Test-Thing' }}
            @{scriptBlock = { New-ModuleFunction -Path '.\Test' 'Get-Thing', 'New-Thing', 'Test-Thing' }}
            @{scriptBlock = { New-ModuleFunction '.\Test' -Name 'Get-Thing', 'New-Thing', 'Test-Thing' }}
            @{scriptBlock = { New-ModuleFunction -Path '.\Test' -Name 'Get-Thing', 'New-Thing', 'Test-Thing' }}
        ) {
            $scriptBlock | Should -Not -Throw

            Should -Invoke New-ModuleFunction -Times 1
        }

        It "works when parameters provided through pipeline" -ForEach @(
            @{scriptBlock = { 'Get-Thing', 'New-Thing', 'Test-Thing' | New-ModuleFunction '.\Test' }}
            @{scriptBlock = { 'Get-Thing', 'New-Thing', 'Test-Thing' | New-ModuleFunction -Path '.\Test' }}
        ) {
            $scriptBlock | Should -Not -Throw

            Should -Invoke New-ModuleFunction -Times 3
        }

        It "does not work when invalid parameter provided" {
            $scriptBlock = { New-ModuleFunction -Path '.\Test' -Name 'Test-Thing' -NotExisting }

            $scriptBlock | Should -Throw "A parameter cannot be found that matches parameter name 'NotExisting'."

            Should -Invoke New-ModuleFunction -Times 0
        }
    }

    Context "e2e tests" {
        BeforeAll {
            $script:baseModulePath = 'TestDrive:\modules'
            New-Item -Path $baseModulePath -ItemType Directory | Out-Null
        }

        AfterAll {
            Remove-Item -Path $baseModulePath -Recurse -Force
        }

        Context "single function name" {
            BeforeAll {
                $script:singleModulePath = Join-Path $baseModulePath 'Test'
                New-ModuleScaffold $singleModulePath
            }

            AfterAll {
                Remove-Item -Path $singleModulePath -Recurse -Force
            }

            It "works" {
                $scriptBlock = { 'Get-Thing' | New-ModuleFunction $singleModulePath }

                $null = Invoke-Command $scriptBlock

                $moduleFunctionFilePath = Join-Path $singleModulePath '.\src\Get-Thing.psm1'
                $moduleFunctionFilePath | Should -Exist
                $moduleFunctionFilePath | Should -FileContentMatch ('^' + [regex]::Escape('function Get-Thing'))

                $moduleFunctionTestFilePath = Join-Path $singleModulePath '.\tests\Get-Thing.Tests.ps1'
                $moduleFunctionTestFilePath | Should -Exist
                $moduleFunctionTestFilePath | Should -FileContentMatch ('^' + [regex]::Escape('Describe "Get-Thing"'))
            }

            It "works with disabled 'ErrorHandling' switch" {
                $scriptBlock = { New-ModuleFunction $singleModulePath 'New-Thing' -ErrorHandling:$false }

                $null = Invoke-Command $scriptBlock

                $moduleFunctionFilePath = Join-Path $singleModulePath '.\src\New-Thing.psm1'
                $moduleFunctionFilePath | Should -Exist
                $moduleFunctionFilePath | Should -FileContentMatch ('^' + [regex]::Escape('function New-Thing'))
                $moduleFunctionFilePath | Should -Not -FileContentMatch ([regex]::Escape('$errorCollection'))
                $moduleFunctionFilePath | Should -Not -FileContentMatch ([regex]::Escape('$errorRecord'))
            }

            It "works with disabled 'TestFile' switch" {
                $scriptBlock = { New-ModuleFunction -Path $singleModulePath -Name 'Test-Thing' -TestFile:$false }

                $null = Invoke-Command $scriptBlock

                $moduleFunctionFilePath = Join-Path $singleModulePath '.\src\Test-Thing.psm1'
                $moduleFunctionFilePath | Should -Exist
                $moduleFunctionFilePath | Should -FileContentMatch ('^' + [regex]::Escape('function Test-Thing'))

                $moduleFunctionTestFilePath = Join-Path $singleModulePath '.\tests\Test-Thing.Tests.ps1'
                $moduleFunctionTestFilePath | Should -Not -Exist
            }
        }

        Context "multiple function names" {
            # TODO
        }

        Context "throwing error" {
            # TODO
        }
    }
}
