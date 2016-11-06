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
:Ask
if "%1" EQU "" (
echo @
set /p ID=Enter Study ID: 
echo %ID%
) else (
set ID=%1
)
if %ID% EQU "" goto Ask
echo %ID%
rem ----------------------------------------------
rem Make new Study directory tree
md %ID%
cd %ID%
md presentations
md data
md results
md _ASSAYS
rem put something to the directories
rem to force git to add them
echo # %ID% >  .\README.MD
echo # %ID% >  .\doc\README.MD
echo # %ID% >  .\doc\figs\README.MD
echo # %ID% >  .\out\README.MD
echo # %ID% >  .\data\README.MD
echo # %ID% >  .\presentations\README.MD
echo # %ID% >  .\r\README.MD
echo # %ID% >  .\_analyses\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
echo STUDY!LF!SHORT NAME:	%ID%!LF!DESCRIPTION:	> .\_STUDY_DESCRIPTION.TXT
copy .\_STUDY_DESCRIPTION.TXT+..\..\..\project.ini .\_STUDY_DESCRIPTION.TXT
echo INVESTIGATION:	!LF!FITOBASE LINK:	!LF!RAW DATA:	!LF!>> .\_STUDY_DESCRIPTION.TXT
echo STUDY:	%ID%!LF!>> ..\..\_INVESTIGATION_DESCRIPTION.TXT
rem
rem  make main readme.md file
copy ..\..\..\makeAssay.bat .\_ASSAYS
copy ..\..\makeTree.bat .\_ASSAYS
copy ..\..\Description.bat .\_ASSAYS
type README.MD
del *.tmp
dir.
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
