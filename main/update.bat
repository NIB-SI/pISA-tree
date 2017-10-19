rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Update/copy files down the tree
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
call:Update makeProject.bat
call:Update makeInvestigation.bat
call:Update makeStudy.bat
call:Update makeAssay.bat
call:Update xcheckDescription.bat
call:Update showDescription.bat
call:Update showTree.bat
del *.tmp
goto:eof
rem ---------- functions ---------------------------------
:Update --- Copy and overwrite file down the directory tree
::      --- %~1 File name to be copied
where /R . %~1 > src.tmp
For /F "tokens=1*" %%a in (src.tmp) do copy /y "%~1" "%%a"
goto:EOF