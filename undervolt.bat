@echo off
net start XTU3SERVICE
:: BatchGotAdmin
:-------------------------------------
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"


REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )




:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"




"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B




:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------




powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e
cd "C:\Program Files (x86)\Intel\Intel(R) Extreme Tuning Utility\Client"
set remaintimes=10
set flag=0
:voltcheck
XtuCLI.exe -t -id 34 -v -80
find "-80mV" c:\XTU_xmlfiles\Control34.txt
if %errorlevel%==1 (
    set flag=1
)
setlocal enabledelayedexpansion
if %flag%==1 (
    set /a remaintimes=remaintimes-1
    if !remaintimes! GTR 0 (
	set flag=0
	goto voltcheck
    ) else (
	echo error_at_%time% >c:\XTU_xmlfiles\error.txt
    )	
)
net stop XTU3SERVICE
