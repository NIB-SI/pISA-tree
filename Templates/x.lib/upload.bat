ECHO OFF
cls
REM Upload newly generated files 
REM From the local assay to the remote/network assay (set by uroot)
REM ----------------------------
REM uroot --- remote pISA projects root (for upload)
REM NOTE: replace uroot with the pISA-projects location on your server 
set "uroot=O:\DEJAVNOSTI\OMIKE\pISA-Projects"
REM --- Set local pISA roots and names (version 2018)
set wd=%CD%
set aroot=%CD%
for %%* in (.) do set "aname=%%~n*"
chdir ..
set sroot=%CD%
for %%* in (.) do set "sname=%%~n*"
chdir ..
set iroot=%CD%
for %%* in (.) do set "iname=%%~n*"
chdir ..
set proot=%CD%
for %%* in (.) do set "pname=%%~n*"
chdir ..
set lroot=%CD%
for %%* in (.) do set "lname=%%~n*"
set "remote=%uroot%\%pname%\%Iname%\%Sname%\%Aname%"
cd %aroot%
echo .
echo Copy newly produced files to the remote assay folder
echo .
echo From: %cd% 
echo To  : %remote%
echo .
pause
REM --- Copy newly produced files to the remote assay folder
echo on
xcopy *.* %remote% /D/Y/S/exclude:ignore.txt
pause
rem xcopy ..\out\*.* %aroot%\output /Y/E/D
rem xcopy ..\doc\_*.pdf %aroot%\reports /Y/D
rem xcopy %rdir%\*.R* %aroot%\scripts /Y/D
tree %remote% /F
PAUSE
