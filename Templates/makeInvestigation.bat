@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Create a new Investigation tree _I_xxx in current directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if the folder exists
rem robocopy %ID% X-%ID% /MIR
rem ------------------------------------------------------
TITLE pISA-tree
echo =============================
echo pISA-tree: make INVESTIGATION 
echo -----------------------------
call:getLayer _p_ pname
rem Check project existence
if x%pname::=%==x%pname% goto pok
echo.
echo ERROR: Make project first!
echo.
pause
goto:eof
:pok
rem project already created
set descFile=".\_INVESTIGATION_METADATA.TXT"
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
call:askFile "Enter Investigation ID: " ID
rem echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call:askFile "Enter Investigation ID: " ID
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST _I_%ID% (
REM Dir exists
echo ERROR: Investigation named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
echo %ID%
)
rem ----------------------------------------------
rem Make new Investigationt directory tree
rem set project root
rem set PPath=:getparentdir %cd%
rem set \ to /
rem set "PPath=!PPath:\=/!"
rem echo %PPath%
rem
set Idir=_I_%ID%
md %Idir%
cd %Idir%
echo %cd%
set iroot=%cd%
set "proot=.."
set "mroot=..\%proot%"
set "tmpldir=%mroot%\Templates"
set "batdir=%mroot%\Templates"

call:getLayer _p_ pname
md presentations
md reports
rem put something to the directories
rem to force git to add them
echo # Investigation %ID% >  .\README.MD
echo # Reports for investigation %ID% >  .\reports\README.MD
echo # Presentations for investigation %ID% >  .\presentations\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
::Create a TAB variable (not realy needed)
REM Throws an error??
REM call :hexprint "0x09" TAB
rem -----------------------------------------------
call:getLayer _p_ pname
call:getLayer _I_ iname
REM -----------------------------------------------
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!INVESTIGATION	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_METADATA.TXT
echo Investigation:	%iname%> %descFile%
echo project:	%pname%>> %descFile%
rem echo ### INVESTIGATION>> %descFile%
echo Short Name:	%ID%>> %descFile%
  call:inputMeta "Title" aTitle *
  call:inputMeta "Description" aDesc *
rem echo Investigation Path:	%cd:\=/%>> %descFile%
rem copy bla.tmp %descFile%
rem create phenodata file name
call:normalizeDate danes
set pfn=phenodata_%danes%.txt
if exist %pfn% (
	echo Phenodata %pfn% already exists: will not overwrite it
	) else (
	rem Make test phenodata file
	echo Phenodata:	./%pfn%>> %descFile%
	echo SampleID	SampleName	AdditionalField1	Assay001> %pfn%
	echo SMPL001	Sample_001	B1	x>> %pfn%
	echo SMPL002	Sample_002	B2	>> %pfn%
	echo SMPL003	Sample_003	B3	x>> %pfn%
	echo SMPL004	Sample_004	B4	>> %pfn%
rem End test %pfn%
)
echo Featuredata:	>> %descFile%
rem echo INVESTIGATION:	%ID%>> ..\_PROJECT_METADATA.TXT

rem
rem  make main readme.md file
copy %batdir%\makeStudy.bat . > NUL
copy %proot%\showTree.bat . > NUL
copy %proot%\showMetadata.bat . > NUL
copy %proot%\xcheckMetadata.bat . > NUL
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo Investigation METADATA
echo ======================================
type %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
rem pause
echo.
echo ============================== pISA ==
echo.
echo Investigation %ID% is ready.
echo .
echo ======================================

