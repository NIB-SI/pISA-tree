@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Create a new project tree _p_xxx in current directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if the folder exists
rem robocopy %ID% X-%ID% /MIR
rem ------------------------------------------------------
TITLE pISA-tree
echo =============================
echo pISA-tree: make PROJECT 
echo -----------------------------
rem ----------- init directories
set descFile=".\_PROJECT_METADATA.TXT"
set pISAroot=%cd%
set mroot=%cd%
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
rem -----------
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
call %libdir%\lib.cmd :askFile "Enter project ID: " ID
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call %libdir%\lib.cmd :askFile "Enter project ID: " ID
if %ID% EQU "" goto Ask
IF EXIST _p_%ID% (
REM Dir exists
echo ERROR: project named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
echo Creating project %ID%
)
rem ----------------------------------------------

rem Make new project directory tree
rem set project root
rem set PPath=:getparentdir %cd%
rem set \ to /
rem set "PPath=!PPath:\=/!"
rem echo %PPath%
rem
set pdir=_p_%ID%
md %pdir%
cd %pdir%
echo %cd%
set proot=%cd%
md presentations
md reports
rem put something to the directories
rem to force git to add them
REM
echo # Project %ID% >  .\README.MD
echo # Reports for project %ID% >  .\reports\README.MD
echo # Presentations for project %ID% >  .\presentations\README.MD
echo # Feature Summary Table> .\FST.txt
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
::Create a TAB variable
REM not really needed
rem call %libdir%\lib.cmd :hexprint "0x09" TAB
rem -----------------------------------------------
call %libdir%\lib.cmd :getLayer _p_ pname
REM -----------------------------------------------
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!PROJECT	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_METADATA.TXT
echo project:	%pname%> %descFile%
echo Short Name:	%ID%>> %descFile%
  call %libdir%\lib.cmd :inputMeta "Title" aTitle *
  call %libdir%\lib.cmd :inputMeta "Description" aDesc *
echo pISA projects path:	%pISAroot:\=/%>> %descFile%
rem copy bla.tmp %descFile%
rem
rem  make main readme.md file
copy %libdir%\makeInvestigation.bat . >NUL 
copy %mroot%\showTree.bat . > NUL
copy %mroot%\showMetadata.bat . > NUL
copy %mroot%\xcheckMetadata.bat . > NUL
rem del *.tmp > NUL
rem process level specific items
 call %libdir%\lib.cmd :processMeta %mroot%\meta_p.ini
 copy %libdir%\meta_I.ini %proot%
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo      project METADATA
echo ======================================
call %libdir%\lib.cmd :showDesc %descFile%
cd..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
rem pause
echo.
echo ============================== pISA ==
echo.
echo project %ID% is ready.
echo .
echo ======================================
PAUSE
goto:eof