using namespace System.Security.Principal

Describe "Get-WindowsIdentity" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\Get-WindowsIdentity.psm1')
    }

    AfterAll {
        Remove-Module 'Get-WindowsIdentity' -Force
    }

    It "does have proper parameters" {
        Get-Command Get-WindowsIdentity | Should -HaveParameter Identity -Type ([WindowsIdentity])
        Get-Command Get-WindowsIdentity | Should -HaveParameter Current -Type ([switch])
        Get-Command Get-WindowsIdentity | Should -HaveParameter Anonymous -Type ([switch])
        Get-Command Get-WindowsIdentity | Should -HaveParameter Explorer -Type ([switch])
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

        Context "works with <_> switch" -ForEach @('Current', 'Anonymous', 'Explorer') {
            It "when present" {
                $scriptBlock = {
                    $params = @{ $PSItem = [switch]::Present }
                    Get-WindowsIdentity @params
                }

                $scriptBlock | Should -Not -Throw

                Should -Invoke Get-WindowsIdentity -Times 1 -ParameterFilter {
                    $parameter = (Get-Variable $PSItem).Value
                    $parameter -eq $true
                }
            }

            it "when not present" {
                $scriptBlock = {
                    $params = @{ $PSItem = [switch]::NotPresent }
                    Get-WindowsIdentity @params
                }

                $scriptBlock | Should -Not -Throw

                Should -Invoke Get-WindowsIdentity -Times 1 -ParameterFilter {
                    $parameter = (Get-Variable $PSItem).Value
                    $parameter -eq $false
                }
            }
        }

        It "works without a switch" {
            $scriptBlock = { Get-WindowsIdentity -Identity ([WindowsIdentity]::GetCurrent()) }

            $scriptBlock | Should -Not -Throw

            Should -Invoke Get-WindowsIdentity -Times 1
        }

        It "does not work" {
            $scriptBlock = { Get-WindowsIdentity -NotExisting }

            $scriptBlock | Should -Throw "A parameter cannot be found that matches parameter name 'NotExisting'."

            Should -Invoke Get-WindowsIdentity -Times 0
        }

        It "does not work with system identity" {
            # TODO: Update when C# library added to PowerShell module
            $scriptBlock = { Get-WindowsIdentity -Identity (New-Object System.NotImplementedException) }

            $scriptBlock | Should -Throw "Cannot process argument transformation on parameter 'Identity'.*"

            Should -Invoke Get-WindowsIdentity -Times 0
        }
    }

    Context "e2e tests" {
        It "works" {
            $scriptBlock = { Get-WindowsIdentity }

            $returnValue = Invoke-Command $scriptBlock

            $returnValue | Should -BeTrue
        }

        It "does not work" {
            $scriptBlock = { Get-WindowsIdentity -System }

            $scriptBlock | Should -Throw "A parameter cannot be found that matches parameter name 'System'."
        }
    }
}
