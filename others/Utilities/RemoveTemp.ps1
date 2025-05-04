param()

# Remove system drive temporary files
Remove-Item -Path "$env:SystemDrive\Temp\*" -Recurse -ErrorAction Ignore -Verbose -Confirm

# Remove system root temporary files
Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -ErrorAction Ignore -Verbose -Confirm

# Remove current user temporary files
Remove-Item -Path "$env:Temp\*" -Recurse -ErrorAction Ignore -Verbose -Confirm
