@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Create a new Assay tree _A_xxx in the current study directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if assay folder exists
rem robocopy %1 X-%1 /MIR
rem ------------------------------------------------------
rem
TITLE pISA-tree
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
set "TAB=	"
echo =================================
echo pISA-tree: make ASSAY 
echo ---------------------------------
rem ----------- init directories
set descFile=".\_Assay_METADATA.TXT"
set "sroot=%cd%"
set "pISAroot=%sroot%\..\..\.."
set "mroot=%sroot%\..\..\.."
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
rem -----------
call %libdir%\lib.cmd :getLayer _S_ sname
rem Check Study existence
if x%sname::=%==x%sname% goto sok
echo.
echo ERROR: Make Study first!
echo.
pause
goto:eof
:sok
rem Study already created
set hd=---------------------------------/
set hd=%hd%pISA-tree: make ASSAY/
set hd=%hd%---------------------------------/
call %libdir%\lib.cmd :displayhd "%hd%"
set sroot=%cd%
set "iroot=.."
set "proot=..\%iroot%"
set "mroot=..\%proot%"
rem dir %tmpldir%
rem pause
rem ----------------------------------------------
rem Class: use argument 1 if present
rem set today=%date:~13,4%-%date:~9,2%-%date:~5,2%
call %libdir%\lib.cmd :normalizeDate today -
rem set IDClass=
rem if "%1" EQU "" (
rem echo @
rem set /p IDClass=Enter Assay Class [ Wet/Dry ]: 
rem ) else (
rem set IDClass=%1
rem )
rem ---------------------------------------------
rem Ask for Class, loop if empty
:Ask1
rem if %IDClass% EQU "" set /p IDClass=Enter Assay Class [ Wet/Dry ]: 
rem if %IDClass% EQU "" goto Ask1
rem /I: case insensitive compare
rem if /I %IDClass% EQU dry (set IDClass=Dry)
rem if /I %IDClass% EQU d set IDClass=Dry
rem if /I %IDClass% EQU wet set IDClass=Wet
rem if /I %IDClass% EQU w set IDClass=Wet
SETLOCAL ENABLEDELAYEDEXPANSION
rem Supported classes
SET "types="
FOR /f "delims=" %%i IN ('dir %tmpldir%\*. /AD/B') DO (
    SET types=!types!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
if "%1" EQU "" (
 set "IdClass="
 call %libdir%\lib.cmd :getMenu "Select Assay Class" %types% IDClass ) else (
 set "IdClass=%1"
)
set "hd=%hd%Assay Class:		 %~4%IDClass%/"
call %libdir%\lib.cmd :displayhd "%hd%"
echo Selected: %IDClass%
rem ----------------------------------------------
rem Supported types
rem if /I %IDClass% EQU Wet set "types=NGS / RT"
rem if /I %IDClass% EQU Dry set "types=R / Stat"
SETLOCAL ENABLEDELAYEDEXPANSION
SET "types="
FOR /f "delims=" %%i IN ('dir %tmpldir%\%IDClass% /AD/B') DO (
    SET types=!types!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
if "%2" EQU "" (
set "IDType="
rem echo %tmpldir%\%IDClass%
call %libdir%\lib.cmd :getMenu "Select Assay Type" "%types%Other" IDType ) else (
set "IDType=%2"
)
rem process Other type
if %IDType% EQU Other (
rem Create new assay type if needed
echo:
set "NewType=""
:Ask4
if %NewType%* EQU * call %libdir%\lib.cmd :askFile "Enter new Assay Type ID: " NewType 
if %NewType%* EQU * goto Ask4
rem check type existence/uniqueness
if exist %tmpldir%\DRY\%NewType% ( 
  echo.
  echo. ERROR: DRY assay type %NewType% already exists
  echo.
  set "NewType=" 
  goto Ask4)
  if exist %tmpldir%\WET\%NewType% ( 
  echo.
  echo. ERROR: WET assay type %NewType% already exists
  echo.
  set "NewType=" 
  goto Ask4)
rem type ok
md %tmpldir%\%IDClass%\%NewType%
echo Creation date	%today%> %tmpldir%\%IDClass%\%NewType%\AssayType.ini
echo New %IDClass% Assay Type was created: %NewType%
set "IDType=%NewType%"
)
rem Other finished
set "hd=%hd%Assay Type:		 %~4%IDType%/"
call %libdir%\lib.cmd :displayhd "%hd%"
rem echo Selected: %IDType%
rem ----------------------------------------------
rem Type: use argument 2 if present
rem set IDType=""
rem if "%2" EQU "" (
rem set /p IDType=Enter Assay Type [ %types% ]: 
rem ) else (
rem set IDType=%2
rem )
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask2
rem if %IDType% EQU "" set /p IDType=Enter Assay Type [ %types% ]: 
rem if %IDType% EQU "" goto Ask2
rem ----------------------------------------------
rem ID : use argument 3 if present
set IDName=""
if "%3" EQU "" (
call %libdir%\lib.cmd :askFile "Enter Assay ID: " IDName 
) else (
set IDName=%3
)
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask3
if %IDName% EQU "" call %libdir%\lib.cmd :askFile "Enter Assay ID: " IDName 
if %IDName% EQU "" goto Ask3
rem ----------------------------------------------
rem concatenate ID name
set ID=%IDName%-%IDType%
echo %ID%
rem ----------------------------------------------
rem Check existence
IF EXIST _A_%ID% (
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
set "hd=%hd%Assay ID:		 %~4%ID%/"
call %libdir%\lib.cmd :displayhd "%hd%"
set Adir=_A_%ID%
md %Adir%
cd %Adir%
set aroot=%cd%
set "sroot=.."
set "iroot=%sroot%\.."
set "proot=%iroot%\.."
set "mroot=%proot%\.."
goto %IDClass%
rem ----------------------------------------------
rem Make new assay directory tree
rem ----------------------------------------------
:dry
REM set IDClass=Dry
md input
md reports
md scripts
md output
md other
rem put something in to force git to add new directories
echo # Assay %ID% >  .\README.MD
echo # Input for assay %ID% >  .\input\README.MD
echo # Reports for assay %ID% >  .\reports\README.MD
echo # Scripts for assas %ID% >  .\scripts\README.MD
echo # Output of assay %ID% >  .\output\README.MD
echo # Other files for assay %ID% >  .\other\README.MD
goto Forall
rem ----------------------------------------------
:wet
REM set IDClass=Wet
md reports
md output
cd output
md raw
cd ..
md other
rem put something in to force git to add new directories
echo # Assay %ID% >  .\README.MD
echo # Reports for assay %ID% >  .\reports\README.MD
echo # Output of assay %ID% >  .\output\README.MD
echo # Raw output of assay %ID% >  .\output\raw\README.MD
echo # Other files for assay %ID% >  .\other\README.MD
goto Forall
rem ----------------------------------------------
:Forall
rem
echo %cd%
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
set "TAB=	"
rem -----------------------------------------------
call %libdir%\lib.cmd :getLayer _p_ pname
call %libdir%\lib.cmd :getLayer _I_ iname
call %libdir%\lib.cmd :getLayer _S_ sname
call %libdir%\lib.cmd :getLayer _A_ aname
rem -------------------------------------- make ASSAY_METADATA
echo Assay:	%Adir%> %descFile%
echo Study:	%sname%>> %descFile%
echo Investigation:	%iname%>> %descFile%
echo project:	%pname%>> %descFile%
rem echo ### ASSAY>> %descFile%
echo Short Name:	%ID%>> %descFile%
echo Assay Class:	%IDClass%>> %descFile%
echo Assay Type:	%IDType%>> %descFile%
rem ECHO ON
  rem set analytesInput=Analytes.txt
  rem if exist ../%analytesInput% ( copy ../%analytesInput% ./%analytesInput% )
  call %libdir%\lib.cmd :inputMeta "Title" aTitle *
  call %libdir%\lib.cmd :inputMeta "Description" aDesc *
rem echo Assay Path:	%cd:\=/%>> %descFile%
rem set phenodata file
rem process level specific items
 call %libdir%\lib.cmd :processMeta %sroot%\meta_A.ini
 call %libdir%\lib.cmd :processMeta %tmpldir%\%IDClass%\%IDType%\meta.ini
SETLOCAL ENABLEDELAYEDEXPANSION
SET "pfns="
FOR /f "delims=" %%i IN ('dir %iroot%\phenodata_20*.* /B') DO (
    SET pfns=!pfns!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
call %libdir%\lib.cmd :getMenu "Select phenodata file" "%pfns%None" pfn
if "%pfn%" EQU "None" ( echo Phenodata:	%pfn%>> %descFile%
) ELSE ( echo Phenodata:	%iroot:\=/%/%pfn%>> %descFile%)
rem ---- Type specific fields
set tasdir=%tmpldir%\%IDClass%\%IDType%
    set "line1="
    set "line2="
if /I "%IDClass%"=="WET" goto wetclass
if /I "%IDClass%"=="DRY" goto dryclass
rem if /I "%IDType%" == "R" goto R
rem if /I "%IDType%" == "Stat" goto Stat
echo .
echo Warning: Unseen Assay Type: *%IDType%* - will make Generic %IDClass% Assay
echo .
goto Finish
rem
:wetclass
REM ------------------------------------------ wetclass
rem cd
rem echo tst %tmpldir%\%IDClass%\%IDType%\AssayType.ini
rem dir %tmpldir%
rem dir ..\%tmpldir%
rem Assay type directory
rem dir %tasdir%
rem dir %tmpldir%
:: echo %cd%
set "analytesInput=Analytes.txt"
call %libdir%\lib.cmd :getSamples %IDName% %iroot%\%pfn% %aroot%\%analytesInput%
setlocal disabledelayedexpansion
rem  if exist %sroot%\%analytesInput% ( copy %sroot%\%analytesInput% %aroot%\%analytesInput% )
  rem dir %tmpldir%\%IDClass%\%IDType%\
    set "line1="
    set "line2="
if exist %tasdir%\AssayType.ini call %libdir%\lib.cmd :processAnalytes %tasdir%\AssayType.ini

 rem echo tst after processAnalytes: line1 %line1%
 rem echo tst after processAnalytes: line2 %line2%
 goto Finish
REM ------------------------------------------/wetclass
:dryclass
REM ---------------------------------------- dryclass
    copy %tmpldir%\upload.bat . > NUL
    copy %tmpldir%\ignore.txt . > NUL
    set "line1="
    set "line2="
    if exist %tasdir%\AssayType.ini call %libdir%\lib.cmd :processAnalytes %tasdir%\AssayType.ini
    goto Finish
REM ---------------------------------------- /dryclass
:Finish
echo Data:	>> %descFile%
rem ------------------------------------  include common.ini from project level
copy %descFile%+..\common.ini %descFile% \b >NUL
rem echo ASSAY:	%ID%>> ..\_STUDY_METADATA.TXT
copy %sroot%\showTree.bat . >NUL
copy %sroot%\showMetadata.bat . >NUL
copy %sroot%\xcheckMetadata.bat . >NUL

rem
rem  make main readme.md file
rem type README.MD
rem dir .
cls
echo ======================================
echo      Assay METADATA
echo ======================================
call %libdir%\lib.cmd :showDesc %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
echo.
echo ============================== pISA ==
echo.
echo Assay %ID% is ready.
echo .
echo ======================================

PAUSE
goto:eof
rem ====================================== / makeAssay
