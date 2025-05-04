$HKCU_Console = 'HKCU:\Console\%%Startup'

New-ItemProperty $HKCU_Console -Name 'DelegationConsole' -PropertyType String -Value '{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}'
New-ItemProperty $HKCU_Console -Name 'DelegationTerminal' -PropertyType String -Value '{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}'
