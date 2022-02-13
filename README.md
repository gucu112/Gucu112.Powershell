# Gucu112.Powershell

## Import module locally

Start from root project directory and use this command:

```shell
Import-Module '.\modules\Gucu112.Powershell.Utility\Gucu112.Powershell.Utility.psd1'
```

You can also load single function:

```shell
Import-Module '.\modules\Gucu112.Powershell.PackageManagement\src\New-ModuleScaffold.psm1'
```

Remember to remove module if you want to reload it:

```shell
Remove-Module 'Gucu112.Powershell.Utility' # module name
Remove-Module 'New-ModuleScaffold' # function name
```

## Create test module

Run following command from root project directory:

```shell
New-ModuleScaffold '.\modules\Gucu112.Powershell.Test'
```

## Tests

Implementation

## Ideas

* Check how common parameters works with CmdletBinding
* Check what will happen when we re-use function across module and import module with -Prefix parameter
  - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-5.1
* What else?
