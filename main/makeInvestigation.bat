@echo off
rem ------------------------------------------------------
rem Create a new Investigation tree in current directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if the folder exists
rem robocopy %ID% X-%ID% /MIR
rem ------------------------------------------------------
echo =============================
echo pISA-tree: make INVESTIGATION 
echo -----------------------------
rem Ask for study ID, loop if empty
set ID=""
:Ask
if "%1" EQU "" (
echo @
set /p ID=Enter Investigation ID: 
echo %ID%
) else (
set ID=%1
)
if %ID% EQU "" goto Ask
IF EXIST %ID% (
REM Dir exists
echo ERROR: Investigation named *%ID%* already exists
goto Ask
) ELSE (
REM Continue creating directory
echo %ID%
)
rem ----------------------------------------------

rem Make new Investigationt directory tree
md %ID%
cd %ID%
md presentations
md reports
md _STUDIES
rem put something to the directories
rem to force git to add them
echo # Investigation %ID% >  .\README.MD
echo # Reports for investigation %ID% >  .\reports\README.MD
echo # Presentations for investigation %ID% >  .\presentations\README.MD
echo # Studies for investigation %ID% >  .\_STUDIES\README.MD
echo # Describe samples > .\phenodata.txt
echo # Feature Summary Table> .\FST.txt
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
::Create a TAB variable
call :hexprint "0x09" TAB
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!INVESTIGATION	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_DESCRIPTION.TXT
echo INVESTIGATION!LF!Short Name:	%ID%!LF!Investigation Title:	*!LF!Investigation Description:	*> .\_INVESTIGATION_DESCRIPTION.TXT
copy .\_INVESTIGATION_DESCRIPTION.TXT+..\project.ini .\_INVESTIGATION_DESCRIPTION.TXT
rem copy bla.tmp .\_INVESTIGATION_DESCRIPTION.TXT
echo PHENODATA:	./data/phenodata.txt!LF!FEATUREDATA:	./data/featuredata.txt!LF!>> .\_INVESTIGATION_DESCRIPTION.TXT
rem
rem  make main readme.md file
copy ..\makeStudy.bat .\_STUDIES
copy ..\makeTree.bat .
copy ..\Description.bat .
copy ..\makeTree.bat .\_STUDIES
copy ..\Description.bat .\_STUDIES
type README.MD
dir.
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
rem pause