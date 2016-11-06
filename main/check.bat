@echo off
rem ------------------------------------------------------
rem Check description for levels below the current level
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
setlocal EnableDelayedExpansion
set lfn=CheckDescription.md
set LF=^


REM Two empty lines are necessary
echo !LF!*!LF!>line.tmp
where /R . _*.txt > src.tmp
rem change \ with /
echo # Investigation check >!lfn!
echo %cd:\=  !LF!/%>>!lfn!
For /F "tokens=1*" %%i in (src.tmp) do (
rem (echo.|set /p =## %%i!LF!)>name.tmp
rem copy !lfn!+line.tmp !lfn!
echo !LF!---!LF!>>!lfn!
rem copy !lfn!+name.tmp !lfn!
rem Shorten the path( remove project root) and change \ to /
set "fname=%%i"
set "fname=!fname:%cd%= * !"
set "fname=!fname:\=/!"
(echo.|set /p =" !fname! !LF!")>>!lfn!
echo !LF!---!LF!>>!lfn!
REM set /p="TextHere" <nul >>!lfn!
REM Add two blanks to each line
set addtext="  "
rem find stars
for /f "delims=" %%a in ('findstr "*" %%i') do echo  ?? MISSING: %%a %addtext% >> !lfn!
rem 
if exist tmpfile.tmp del /q tmpfile.tmp
rem for /f "delims=" %%l in (%%i) Do (
rem      echo %%l %addtext% >> tmpfile.tmp
rem )
REM
rem copy !lfn!+tmpfile.tmp !lfn!
REM copy !lfn!+"%%i" !lfn!
rem echo !LF! >> !lfn!
)
echo !LF!---!LF!>>!lfn!
del *.tmp
@echo on
rem type Description.md
@echo Description of studies in %cd%
write !lfn!