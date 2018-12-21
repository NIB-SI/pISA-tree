@echo off
pushd %~dp0
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Update/copy files down the tree
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
set "mroot=."
set "batdir=%mroot%\Templates\x.lib"
rem call:Update %mroot% makeProject.bat
call:Update %batdir% makeInvestigation.bat call.bat
call:Update %batdir% makeStudy.bat call.bat
call:Update %batdir% makeAssay.bat call.bat
if exist %mroot%\Templates\*.bat del %mroot%\Templates\*.bat /Q > NUL
call:Update %mroot% xcheckMetadata.bat
call:Update %mroot% showMetadata.bat
call:Update %mroot% showTree.bat
del *.tmp
echo ==========================
echo
echo pISA-Projects are updated
echo
echo ==========================
pause
goto:eof
rem ---------- functions ---------------------------------
:Update --- Copy and overwrite file down the directory tree
::      --- %~1 Origin directory
::      --- %~2 Target File name
::      --- %~3 Source file name (if ommitted, Target file name will be used)
echo Updating: %~2
set $origin=%~3
if .%$origin%==. set $origin=%~2
where /R . %~2 > src.tmp
For /F "tokens=1*" %%a in (src.tmp) do copy /y "%~1\%$origin%" "%%a"
goto:EOF