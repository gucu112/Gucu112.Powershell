REM Bypass network requirements

OOBE\BYPASSNRO

REM Disable security questions
REM TODO: Test if it works during installation

REG ADD HKLM\SOFTWARE\Policies\Microsoft\Windows\System /v NoLocalPasswordResetQuestions /t REG_DWORD /d 1 /f

REM Disable internet connection

IPCONFIG /RELEASE
