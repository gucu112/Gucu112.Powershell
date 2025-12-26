Describe "Add-ItemProperty" {
    BeforeAll {
        Import-Module (Join-Path $PSScriptRoot '..\src\Test-ItemProperty.psm1')
        Import-Module (Join-Path $PSScriptRoot '..\src\Add-ItemProperty.psm1')

        $script:HKCU_Environment = "HKCU:\Environment"
        $script:HKCU_Software = "HKCU:\Software"
        $script:TestRegistry_Network = "TestRegistry:\Network"

        New-Item -Path $script:TestRegistry_Network -Type "Container" -Force | Out-Null
        New-ItemProperty -Path $script:TestRegistry_Network -Name "ExistingProperty" -Value "InitialValue" | Out-Null
    }

    AfterAll {
        Remove-ItemProperty -Path $script:TestRegistry_Network -Name "TestProperty" -ErrorAction Ignore
        Remove-ItemProperty -Path $script:TestRegistry_Network -Name "ExistingProperty" -ErrorAction Ignore
        Remove-Module 'Add-ItemProperty' -Force -ErrorAction Ignore
        Remove-Module 'Test-ItemProperty' -Force -ErrorAction Ignore
    }

    It "does have proper parameters" {
        Get-Command Add-ItemProperty | Should -HaveParameter Path -Type ([string]) -Mandatory
        Get-Command Add-ItemProperty | Should -HaveParameter Name -Type ([string]) -Mandatory
        Get-Command Add-ItemProperty | Should -HaveParameter PropertyType -Type ([string])
        Get-Command Add-ItemProperty | Should -HaveParameter Value -Type ([object]) -Mandatory
    }

    Context "unit tests" {
        BeforeEach {
            Mock Add-ItemProperty {}
            Mock Test-ItemProperty { $false }
            Mock Set-ItemProperty {}
            Mock New-ItemProperty {}
        }

        It "works" {
            $testPath = Join-Path $script:HKCU_Software "Test"

            $scriptBlock = { Add-ItemProperty -Path $testPath -Name "TestProperty" -PropertyType "String" -Value "TestValue" }

            $scriptBlock | Should -Not -Throw

            $null = Invoke-Command $scriptBlock

            Should -Invoke Add-ItemProperty -Times 1
        }
    }

    Context "e2e tests" {
        $testData = @(
            @{ PropertyType = 'String'; PropertyValue = 'TestValue' }
            @{ PropertyType = 'MultiString'; PropertyValue = @("Value1", "Value2", "Value3") }
            @{ PropertyType = 'DWord'; PropertyValue = 42 }
            @{ PropertyType = 'QWord'; PropertyValue = [int64]9223372036854775800 }
            @{ PropertyType = 'Binary'; PropertyValue = [byte[]]@(0x01, 0x02, 0x03) }
        )

        It "creates new property when it does not exist" {
            $testPath = $script:TestRegistry_Network
            $propertyName = "TestProperty"
            $propertyValue = "TestValue"

            Add-ItemProperty -Path $testPath -Name $propertyName -PropertyType "String" -Value $propertyValue

            Test-ItemProperty -Path $testPath -Name $propertyName | Should -Be $true
            (Get-ItemProperty -Path $testPath -Name $propertyName).$propertyName | Should -Be $propertyValue
        }

        It "updates existing property when it already exists" {
            $testPath = $script:TestRegistry_Network
            $propertyName = "ExistingProperty"
            $updatedValue = "UpdatedValue"

            Add-ItemProperty -Path $testPath -Name $propertyName -PropertyType "String" -Value $updatedValue

            (Get-ItemProperty -Path $testPath -Name $propertyName).$propertyName | Should -Be $updatedValue
        }

        It "creates and expands ExpandString property correctly" {
            $testPath = $script:TestRegistry_Network
            $propertyName = "Property_ExpandString_$([guid]::NewGuid().ToString().Substring(0, 8))"
            $propertyValue = '%SystemRoot%'

            Add-ItemProperty -Path $testPath -Name $propertyName -PropertyType "ExpandString" -Value $propertyValue

            Test-ItemProperty -Path $testPath -Name $propertyName -PropertyType "ExpandString" | Should -Be $true
            (Get-ItemProperty -Path $testPath -Name $propertyName).$propertyName | Should -Be "C:\Windows"

            Remove-ItemProperty -Path $testPath -Name $propertyName -ErrorAction Ignore
        }

        It "creates <PropertyType> property correctly" -ForEach $testData {
            $testPath = $script:TestRegistry_Network
            $propertyName = "Property_$PropertyType`_$([guid]::NewGuid().ToString().Substring(0, 8))"

            Add-ItemProperty -Path $testPath -Name $propertyName -PropertyType $PropertyType -Value $PropertyValue

            Test-ItemProperty -Path $testPath -Name $propertyName -PropertyType $PropertyType | Should -Be $true
            (Get-ItemProperty -Path $testPath -Name $propertyName).$propertyName | Should -Be $PropertyValue

            Remove-ItemProperty -Path $testPath -Name $propertyName -ErrorAction Ignore
        }

        It "creates <PropertyType> property correctly without type" -ForEach $testData {
            $testPath = $script:TestRegistry_Network
            $propertyName = "Property_$PropertyType`_$([guid]::NewGuid().ToString().Substring(0, 8))"

            Add-ItemProperty -Path $testPath -Name $propertyName -Value $PropertyValue

            Test-ItemProperty -Path $testPath -Name $propertyName -PropertyType $PropertyType | Should -Be $true
            (Get-ItemProperty -Path $testPath -Name $propertyName).$propertyName | Should -Be $PropertyValue

            Remove-ItemProperty -Path $testPath -Name $propertyName -ErrorAction Ignore
        }

        It "throws error when path does not exist" {
            $invalidPath = "TestRegistry:\NonExistentPath"
            $propertyName = "TestProperty"

            $scriptBlock = { Add-ItemProperty -Path $invalidPath -Name $propertyName -PropertyType "String" -Value "Value" }

            $scriptBlock | Should -Throw
        }

        It "throws error when property type is invalid" {
            $testPath = $script:TestRegistry_Network

            $scriptBlock = { Add-ItemProperty -Path $testPath -Name "TestProperty" -PropertyType "InvalidType" -Value "Value" }

            $scriptBlock | Should -Throw
        }

        It "throws error when item name is empty" {
            $testPath = $script:TestRegistry_Network

            $scriptBlock = { Add-ItemProperty -Path $testPath -Name "" -PropertyType "String" -Value "Value" }

            $scriptBlock | Should -Throw
        }

        It "throws error when path is empty" {
            $scriptBlock = { Add-ItemProperty -Path "" -Name "TestProperty" -PropertyType "String" -Value "Value" }

            $scriptBlock | Should -Throw
        }
    }
}
