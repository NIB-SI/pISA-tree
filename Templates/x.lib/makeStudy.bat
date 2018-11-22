@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Create a new Study tree _S_xxxx in current directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if project folder exists
rem robocopy %1 X-%1 /MIR
rem ------------------------------------------------------
TITLE pISA-tree
echo ============================
echo pISA-tree: make STUDY 
echo ----------------------------
rem ----------- init directories
set descFile=".\_STUDY_METADATA.TXT"
set "iroot=%cd%"
set "pISAroot=%iroot%\..\.."
set "mroot=%iroot%\..\.."
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
rem -----------
call %libdir%\lib.cmd :getLayer _I_ iname
rem Check Investigation existence
if x%iname::=%==x%iname% goto iok
echo.
echo ERROR: Make Investigation first!
echo.
pause
goto:eof
:iok
rem Investigation already created
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
call %libdir%\lib.cmd :askFile "Enter Study ID: " ID
rem echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call %libdir%\lib.cmd :askFile "Enter Study ID: " ID
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST _S_%ID% (
REM Dir exists
echo ERROR: Study named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
rem echo %ID%
)
rem ----------------------------------------------
rem Make new Study directory tree
set Sdir=_S_%ID%
md %Sdir%
cd %Sdir%
echo %cd%
set sroot=%cd%
set "iroot=.."
set "proot=%iroot%\.."
set "mroot=%proot%\.."
md reports
rem put something to the directories
rem to force git to add them
echo # Study %ID% >  .\README.MD
echo # Reports for study %ID% >  .\reports\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
rem -----------------------------------------------
call %libdir%\lib.cmd :getLayer _p_ pname
call %libdir%\lib.cmd :getLayer _I_ iname
call %libdir%\lib.cmd :getLayer _S_ sname
rem -----------------------------------------------
echo Study:	%sname%> %descFile%
echo Investigation:	%iname%>> %descFile%
echo project:	%pname%>> %descFile%
rem echo ### STUDY>> %descFile%
echo Short Name:	%ID%>> %descFile%
  call %libdir%\lib.cmd :inputMeta "Title" aTitle *
  call %libdir%\lib.cmd :inputMeta "Description" aDesc *
rem echo Study Path:	%cd:\=/%>> %descFile%
echo Raw Data:	>> %descFile%
rem echo #### ASSAYS>>  %descFile%
rem echo STUDY:	%ID%>> ..\_INVESTIGATION_METADATA.TXT
rem 
rem  make main readme.md file
copy %batdir%\makeAssay.bat . > NUL
copy %iroot%\showTree.bat . > NUL
copy %iroot%\showMetadata.bat . > NUL
copy %iroot%\xcheckMetadata.bat . > NUL
REM
rem process level specific items
 call %libdir%\lib.cmd :processMeta %iroot%\meta_S.ini
 copy %libdir%\meta_A.ini %sroot%
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo      Study METADATA
echo ======================================
call %libdir%\lib.cmd :showDesc %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
echo.
echo ============================== pISA ==
echo.
echo Study %ID% is ready.
echo .
echo ======================================

PAUSE

goto:eof
