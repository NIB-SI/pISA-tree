@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Prepare Metadata for levels below the current level
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
TITLE pISA-tree
setlocal EnableDelayedExpansion
set rtyp=txt
call:getMenu "Select report type" "Markdown/Plain text" rtip
if "%rtip%" EQU "Markdown" ( set "rtyp=md" ) 
set lfn=Metadata.%rtyp%
set LF=^


REM Two empty lines are necessary
echo !LF!*!LF!>line.tmp
where /R . _*.txt > src.tmp
rem change \ with /
echo # Metadata files>!lfn!
set "mycd=%cd:\=;%"
if "%rtyp%" EQU "md" set "mycd=%mycd:_=\_%
echo %mycd:;=  !LF!/%>>!lfn!
For /F "tokens=1*" %%i in (src.tmp) do (
	rem (echo.|set /p =## %%i!LF!)>name.tmp
	rem copy !lfn!+line.tmp !lfn!
	echo !LF!---!LF!>>!lfn!
	rem copy !lfn!+name.tmp !lfn!
	rem Shorten the path( remove project root) and change \ to /
	set "fname=%%i"
	set "fname=!fname:%cd%= * **!"
	@echo. !fname!
	set "fname=!fname:\=/!"
	if "%rtyp%" EQU "md" set "fname=!fname:_=\_!"
	(echo.|set /p =" !fname!**!LF!")>>!lfn!
	echo !LF!---!LF!>>!lfn!
	REM set /p="TextHere" <nul >>!lfn!
	REM Add two blanks to each line
	set addtext="  "
	if exist tmpfile.tmp del /q tmpfile.tmp
	if "%rtyp%" EQU "md" (
		echo ^|Item^|Value^| >> tmpfile.tmp
		echo ^|:---^|:---^| >> tmpfile.tmp
		) ELSE (
		echo Item	Value >> tmpfile.tmp
		)
		for /f "delims=" %%l in (%%i) Do (
			if "%rtyp%" EQU "md" (
			set "iv=%%l"
			set "iv=!iv::=:|!"
			set "iv=!iv:_=\_!"
			echo ^| !iv!  %addtext% ^| >> tmpfile.tmp
			) ELSE (
			echo %%l >> tmpfile.tmp
			)
		)
	REM
	copy !lfn!+tmpfile.tmp !lfn!>NUL
	REM copy !lfn!+"%%i" !lfn!
)
echo !LF!---!LF!>>!lfn!
del *.tmp
::@echo on
@echo.
@echo.Metadata of levels below %cd% are in !lfn!
@echo.
open !lfn!
timeout 10
goto:eof
rem
rem --------------------------------------------------------
:getMenu    --- get menu item
::          --- %~1 Value description
::          --- %~2 String of choices (aa/bb/cc)
::          --- %~3 Variable to get result
::          --- %~4 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:getMenu "Select input" list/of/choices u
SETLOCAL
rem Make menu function
rem cls
echo.
echo =========================
echo.
echo %~1
echo.
set mn=%~2
rem 
IF NOT "%mn:~-1%"=="/" set mn=%mn%/
set _mn=%mn%
set nl=0
set mch=
rem echo %mn%
rem echo. 
:top
rem if "%mn%"=="" goto :done
set /A "nl=%nl%+1"
set mch=%mch%%nl%
for /F "tokens=1 delims=/" %%H in ("%mn%") DO echo    %nl% %%H
set mn=%mn:*/=%
if NOT "%mn%"=="" goto :top
rem :done
echo. 
choice /C:%mch% /M:Select 
(ENDLOCAL
    for /F "tokens=%errorlevel% delims=/" %%H in ("%_mn%") DO set "%~3=%%H
)
GOTO:EOF