PAUSE
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
:Ask1
set x=%~3
set /p x=Enter %~1 [%x%]:
rem if %x% EQU "" set x="%~3"
if "%x%" EQU "" goto Ask1
REM Check existence/uniqueness
if "%x%" EQU "*" goto done
IF EXIST "%x%" (
REM Dir exists
echo ERROR: %~1 *%x%* already exists
set x=""
goto Ask1
) 
:done
(ENDLOCAL
    set "%~2=%x%"
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
echo %~1:	%xMeta%>> %descFile%
rem call:writeAnalytes %analytesInput% "%~1" %xMeta% 
rem


rem
(ENDLOCAL
    IF "%~2" NEQ "" set "%~2=%xMeta%"
    set "aEntered=%xMeta%"
    )
GOTO:EOF

rem ------------------------------------------------------
rem Get parent dir
rem
:getparentdir
if "%~1" EQU "" goto :EOF
Set ParentDir=%~1
shift
goto :getparentdir
rem -----------------------------------
:getLayer  --- get layer name from the current path
::                --- %~1 layer prefix (e.g. _I_)
::                --- %~2 Variable to get result
:: To remove characters from the right hand side of a string is 
:: a two step process and requires the use of a CALL statement
:: e.g.

   SET _test=D:\bla\_p_project\_I_test\_S_moj
   SET _test=%cd%

SETLOCAL EnableDelayedExpansion

   :: To delete everything after the string e.g. '_I_'  
   :: first delete .e.g. '_I_' and everything before it
   SET _test=!_test:*\%~1=%~1! 
   SET _endbit=%_test:*\=%
   REM Echo We dont want: [%_endbit%]

   ::Now remove this from the original string
   CALL SET _result=%%_test:\%_endbit%=%%
   rem echo %_result%
   (endlocal 
   set "%~2=%_result: =%")
   rem echo %iname%
   endlocal
goto :eof
REM ------------------------------------------------------
:hexPrint  string  [rtnVar]
  for /f eol^=^%LF%%LF%^ delims^= %%A in (
    'forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(%~1"'
  ) do if "%~2" neq "" (set %~2=%%A) else echo(%%A
GOTO:EOF
rem ---------------------------------------------------
setlocal enableextensions disabledelayedexpansion

:askFile    --- get file name
::          --- %~1 Question
::          --- %~2 Variable to get result 
::
:: Example: call:askFile "Enter project ID: " ID

    rem Retrieve filename. On empty input ask again
    set /p "my_file=%~1" || goto :askFile

    rem See Naming Files, Paths, and Namespaces
    rem     https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx

    for /f "tokens=2" %%a in ("%my_file%") do (
        Echo Error: Space is not allowed in ID
        goto :askFile
    )

    rem NOTE: From here, we will be enabling/disabling delayed expansion 
    rem       to avoid problems with special characters

    setlocal enabledelayedexpansion
    rem Ensure we do not have restricted characters in file name trying to use them as 
    rem delimiters and requesting the second token in the line
    for /f tokens^=2^ delims^=^<^>^:^"^/^\^|^?^*^ eol^= %%y in ("[!my_file!]") do (
        rem If we are here there is a second token, so, there is a special character
        echo Error : Non allowed characters in ID
        endlocal & goto :askFile
    )

    rem Check MAX_PATH (260) limitation
    set "my_temp_file=!cd!\!my_file!" & if not "!my_temp_file:~260!"=="" (
        echo Error : ID name too long
        endlocal & goto :askFile
    )

    rem Check path inclusion, file name correction
    for /f delims^=^ eol^= %%a in ("!my_file!") do (
        rem Cancel delayed expansion to avoid ! removal during expansion
        endlocal

        rem Until checked, we don't have a valid file
        set "my_file="

        rem Check we don't have a path 
        if /i not "%%~a"=="%%~nxa" (
            echo Error : Paths are not allowed
            goto :askFile
        )

        rem Check it is not a folder 
        if exist "%%~nxa\" (
            echo Error : Folder with same name present 
            goto :askFile
        )

        rem ASCII 0-31 check. Check file name can be created
        2>nul ( >>"%%~nxa" type nul ) || (
            echo Error : File name is not valid for this file system
            goto :askFile
        )

        rem Ensure it was not a special file name by trying to delete the newly created file
        2>nul ( del /q /f /a "%%~nxa" ) || (
            echo Error : Reserved file name used
            goto :askFile
        )

        rem Everything was OK - We have a file name 
        set "my_file=%%~nxa"
    )

    rem echo Selected file is "%my_file%"
    (endlocal 
     set "%~2=%my_file%")
goto :eof
rem ------------------------------------------------------------
:normalizeDate --- normalize current date into YYYYMMDD
::                 should work for all native formats 0=m-d-y; 1=d-m-y; 2=y-m-d
::             --- %~1 variable to accept result
::             --- %~2 optional delimiter
:: Return: current date in YYYYMMDD form
:: Example: call:normalizeDate
rem @echo on
rem echo %~1
rem echo +%~2+
@Echo OFF
rem get date format info from registry
rem https://docs.microsoft.com/en-us/windows/desktop/intl/locale-idate
SETLOCAL
If "%Date%A" LSS "A" (Set _NumTok=1-3) Else (Set _NumTok=2-4)
:: Default Delimiter of TAB and Space are used
For /F "TOKENS=2*" %%A In ('REG QUERY "HKCU\Control Panel\International" /v iDate') Do Set _iDate=%%B
For /F "TOKENS=2*" %%A In ('REG QUERY "HKCU\Control Panel\International" /v sDate') Do Set _sDate=%%B
IF %_iDate%==0 For /F "TOKENS=%_NumTok% DELIMS=%_sdate% " %%F In ("%Date%") Do CALL :procdate %%H %%F %%G %~2
IF %_iDate%==1 For /F "TOKENS=%_NumTok% DELIMS=%_sdate% " %%F In ("%Date%") Do CALL :procdate %%H %%G %%F %~2
IF %_iDate%==2 For /F "TOKENS=%_NumTok% DELIMS=%_sdate% " %%F In ("%Date%") Do CALL :procdate %%F %%G %%H %~2
endlocal&SET YYYYMMDD=%YYYYMMDD%&set "%~1=%YYYYMMDD%"
GOTO :eof
::
:: Date elements are supplied in Y,M,D order but may have a leading zero
::
:procdate
set sep=%4
:: if single-digit day then 1%3 will be <100 else 2-digit
IF 1%3 LSS 100 (SET YYYYMMDD=0%3) ELSE (SET YYYYMMDD=%3)
:: if single-digit month then 1%2 will be <100 else 2-digit
IF 1%2 LSS 100 (SET YYYYMMDD=0%2%sep%%YYYYMMDD%) ELSE (SET YYYYMMDD=%2%sep%%YYYYMMDD%)
:: Similarly for the year - I've never seen a single-digit year
IF 1%1 LSS 100 (SET YYYYMMDD=20%sep%%YYYYMMDD%) ELSE (SET YYYYMMDD=%1%sep%%YYYYMMDD%)
GOTO :eof
rem -------------------------------------------------------------------
:showDesc   --- show description file in columns 
::          --- %~1 file name
::
:: Example: call:showDesc %descFile%
::
setlocal
For /F "TOKENS=1,2" %%A In (%~1) echo %%A		%%B
endlocal
goto :EOF