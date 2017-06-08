@echo off
rem -------------------------------------  pISA-tree v.0.3
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
rem
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
set "TAB=	"
echo =================================
echo pISA-tree: make ASSAY 
echo ---------------------------------
set hd=---------------------------------/
set hd=%hd%pISA-tree: make ASSAY/
set hd=%hd%---------------------------------/
call:displayhd "%hd%"
rem ----------------------------------------------
rem Class: use argument 1 if present
set mydate=%date:~13,4%-%date:~9,2%-%date:~5,2%
set IDClass=
rem if "%1" EQU "" (
rem echo @
rem set /p IDClass=Enter Assay Class [ Wet/Dry ]: 
rem ) else (
rem set IDClass=%1
rem )
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
SET "types="
FOR /f "delims=" %%i IN ('dir ..\..\..\..\Templates /b') DO (
    SET types=!types!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
set "IdClass="
call:getMenu "Select Assay Class" %types% IDClass
set "hd=%hd%Assay Class:		 %~4%IDClass%/"
call:displayhd "%hd%"
rem echo Selected: %IDClass%
rem ----------------------------------------------
rem Supported types
if /I %IDClass% EQU Wet set "types=NGS / RT"
if /I %IDClass% EQU Dry set "types=R / Stat"
SETLOCAL ENABLEDELAYEDEXPANSION
SET "types="
FOR /f "delims=" %%i IN ('dir ..\..\..\..\Templates\%IDClass% /b') DO (
    SET types=!types!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
set "IDType="
call:getMenu "Select Assay Type" %types% IDType
set "hd=%hd%Assay Type:		 %~4%IDType%/"
call:displayhd "%hd%"
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
set "hd=%hd%Assay ID:		 %~4%ID%/"
call:displayhd "%hd%"
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
echo # Reports for assay %ID% >  .\reports\README.MD
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
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
set "TAB=	"
rem -----------------------------------------------
rem Find studyId (after \_STUDIES)
set "studyId=*"
set "mypath=%cd%"
set "value=%mypath:*\_STUDIES\=%"
if "%value%"=="%mypath%" echo "\_STUDIES\" not found &goto :eos
for /f "delims=\" %%a in ("%value%") do set "value=%%~a"
set studyId=%value%
:eos
rem --studyId--
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
rem -------------------------------------- make ASSAY_DESCRIPTION
set descFile=".\_ASSAY_DESCRIPTION.TXT"
echo Investigation:	%invId% > %descFile%
echo Study:	%studyId%>> .\_ASSAY_DESCRIPTION.TXT
echo ### ASSAY>> .\_ASSAY_DESCRIPTION.TXT
echo Short Name:	%ID%>> .\_ASSAY_DESCRIPTION.TXT
echo Assay Class:	 %IDClass%>> .\_ASSAY_DESCRIPTION.TXT
rem ECHO ON
  rem set analytesInput=Analytes.txt
  rem if exist ../%analytesInput% ( copy ../%analytesInput% ./%analytesInput% )
  call:inputMeta "Assay Title" aTitle *
  call:inputMeta "Assay Description" aDesc *
rem ---- Type specific fields
if /I "%IDType%" == "NGS" goto NGS
if /I "%IDType%" == "RNAisol" goto NGS
if /I "%IDType%" == "RT" goto RT
if /I "%IDType%" == "R" goto R
if /I "%IDType%" == "Stat" goto Stat
echo .
echo Warning: Unseen Assay Type: *%IDType%* - will make Generic %IDClass% Assay
echo .
pause
goto Finish
rem
:NGS
REM ------------------------------------------ NGS
  set analytesInput=Analytes.txt
  if exist ..\%analytesInput% ( copy ..\%analytesInput% .\%analytesInput% )
  set line1=
  set line2=
  call:putMeta2 "RNA ID" a01 RNA XIDX_
  rem set "line1=RNA-ID	ng/ul	260/280	260/230"
  rem set "line2=XIDX_%a01%_%IDType%			"
  set "line2=%line2%_%IDType%"
  call:putMeta2 "ng/ul" a100 Blank
  call:putMeta2 "260/280" a100 Blank
  call:putMeta2 "260/230" a100 Blank
  call:putMeta2 "Homogenisation protocol" a02 fastPrep/slowPrep
  call:putMeta2 "Date Homogenisation" a03 %mydate%
  call:putMeta2 "Isolation Protocol" a04 Rneasy_Plant
  call:putMeta2 "Date Isolation" a05 %mydate%
  call:putMeta2 "Storage RNA" a06 CU0369
  call:putMeta2 "Dnase treatment protocol" a7 *
  call:putMeta2 "Dnase ID" a8 DNase XIDX_
  call:putMeta2 "Date DNAse_treatment" a9 %mydate%
  call:putMeta2 "Storage_DNAse_treated" a10 CU0370
  call:putMeta2 "Operator" a11 "*"
  call:putMeta2 "cDNA ID" a12 cDNA XIDX_
  call:putMeta2 "DateRT" a13 %mydate%
  call:putMeta2 "Operator" a14 %a11%
  call:putMeta2 "Notes" a15 " "
  call:putMeta2 "Fluidigm_chip" a16 Chip10

  call:writeAnalytes %analytesInput% "%line1%" "%line2%"
REM
  goto Finish
REM ---------------------------------------- /NGS
:RT
REM ---------------------------------------- RT
  set analytesInput=Analytes.txt
  if exist ..\%analytesInput% ( copy ..\%analytesInput% .\%analytesInput% )
  set line1=
  set line2=
  call:putMeta2 "Dnase ID" a03	DNASE	XIDX_
  call:putMeta2 "RTprotocol" a04 " "
  call:putMeta2 "cDNA ID" a05 cDNA XIDX_
  call:putMeta2 "DateRT" a06 %mydate%
  call:putMeta2 "Operator" a07 *
  
  call:writeAnalytes %analytesInput% "%line1%" "%line2%"
REM
    goto Finish
REM ---------------------------------------- /RT
:R
REM ---------------------------------------- R
    goto Finish
REM ---------------------------------------- /R
:Stat
REM ---------------------------------------- R
    goto Finish
REM ---------------------------------------- /R
:Finish
echo Data:	>> .\_ASSAY_DESCRIPTION.TXT
rem ------------------------------------  include common.ini
copy .\_ASSAY_DESCRIPTION.TXT+..\..\..\..\..\common.ini .\_ASSAY_DESCRIPTION.TXT
echo ASSAY:	%ID%>> ..\..\_STUDY_DESCRIPTION.TXT
rem
rem  make main readme.md file
type README.MD
dir .
cls
type _ASSAY_DESCRIPTION.TXT
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
echo Assay %ID% is ready.
PAUSE
goto:eof
rem ====================================== / makeAssay
rem --------------------------------------------------------
rem Functions
:getInput   --- get text from keyboard
::          --- %~1 Input message (what to enter)
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:getInpt "Type something" xx default
SETLOCAL
:Ask
echo.
echo =========================
echo.
set "x=%~3"
set /p x=Enter %~1 [ %x% ]: 
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
 IF "%~2" NEQ "" set "%~2=%x%"
)
GOTO:EOF
rem -----------------------------------------------------
:putMeta   --- get metadata and append to descFile
::         --- descFile - should be set befor the call
::          --- %~1 Input message (what to enter)
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:putMeta "Type something" xx default
SETLOCAL
rem call:getInput "%~1" xMeta "%~3"
rem Type input or get menu?

call:getMenu "%~1" %~3/getMenu xMeta "%~3"
echo %~1:	%xMeta% >> %descFile%
rem call:writeAnalytes %analytesInput% "%~1" %xMeta% 
rem


rem
(ENDLOCAL
    IF "%~2" NEQ "" set "%~2=%xMeta%"
    set "aEntered=%xMeta%"
    set "hd=%hd%%~1:		 %xMeta%/"
    call:displayhd "%hd%"

)
GOTO:EOF
rem -----------------------------------------------------
:inputMeta   --- get metadata and append to descFile
::         --- descFile - should be set befor the call
::          --- %~1 Input message (what to enter)
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:putMeta "Type something" xx default
SETLOCAL
rem call:getInput "%~1" xMeta "%~3"
rem Type input or get menu?

call:getInput "%~1" xMeta "%~3"
echo %~1:	%xMeta% >> %descFile%
rem call:writeAnalytes %analytesInput% "%~1" %xMeta% 
rem


rem
(ENDLOCAL
    IF "%~2" NEQ "" set "%~2=%xMeta%"
    set "aEntered=%xMeta%"
    )
GOTO:EOF
rem --------------------------------------------------------
:getMenu    --- get menu item
::          --- %~1 Value description
::          --- %~2 String of choices (aa/bb/cc)
::          --- %~3 Variable to get result
::          --- %~4 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:getMenu "Select input" list/of/choices u
SETLOCAL
rem Make menu function
rem cls
echo.
echo =========================
echo.
echo %~1
echo.
set mn=%~2
rem 
IF NOT "%mn:~-1%"=="/" set mn=%mn%/
set _mn=%mn%
set nl=0
set mch=
echo %mn%
echo. 
:top
rem if "%mn%"=="" goto :done
set /A "nl=%nl%+1"
set mch=%mch%%nl%
for /F "tokens=1 delims=/" %%H in ("%mn%") DO echo    %nl% %%H
set mn=%mn:*/=%
if NOT "%mn%"=="" goto :top
rem :done
echo. 
choice /C:%mch% /M:Select 
(ENDLOCAL
    for /F "tokens=%errorlevel% delims=/" %%H in ("%_mn%") DO set "%~3=%%H
)
GOTO:EOF
rem -----------------------------------------------------
:putMeta2   --- get metadata and append to descFile
::         --- descFile - should be set befor the call
::          --- %~1 Input message (what to enter)
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: input required
::          ---                * : can be skipped, return *
::          --- %~4 optional prefix; some values have to be prefixed by SampleID
::                  XIDX will be replaced by SampleID upon writing to file
:: Example: call:putMeta2 "Type something" xx default
rem SETLOCAL
if "%~3"=="*" call:getInput "%~1" xMeta "%~3" & GOTO:next
if "%~3"==" " call:getInput "%~1" xMeta "%~3" & GOTO:next
if /I "%~3"=="Blank" set xMeta="" & GOTO:next
rem call:getInput "%~1" xMeta "%~3"
call:getMenu "%~1" "%~3/Other" xMeta "%~3"
if "%xMeta%"=="Other" call:getInput "%~1" xMeta "%~3"
:next
echo %~1:	%xMeta% >> %descFile%
rem call:writeAnalytes %analytesInput% "%~1" %xMeta% 
rem
REM (ENDLOCAL
set "%~2=%xMeta%"
set "line1=%line1%	%~1"
set "line2=%line2%	%~4%xMeta%"
if /I "%~3" NEQ "Blank" set "hd=%hd%%~1:		 %~4%xMeta%/" & call:displayhd "%hd%"
REM )
GOTO:EOF
rem ---------------------------------------------------
:writeAnalytes  --- write colums to analyte file
::              --- %~1 file to process
::              --- %~2 string for the first line
::              --- %~3 string for other lines
rem SETLOCAL
rem IF EXIST %~1 (

    rem First line
    set /p z= <%~1
    set x2=%~2
    set x2=%x2: =%
    rem set str=%str: =%
    echo %z%	%x2%  > tmp.txt
    rem Process other lines
    set "SEARCHTEXT=XIDX"
    set "line=%~3"
    for /f "skip=1 tokens=1,* delims=	 " %%a in (%~1) do (
    echo on
    set "TAB=	"
      	echo %%a
      	echo %%b
      	echo %~3
      	setlocal enabledelayedexpansion
      rem	set "line=!line:%search%=%replace%!"
      SET "modified=!line:%SEARCHTEXT%=%%a!"
      echo %searchtext% %modified%
      	rem should replace special token with SampleId before writing
       echo %%a	%%b	!modified! >> tmp.txt 
       endlocal
       echo off
       )
    copy tmp.txt %~1
rem )
rem ENDLOCAL
del tmp.txt
GOTO:EOF
rem --------------------------------------------------
:displayhd  --- clear screen and display header
::          --- %~1 header text, use / as the new line character
:: Example: call:displayhd list/of/choices
set mn=%~1
SETLOCAL
cls
IF NOT "%mn:~-1%"=="/" set mn=%mn%/
:tophd
FOR /F "delims=/" %%i IN ("%mn%") DO echo %%i
set mn=%mn:*/=%
if NOT "%mn%"=="" goto :tophd
ENDLOCAL
goto:EOF