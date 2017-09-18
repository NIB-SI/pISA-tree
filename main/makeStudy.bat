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
set Sdir=_S_%ID%
md %Sdir%
cd %Sdir%
md reports
rem put something to the directories
rem to force git to add them
echo # Study %ID% >  .\README.MD
echo # Reports for study %ID% >  .\reports\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
rem Find Investigation Id (before \_STUDIES)
set "prjID=*"
set "invId=*"
set "mypath=%cd%"
setlocal enabledelayedexpansion
set string=%mypath%
rem set "find=*\_STUDIES\"
set "find=*\_I_"
call set delete=%%string:!find!=%%
call set string=%%string:!delete!=%%
rem set "string=%string:\_STUDIES\=%"
set "string=%string:\_I_=%"
for /f  %%a in ("%string%") do (
set "string=%%~na"
)
set prjId=%string%
rem -----------------------------------------------
echo project:	%prjId%> .\_STUDY_DESCRIPTION.TXT
echo Investigation:	%invId%>> .\_STUDY_DESCRIPTION.TXT
echo Study:	%SDir%>> .\_STUDY_DESCRIPTION.TXT
echo ### STUDY>> .\_STUDY_DESCRIPTION.TXT
echo Short Name:	%ID%>> .\_STUDY_DESCRIPTION.TXT
echo Study Title:	*>> .\_STUDY_DESCRIPTION.TXT
echo Study Description:	*>> .\_STUDY_DESCRIPTION.TXT
copy .\_STUDY_DESCRIPTION.TXT+..\..\..\common.ini .\_STUDY_DESCRIPTION.TXT
echo Fitobase link:	>> .\_STUDY_DESCRIPTION.TXT
echo Raw Data:	>> .\_STUDY_DESCRIPTION.TXT
echo #### ASSAYS>>  .\_STUDY_DESCRIPTION.TXT
echo STUDY:	%ID%>> ..\_INVESTIGATION_DESCRIPTION.TXT
rem 
rem  make main readme.md file
copy ..\..\..\makeAssay.bat .
copy ..\..\showTree.bat .
copy ..\..\showDescription.bat .
copy ..\..\xcheckDescription.bat .
type README.MD
del *.tmp
dir .
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
