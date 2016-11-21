@echo off
rem -------------------------------------  pISA-tree v.0.2
rem
rem Create a new Assay tree in _ASSAYS directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if assay folder exists
rem robocopy %1 X-%1 /MIR
rem ------------------------------------------------------
echo ============================
echo pISA-tree: make ASSAY 
echo ----------------------------
rem ----------------------------------------------
rem Class: use argument 1 if present
set IDClass=""
if "%1" EQU "" (
rem echo @
set /p IDClass=Enter Assay Class [Wet/Dry]: 
) else (
set IDClass=%1
)
rem Ask for Class, loop if empty
:Ask1
if %IDClass% EQU "" set /p IDClass=Enter Assay Class [Wet/Dry]: 
if %IDClass% EQU "" goto Ask1
rem ----------------------------------------------
rem Type: use argument 2 if present
set IDType=""
if "%2" EQU "" (
set /p IDType=Enter Assay Type: 
) else (
set IDType=%2
)
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask2
if %IDType% EQU "" set /p IDType=Enter Assay Type: 
if %IDType% EQU "" goto Ask2
rem ----------------------------------------------
rem ID : use argument 3 if present
set IDName=""
if "%3" EQU "" (
set /p IDName=Enter Assay ID: 
) else (
set IDType=%3
)
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask3
if %IDName% EQU "" set /p IDName=Enter Assay ID: 
if %IDName% EQU "" goto Ask3
rem ----------------------------------------------
rem concatenate ID name
set ID=%IDName%-%IDType%
echo %ID%
rem ----------------------------------------------
rem Check existence
IF EXIST %ID% (
REM Dir exists
echo ERROR: Assay named *%ID%* already exists
rem set IDType=""
rem set IDClass=""
set IDName=""
set ID=""
goto Ask3
) ELSE (
REM Continue creating directory
)
rem ----------------------------------------------
rem /I: case insensitive compare
if /I %IDClass% EQU dry goto dry
if /I %IDClass% EQU d goto dry
if /I %IDClass% EQU wet goto wet
if /I %IDClass% EQU w goto wet
rem ----------------------------------------------

rem Make new assay directory tree
rem ----------------------------------------------
:dry
set IDClass=Dry
md %ID%
cd %ID%
md input
md reports
md scripts
md output
md other
rem put something in to force git to add new directories
echo # Assay %ID% >  .\README.MD
echo # Input for assay %ID% >  .\input\README.MD
echo # Reports for assay %ID% >  .\reports\figs\README.MD
echo # Scripts for assas %ID% >  .\scripts\README.MD
echo # Output of assay %ID% >  .\output\README.MD
echo # Other files for assay %ID% >  .\other\README.MD
goto Forall
rem ----------------------------------------------
:wet
set IDClass=Wet
md %ID%
cd %ID%
md reports
md output
md output/raw
md other
rem put something in to force git to add new directories
echo # Assay %ID% >  .\README.MD
echo # Reports for assay %ID% >  .\reports\figs\README.MD
echo # Output of assay %ID% >  .\output\README.MD
echo # Raw output of assay %ID% >  .\output\raw\README.MD
echo # Other files for assay %ID% >  .\other\README.MD
goto Forall
rem ----------------------------------------------
:Forall
rem
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
rem -----------------------------------------------
rem Find studyId (after \_STUDIES)
set "studyId=*"
set "mypath=%cd%"
set "value=%mypath:*\_STUDIES\=%"
if "%value%"=="%mypath%" echo "\_STUDIES\" not found &goto :eos
for /f "delims=\" %%a in ("%value%") do set "value=%%~a"
set studyId=%value%
:eos
echo --studyId--
rem Find Investigation Id (before \_STUDIES)
set "invId=*"
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
echo Investigation:	%invId% > .\_ASSAY_DESCRIPTION.TXT
echo Study:	%studyId%>> .\_ASSAY_DESCRIPTION.TXT
echo ### ASSAY>> .\_ASSAY_DESCRIPTION.TXT
echo Short Name:	%ID%>> .\_ASSAY_DESCRIPTION.TXT
echo Assay Class:	 %IDClass%>> .\_ASSAY_DESCRIPTION.TXT
echo Assay Title:	 *>> .\_ASSAY_DESCRIPTION.TXT
echo Assay Description:	 *>> .\_ASSAY_DESCRIPTION.TXT
echo Data:	>> .\_ASSAY_DESCRIPTION.TXT
copy .\_ASSAY_DESCRIPTION.TXT+..\..\..\..\..\common.ini .\_ASSAY_DESCRIPTION.TXT
echo ASSAY:	%ID%>> ..\..\_STUDY_DESCRIPTION.TXT
rem
rem  make main readme.md file
type README.MD
dir .
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
