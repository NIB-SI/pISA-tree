@echo off
rem ------------------------------------------------------
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
:Ask2
if %IDClass% EQU "" set /p IDClass=Enter Assay Class [Wet/Dry]: 
if %IDClass% EQU "" goto Ask2
rem ----------------------------------------------
rem ID and Type: use argument 2 if present
set IDType=""
if "%2" EQU "" (
set /p IDType=Enter Assay ID and Type [IDXX-Type]: 
) else (
set IDType=%2
)
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask
if %IDType% EQU "" set /p IDType=Enter Assay ID and Type [IDXX-Type]: 
if %IDType% EQU "" goto Ask
rem ----------------------------------------------
rem concatenate ID name
rem set ID=%IDType%-%IDClass%
set ID=%IDType% 
echo %ID%
rem ----------------------------------------------
rem Check existence
IF EXIST %ID% (
REM Dir exists
echo ERROR: Assay named *%ID%* already exists
set IDType=""
set IDClass=""
set ID=""
goto Ask
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
goto Finish
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
goto Finish
rem ----------------------------------------------
:Finish
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
echo Investigation:	%invId%!LF!Study:	%studyId%!LF!> .\_ASSAY_DESCRIPTION.TXT
echo ASSAY!LF!Short Name:	%ID%!LF!Assay Class:	 %IDClass%!LF!Assay Title:	 *!LF!Assay Description:	 *>> .\_ASSAY_DESCRIPTION.TXT
echo DATA:	!LF!>> .\_ASSAY_DESCRIPTION.TXT
copy .\_ASSAY_DESCRIPTION.TXT+..\..\..\..\..\project.ini .\_ASSAY_DESCRIPTION.TXT
echo ASSAY:	%ID%!LF!>> ..\..\_STUDY_DESCRIPTION.TXT
rem
rem  make main readme.md file
type README.MD
dir .
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
