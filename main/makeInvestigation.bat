@echo off
rem
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
if "%1" EQU "" (
echo @
set /p ID=Enter Investigation ID: 
echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" set /p ID=Enter Investigation ID: 
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST %ID% (
REM Dir exists
echo ERROR: Investigation named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
echo %ID%
)
rem Ask for some additional info
call:getInput "Investigation Title" Title *
rem ----------------------------------------------

rem Make new Investigationt directory tree
rem set project root
set PPath=:getparentdir %cd%
rem set \ to /
set "PPath=!PPath:\=/!"
echo Project Path:	%cd% > _PROJECT_DESCRIPTION.TXT
echo %PPath%
rem
set Idir=_I_%ID%
md %Idir%
cd %Idir%
md presentations
md reports
rem xmd _STUDIES
rem put something to the directories
rem to force git to add them
echo # Investigation %ID% >  .\README.MD
echo # Reports for investigation %ID% >  .\reports\README.MD
echo # Presentations for investigation %ID% >  .\presentations\README.MD
rem xecho # Studies for investigation %ID% >  .\_STUDIES\README.MD
echo # Describe samples > .\phenodata.txt
echo # Feature Summary Table> .\FST.txt
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
::Create a TAB variable
call :hexprint "0x09" TAB
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!INVESTIGATION	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_DESCRIPTION.TXT
echo #### INVESTIGATION> .\_INVESTIGATION_DESCRIPTION.TXT
echo Short Name:	%ID%>> .\_INVESTIGATION_DESCRIPTION.TXT
echo Investigation Title:	%Title%>> .\_INVESTIGATION_DESCRIPTION.TXT
echo Investigation Description:	*>> .\_INVESTIGATION_DESCRIPTION.TXT
copy .\_INVESTIGATION_DESCRIPTION.TXT+..\common.ini .\_INVESTIGATION_DESCRIPTION.TXT
rem copy bla.tmp .\_INVESTIGATION_DESCRIPTION.TXT
echo Phenodata:	./data/phenodata.txt>> .\_INVESTIGATION_DESCRIPTION.TXT
echo Featuredata:	./data/featuredata.txt>> .\_INVESTIGATION_DESCRIPTION.TXT
echo ##### STUDIES!LF!>>  .\_INVESTIGATION_DESCRIPTION.TXT
rem
rem  make main readme.md file
copy ..\makeStudy.bat .
copy ..\showTree.bat .
copy ..\showDescription.bat .
copy ..\xcheckDescription.bat .
copy ..\showTree.bat .
copy ..\showDescription.bat .
copy ..\xcheckDescription.bat .

type README.MD
dir.
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
rem pause
goto:eof
rem --------------------------------------------------------
rem Functions
:getInput   --- get text from keyboard
::          --- %~1 Input message (what o type
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:getInpt "Type something" xx default
SETLOCAL
:Ask
set x=%~3
set /p x=Enter %~1 [%x%]:
rem if %x% EQU "" set x="%~3"
if "%x%" EQU "" goto Ask
REM Check existence/uniqueness
if "%x%" EQU "*" goto done
IF EXIST "%x%" (
REM Dir exists
echo ERROR: %~1 *%x%* already exists
set x=""
goto Ask
) 
:done
(ENDLOCAL
    set "%~2=%x%"
)
GOTO:EOF
rem
rem Get parent dir
rem
:getparentdir
if "%~1" EQU "" goto :EOF
Set ParentDir=%~1
shift
goto :getparentdir