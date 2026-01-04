Describe "New-ModuleScaffold" {
    BeforeAll {
        $utilityModulePath = Join-Path $PSScriptRoot '..\..\Gucu112.Powershell.Utility'
        Import-Module (Join-Path $utilityModulePath 'Gucu112.Powershell.Utility.psd1')
        Import-Module (Join-Path $PSScriptRoot '..\src\New-ModuleScaffold.psm1')

        $script:currentPSVersion = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
    }

    AfterAll {
        Remove-Module 'Gucu112.Powershell.Utility' -Force
        Remove-Module 'New-ModuleScaffold' -Force
    }

    It "does have proper parameters" {
        Get-Command New-ModuleScaffold | Should -HaveParameter Path -Type ([string[]])
        Get-Command New-ModuleScaffold | Should -HaveParameter Version -Type ([version])
        Get-Command New-ModuleScaffold | Should -HaveParameter LoaderModule -Type ([switch])
    }

    Context "unit tests" {
        BeforeAll {
            Mock New-ModuleScaffold {}
        }

        It "works when single parameter provided" -ForEach @(
            @{scriptBlock = { New-ModuleScaffold '.\Test' }}
            @{scriptBlock = { New-ModuleScaffold -Path '.\Test' }}
        ) {
            $scriptBlock | Should -Not -Throw

            Should -Invoke New-ModuleScaffold -Times 1
        }

        It "works when multiple parameters provided" -ForEach @(
            @{scriptBlock = { New-ModuleScaffold '.\Test1', '.\Test2', '.\Test3' }}
            @{scriptBlock = { New-ModuleScaffold -Path '.\Test1', '.\Test2', '.\Test3' }}
        ) {
            $scriptBlock | Should -Not -Throw

            Should -Invoke New-ModuleScaffold -Times 1
        }

        It "works when parameters provided through pipeline" -ForEach @(
            @{scriptBlock = { New-ModuleScaffold '.\Test1', '.\Test2', '.\Test3' }}
            @{scriptBlock = { New-ModuleScaffold -Path '.\Test1', '.\Test2', '.\Test3' }}
        ) {
            $scriptBlock = { 'Test1', 'Test2', 'Test3' | New-ModuleScaffold }

            $scriptBlock | Should -Not -Throw

            Should -Invoke New-ModuleScaffold -Times 3
        }

        It "does not work when invalid parameter provided" {
            $scriptBlock = { New-ModuleScaffold -NotExisting }

            $scriptBlock | Should -Throw "A parameter cannot be found that matches parameter name 'NotExisting'."

            Should -Invoke New-ModuleScaffold -Times 0
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

        Context "single module" {
            BeforeAll {
                $script:singleModulePath = Join-Path $baseModulePath 'Test'
            }

            AfterEach {
                Remove-Item -Path $singleModulePath -Recurse -Force
            }

            It "works" {
                $dateFormat = (Get-Culture).DateTimeFormat.ShortDatePattern
                $scriptBlock = { New-ModuleScaffold $singleModulePath -Version 1.0.1 }

                $null = Invoke-Command $scriptBlock

                $moduleManifestPath = Join-Path $singleModulePath 'Test.psd1'
                $moduleManifestPath | Should -Exist
                { Test-ModuleManifest -Path $moduleManifestPath } | Should -Not -Throw

                $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("Module manifest for module 'Test'"))
                $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("Generated on: $(Get-Date -Format $dateFormat)"))
                $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("RootModule = 'Test.psm1'"))
                $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("Version = '1.0.1'"))
                $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("PowerShellVersion = '$currentPSVersion'"))

                Join-Path $singleModulePath 'Test.psm1' | Should -Exist
                Join-Path $singleModulePath 'src' | Should -Exist
                Join-Path $singleModulePath 'tests' | Should -Exist
                Join-Path $singleModulePath 'tools' | Should -Exist
            }

            It "works with loader" {
                $scriptBlock = { New-ModuleScaffold $singleModulePath -Loader -Version 1.0.2 }

                $null = Invoke-Command $scriptBlock

                $loaderModuleManifestPath = Join-Path $singleModulePath 'Test.Loader.psd1'
                $loaderModuleManifestPath | Should -Exist
                { Test-ModuleManifest -Path $loaderModuleManifestPath } | Should -Not -Throw

                $loaderModuleManifestPath | Should -FileContentMatch "# RootModule = ''"
                $loaderModuleManifestPath | Should -FileContentMatch ([regex]::Escape("Version = '1.0.2'"))
                $loaderModuleManifestPath | Should -FileContentMatch ([regex]::Escape("PowerShellVersion = '$currentPSVersion'"))
                $loaderModuleManifestPath | Should -FileContentMatch ([regex]::Escape("ScriptsToProcess = @('.\tools\InstallModule.ps1')"))
            }
        }

        Context "multiple modules" {
            BeforeAll {
                $script:multipleModulePath = 'Test1', 'Test2', 'Test3' |
                    ForEach-Object { Join-Path $baseModulePath $PSItem }
            }

            AfterEach {
                Remove-Item -Path (Join-Path $baseModulePath 'Test*') -Recurse -Force
            }

            It "works" {
                $dateFormat = (Get-Culture).DateTimeFormat.ShortDatePattern
                $scriptBlock = { $multipleModulePath | New-ModuleScaffold -Version 1.0.3 -PassThru }

                $returnValue = Invoke-Command $scriptBlock

                $returnValue | Should -HaveCount 3

                $multipleModulePath | ForEach-Object {
                    $modulePath = $PSItem
                    $moduleName = Split-Path -Leaf $modulePath
                    $moduleManifestPath = Join-Path $modulePath "$moduleName.psd1"

                    $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("Module manifest for module '$moduleName'"))
                    $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("Generated on: $(Get-Date -Format $dateFormat)"))
                    $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("RootModule = '$moduleName.psm1'"))
                    $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("Version = '1.0.3'"))
                    $moduleManifestPath | Should -FileContentMatch ([regex]::Escape("PowerShellVersion = '$currentPSVersion'"))

                    Join-Path $modulePath "$moduleName.psm1" | Should -Exist
                    Join-Path $modulePath 'src' | Should -Exist
                    Join-Path $modulePath 'tests' | Should -Exist
                    Join-Path $modulePath 'tools' | Should -Exist
                }
            }
        }

        Context "throwing error" {
            BeforeAll {
                $script:currentLocationPath = Get-Location
                $script:existingModulePath = Join-Path $baseModulePath 'Test'
                New-Item -Path $existingModulePath -ItemType Directory | Out-Null
            }

            AfterAll {
                Remove-Item -Path $existingModulePath -Recurse -Force
            }

            It "does not work when invalid Path parameter provided" {
                $scriptBlock = { New-ModuleScaffold -Path '.' }

                $scriptBlock | Should -Throw "A module with the specified name $(Split-Path $currentLocationPath -Leaf) already exists in '.' directory."
            }

            It "does not work when existing Path parameter provided" {
                $scriptBlock = { New-ModuleScaffold -Path $existingModulePath }

                $scriptBlock | Should -Throw "A module with the specified name $(Split-Path $existingModulePath -Leaf) already exists in '$existingModulePath' directory."
            }

            It "does not work when invalid Version parameter provided" {
                $scriptBlock = { New-ModuleScaffold -Path $existingModulePath -Version 'invalid' }

                $scriptBlock | Should -Throw 'Cannot process argument transformation on parameter ''Version''. Cannot convert value "invalid" to type "System.Version".*'
            }
        }
    }
}
