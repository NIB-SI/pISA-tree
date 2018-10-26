@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Rename description files into METADATA file for levels below the current level
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
setlocal EnableDelayedExpansion
set lfn=Metadata.md
set LF=^


REM Two empty lines are necessary
echo !LF!*!LF!>line.tmp
call:fixname _PROJECT_DESCRIPTION.TXT _PROJECT_METADATA.TXT
call:fixname _INVESTIGATION_DESCRIPTION.TXT _INVESTIGATION_METADATA.TXT
call:fixname _STUDY_DESCRIPTION.TXT _STUDY_METADATA.TXT
call:fixname _ASSAY_DESCRIPTION.TXT _ASSAY_METADATA.TXT
call:fixname showDescription.bat showMetadata.bat
call:fixname xcheckDescription.bat xcheckMetadata.bat
PAUSE
dir *description.txt /S
dir *.description.bat /S
goto:eof
rem ---------- functions ---------------------------------
:fixname --- rename files down the directory tree
::      --- %~1 Existing name
::      --- %~2 New name
echo %~1 -- %~2
REM Find DESCRIPTION FILES
where /R . %~1 > src.tmp
type src.tmp
pause
For /F "tokens=1*" %%i in (src.tmp) do (
ren %%i %~2
)
REM NO DESCRIPTION files should be left
where /R . %~1
REM Just METADATA files should be listed
where /R . %~2
pause
GOTO:EOF
