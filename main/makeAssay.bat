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
:Ask
if "%1" EQU "" (
echo ============================
echo pISA-tree: make ASSAY 
echo ----------------------------
set /p ID1=Enter Assay ID: 
) else (
set ID1=%1
)
if %ID1% EQU "" goto Ask
rem ----------------------------------------------
rem Ask for Type, loop if empty
set ID2=""
:Ask2
if "%2" EQU "" (
rem echo @
set /p ID2=Enter Assay Type: 
) else (
set ID2=%2
)
if %ID2% EQU "" goto Ask2
rem ----------------------------------------------
rem concatenate ID name
set ID=%ID1%-%ID2%
echo %ID%
rem ----------------------------------------------
rem Make new assay directory tree
if %ID2% EQU Stat goto Stat
if %ID2% EQU NGS goto NGS
rem ----------------------------------------------
:Stat
md %ID%
cd %ID%
md data
md data\raw
md presentations
md results
md doc
md doc\figs
md R
rem put something in to force git to add new directories
echo # %ID% >  .\README.MD
echo # %ID% >  .\doc\README.MD
echo # %ID% >  .\doc\figs\README.MD
echo # %ID% >  .\results\README.MD
echo # %ID% >  .\data\README.MD
echo # %ID% >  .\data\raw\README.MD
echo # %ID% >  .\presentations\README.MD
echo # %ID% >  .\R\README.MD
goto Finish
rem ----------------------------------------------
:NGS
md %ID%
cd %ID%
md data
md presentations
md results
rem put something in to force git to add new directories
echo # %ID% >  .\README.MD
echo # %ID% >  .\results\README.MD
echo # %ID% >  .\data\README.MD
echo # %ID% >  .\data\raw\README.MD
echo # %ID% >  .\presentations\README.MD
goto Finish
rem ----------------------------------------------
:Finish
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
echo ASSAY!LF!SHORT NAME:	%ID%!LF!DESCRIPTION:	 > .\_ASSAY_DESCRIPTION.TXT
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
