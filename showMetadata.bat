@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Prepare Metadata for levels below the current level
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
setlocal EnableDelayedExpansion
set lfn=Metadata.md
set LF=^


REM Two empty lines are necessary
echo !LF!*!LF!>line.tmp
where /R . _*.txt > src.tmp
rem change \ with /
echo # Metadata files>!lfn!
set "mycd=%cd:\=;%"
set "mycd=%mycd:_=\_%
echo %mycd:;=  !LF!/%>>!lfn!
For /F "tokens=1*" %%i in (src.tmp) do (
	rem (echo.|set /p =## %%i!LF!)>name.tmp
	rem copy !lfn!+line.tmp !lfn!
	echo !LF!---!LF!>>!lfn!
	rem copy !lfn!+name.tmp !lfn!
	rem Shorten the path( remove project root) and change \ to /
	set "fname=%%i"
	set "fname=!fname:%cd%= * **!"
	set "fname=!fname:\=/!"
	set "fname=!fname:_=\_!"
	(echo.|set /p =" !fname!**!LF!")>>!lfn!
	echo !LF!---!LF!>>!lfn!
	REM set /p="TextHere" <nul >>!lfn!
	REM Add two blanks to each line
	set addtext="  "
	if exist tmpfile.tmp del /q tmpfile.tmp
	echo ^|Item^|Value^| >> tmpfile.tmp
	echo ^|:---^|:---^| >> tmpfile.tmp
	for /f "delims=" %%l in (%%i) Do (
		set "iv=%%l"
		set "iv=!iv::=:|!"
		set "iv=!iv:_=\_!"
		echo ^| !iv!  %addtext% ^| >> tmpfile.tmp
		)
	REM
	copy !lfn!+tmpfile.tmp !lfn!
	REM copy !lfn!+"%%i" !lfn!
)
echo !LF!---!LF!>>!lfn!
del *.tmp
@echo on
rem type Metadata.md
@echo.Metadata of levels below %cd%
write !lfn!