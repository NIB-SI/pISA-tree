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
rem Ask for ID, loop if empty
set ID1=""
if "%1" EQU "" (
echo ============================
echo pISA-tree: make ASSAY 
echo ----------------------------
set /p ID1=Enter Assay ID: 
) else (
set ID1=%1
)
rem dir %ID1%* /B /AD
set ID2=""
if "%2" EQU "" (
rem echo @
set /p ID2=Enter Assay Type Wet/Dry: 
) else (
set ID2=%2
)
:Ask
if %ID1% EQU "" set /p ID1=Enter Assay ID: 
if %ID1% EQU "" goto Ask
rem ----------------------------------------------
rem Ask for Type, loop if empty
rem Similar Assay IDs
rem %ID1%* /AD
:Ask2
if %ID2% EQU "" set /p ID2=Enter Assay Type Wet/Dry: 
if %ID2% EQU "" goto Ask2

rem ----------------------------------------------
rem concatenate ID name
rem set ID=%ID1%-%ID2%
set ID=%ID1% 
echo %ID%
rem ----------------------------------------------
rem Check existence
IF EXIST %ID% (
REM Dir exists
echo ERROR: Assay named *%ID%* already exists
set ID1=""
set ID2=""
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
)
rem ----------------------------------------------
rem Make new assay directory tree
if %ID2% EQU dry goto dry
if %ID2% EQU d goto dry
if %ID2% EQU wet goto wet
if %ID2% EQU w goto wet
rem ----------------------------------------------
:dry
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


REM Two empty lines are necessary
echo ASSAY!LF!Short Name:	%ID%!LF!Assay Type:	 %ID2%!LF!Assay Title:	 *!LF!Assay Description:	 *> .\_ASSAY_DESCRIPTION.TXT
copy .\_ASSAY_DESCRIPTION.TXT+..\..\..\..\..\project.ini .\_ASSAY_DESCRIPTION.TXT
echo STUDY:	!LF!DATA:	!LF!>> .\_ASSAY_DESCRIPTION.TXT
echo ASSAY:	%ID%!LF!>> ..\..\_STUDY_DESCRIPTION.TXT
rem
rem  make main readme.md file
type README.MD
dir .
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
