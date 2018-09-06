echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Update/copy files down the tree
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
set "mroot=."
set "batdir=%mroot%\Templates"
rem call:Update %mroot% makeProject.bat
call:Update %batdir% makeInvestigation.bat
call:Update %batdir% makeStudy.bat
call:Update %batdir% makeAssay.bat
call:Update %mroot% xcheckMetadata.bat
call:Update %mroot% showMetadata.bat
call:Update %mroot% showTree.bat
del *.tmp
goto:eof
rem ---------- functions ---------------------------------
:Update --- Copy and overwrite file down the directory tree
::      --- %~1 File name to be copied
::      --- %~2 Directory
where /R . %~2 > src.tmp
For /F "tokens=1*" %%a in (src.tmp) do copy /y "%~1\%~2" "%%a"
echo ======================
echo
echo pISA-tree is updated
echo
echo ======================
pause
goto:EOF