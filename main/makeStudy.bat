@echo off
rem ------------------------------------------------------
rem Create a new Study tree in _STUDIES directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if project folder exists
rem robocopy %1 X-%1 /MIR
rem ------------------------------------------------------
echo ============================
echo pISA-tree: make STUDY 
echo ----------------------------
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
echo @
set /p ID=Enter Study ID: 
echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" set /p ID=Enter Study ID: 
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST %ID% (
REM Dir exists
echo ERROR: Study named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
echo %ID%
)

rem ----------------------------------------------
rem Make new Study directory tree
md %ID%
cd %ID%
md reports
md _ASSAYS
rem put something to the directories
rem to force git to add them
echo # Study %ID% >  .\README.MD
echo # Reports for study %ID% >  .\reports\README.MD
echo # Assays for study %ID% >  .\_ASSAYS\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
rem Find Investigation Id (before \_STUDIES)
set "invId=*"
set "mypath=%cd%"
setlocal enabledelayedexpansion
set string=%mypath%
set "find=*\_STUDIES\"
call set delete=%%string:!find!=%%
call set string=%%string:!delete!=%%
set "string=%string:\_STUDIES\=%"
for /f  %%a in ("%string%") do (
set "string=%%~na"
)
set invId=%string%
rem -----------------------------------------------
echo Investigation:	%invId%!LF!> .\_STUDY_DESCRIPTION.TXT
echo ### STUDY!LF!Short Name:	%ID%!LF!Study Title:	*!LF!Study Description:	*>> .\_STUDY_DESCRIPTION.TXT
copy .\_STUDY_DESCRIPTION.TXT+..\..\..\project.ini .\_STUDY_DESCRIPTION.TXT
echo Fitobase link:	!LF!Raw Data:	!LF!>> .\_STUDY_DESCRIPTION.TXT
echo ### ASSAYS!LF!>>  .\_STUDY_DESCRIPTION.TXT
echo STUDY:	%ID%>> ..\..\_INVESTIGATION_DESCRIPTION.TXT
rem
rem  make main readme.md file
copy ..\..\..\makeAssay.bat .\_ASSAYS
copy ..\..\showTree.bat .\_ASSAYS
copy ..\..\showDescription.bat .\_ASSAYS
copy ..\..\checkDescription.bat .\_ASSAYS
copy ..\..\showTree.bat .
copy ..\..\showDescription.bat .
copy ..\..\checkDescription.bat .
type README.MD
del *.tmp
dir .
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
