@echo off
call %*
goto :EOF
rem --------------------------------------------------------
rem Functions
rem --------------------------------------------------------
:getInput   --- get text from keyboard
::          --- %~1 Input message (what to enter)
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: empty string is OK
::                             * : can be skipped, return *
::                             ! : input required, no empty string
:: Example: call:getInpt "Type something" xx default
SETLOCAL
:Ask1
echo.
echo =======================================================
echo.
:: Default for typing is the first item (needed for Other)
set "x=%~3"
set /p x=Enter %~1 [ %x% ]: 
rem if %x% EQU "" set x="%~3"
rem empty answer OK
if "%x%" EQU "" goto done 
if "%x%" EQU "*" goto done
REM Is input required and not entered?
REM Mostly intended for pISA file names
if "%x%" EQU "!" goto Ask1
goto done
REM Check existence/uniqueness
IF EXIST "%x%" (
REM Dir exists
echo ERROR: %~1 *%x%* already exists
set x=""
goto Ask1
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
echo %~1:	%xMeta%>> %descFile%
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
::          --- %~3 (optional) missing: no typed input required
::                             * : can be skipped, return *
::                             ! : typed input required
:: Example: call:inputMeta "Type something" xx default
SETLOCAL
rem call:getInput "%~1" xMeta "%~3"
rem Type input or get menu?

call:getInput "%~1" xMeta "%~3"
echo %~1:	%xMeta%>> %descFile%
rem call:writeAnalytes %analytesInput% "%~1" %xMeta% 
rem

    set "spaces=                                           "
    set "line=%~1:%spaces%"
    set "line=%line:~0,35%%~4%xMeta%"
rem
(ENDLOCAL
    IF "%~2" NEQ "" set "%~2=%xMeta%"
    set "aEntered=%xMeta%"
    set "hd=%hd%%line%/"
    rem set "hd=%hd%%~1:		 %xMeta%/"

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
rem echo %mn%
rem echo. 
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
    for /F "tokens=%errorlevel% delims=/" %%H in ("%_mn%") DO set "%~3=%%H"
)
GOTO:EOF
rem -----------------------------------------------------
:putMeta2   --- get metadata and append to descFile
::          --- descFile - should be set befor the call
::          --- %~1 Input message (what to enter)
::          --- %~2 Variable to get result
::          --- %~3 (optional) missing: no typed input required
::                             * : can be skipped, return *
::                             ! : typed input required
::          --- %~4 optional prefix; some values have to be prefixed by SampleID
::                  XIDX will be replaced by SampleID upon writing to file
:: Example: call:putMeta2 "Type something" xx default
rem SETLOCAL
rem FIX: allow text input of empty string
if "%~3"=="*" call:getInput "%~1" xMeta "%~3" & GOTO:next
if "%~3"==""  call:getInput "%~1" xMeta "%~3" & GOTO:next
if "%~3"==" " call:getInput "%~1" xMeta "%~3" & GOTO:next
if /I "%~3"=="Blank" set xMeta="" & GOTO:next
rem call:getInput "%~1" xMeta "%~3"
rem echo.=%~3= rem test
call:getMenu "%~1" "%~3/Other" xMeta "%~3"
set first="."
for /f "tokens=1 delims=/" %%a in ("%~3") do set first=%%a
rem echo =%~3=%first%= REM test
if "%xMeta%"=="Other" call:getInput "%~1" xMeta "%first%"
:next
if /I "%~3" NEQ "Blank" echo %~1:	%xMeta%%prefix%>> %descFile%
rem call:writeAnalytes %analytesInput% "%~1" %xMeta% 
rem
REM (ENDLOCAL
set "%~2=%xMeta%"
set pf=
if "%~4" NEQ ""  set pf=%postfix%
set "line1=%line1%	%~1"
set "line2=%line2%	%~4%xMeta%%pf%"
endlocal
rem echo tst line1 %line1%
rem echo tst line2 %line2%
rem pause
set "spaces=                                 "
set "line=%~1%spaces%"
set "line=%line:~0,35%%~4%xMeta%"
rem if /I "%~3" NEQ "Blank" set "hd=%hd%%~1:		 %~4%xMeta%/"
if /I "%~3" NEQ "Blank" set "hd=%hd%%line%/"
if /I "%~3" NEQ "Blank" call:displayhd "%hd%"
REM )
GOTO:EOF
rem ---------------------------------------------------
:writeAnalytes  --- write colums to analyte file
::              --- %~1 file to process
::              --- %~2 string for the first line
::              --- %~3 string for other lines
SETLOCAL
rem IF EXIST %~1 (

    rem First line
    set /p z= <%~1
    set x2=%~2
    rem uncoment next line to remove blanks in the header line
    rem set x2=%x2: =%
    rem TAB inserted automatically
    echo %z%%x2%  > tmp.txt
    rem Process other lines
    rem Replace $ with sample id from the first field
    rem set "SEARCHTEXT=XIDX"
    set "SEARCHTEXT=$"
    set "line=%~3"
    for /f "skip=1 tokens=1,* delims=	 " %%a in (%~1) do (
    rem echo on
    set "TAB=	"
      	rem echo %%a
      	rem echo %%b
      	rem echo %~3
      	setlocal enabledelayedexpansion
      rem	set "line=!line:%search%=%replace%!"
      SET "modified=!line:%SEARCHTEXT%=%%a!"
      rem echo %searchtext% %modified%
      rem pause
      rem should replace special token with SampleId before writing
       echo %%a	%%b!modified!>> tmp.txt 
       rem echo Write: %%a	%%b!modified!
       endlocal
       rem echo off
       )
    copy tmp.txt %~1 >NUL
rem )
ENDLOCAL
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
rem --------------------------------------------------
:getDirNames  --- get directory names and prepare / delimited list
::            --- %~1 directory
::            --- %~2 Variable to get result
:: Return:    >>> list of directories DRY/WET/XXX
:: Example: call:getDirNames ..\main\Templates
SETLOCAL ENABLEDELAYEDEXPANSION
echo "Reading from file: %~1"
SET "files="
FOR /f "delims=" %%i IN ('dir %~1 /b') DO (
     SET "files=!files!%%i/"
)
(ENDLOCAL
SET %~2="%files%"
SET %~2=%files:~0,-1%
)
GOTO:EOF
REM ----------------------------------------------------------
:processAnalytes  --- read AssayType.ini and loop through lines
::                --- %~1 file path
::                --- %~2 Variable to get result
:: Return:    >>> 
:: Example: call:processAnalytes %tmpldir%\%IDClass%\%IDType%\AssayType.ini"
rem first id is prefixed. will be reset to empty after the first line
set postfix=_%IDName%
set "lfn=%~1"
if %lfn%=="" set "lfn=%tmpldir%\%IDClass%\%IDType%\AssayType.ini"
SETLOCAL EnableDelayedExpansion
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %lfn%"`) do (
    call :processLine "%%a"
    )
 rem no spaces in item names
 set "line1=%line1: =_%"
 rem echo tst processAnalytes: line1 %line1%
 rem echo tst processAnalytes: line2 %line2%
 rem echo tst %analytesInput%
 rem pause
if exist "%analytesInput%" (
call:writeAnalytes %analytesInput% "%line1%" "%line2%" )
goto :eof
rem ------------------------------------------------------------
:processLine  --- compose metadata menu for a line
::            --- %~1 line from AssayType.ini template (two tab delimited strings)
::
:: Example: call:processLine "Descriptor	Option1/Option2"
SET "string=%~1"
REM the line starts with "nn:" - cut off the numbers and colon
set "string=%string:*:=%
REM parse Item/Value line (separetor is TAB) - do not forget to use "..."
set s1=
set s2=
for /f "tokens=1 delims=	" %%a in ("%string%") do set s1=%%a
for /f "tokens=2 delims=	" %%a in ("%string%") do set s2=%%a
for /f "tokens=1 delims=	" %%a in ("%string%") do set s1=%%a
for /f "tokens=2 delims=	" %%a in ("%string%") do set s2=%%a
REM ask for input
rem ECHO call:putMeta2 "%s1%" xxx %s2%
call:putMeta2 "%s1%" xxx "%s2%"
goto :eof

REM ----------------------------------------------------------
:processLine2  --- compose metadata menu for a line
::            --- %~1 line from AssayType.ini template (two tab delimited strings)
::
:: Example: call:processLine "Descriptor	Option1/Option2"
SETLOCAL enabledelayedexpansion
SET "string=!%~1!"
rem remove number: added by findstr - not working
rem echo set "string=%!string!:*:=%"
rem set "string=%!%~1!:*:=%"
SET "s2=%string:*	=%"
set "s1=!string:	%s2%=!"
ECHO +%s1%+%s2%+
rem ENDLOCAL
ECHO call:putMeta2 "%s1%" xxx %s2%
call:putMeta2 "%s1%" xxx %s2%
rem ENDLOCAL
goto :eof
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
   set "%~2=%_result%")
   rem echo %iname%
   endlocal
goto :eof
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
    for /f tokens^=2^ delims^=^<^>^:^.^,^(^)^[^]^"^/^\^|^?^*^ eol^= %%y in ("[!my_file!]") do (
        rem If we are here there is a second token, so, there is a special character
        echo. Error : Non allowed characters in ID
        endlocal & goto :askFile
    )

    rem Check MAX_PATH (260) limitation
    set "my_temp_file=!cd!\!my_file!" & if not "!my_temp_file:~260!"=="" (
        echo. Error : ID name too long
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
            echo. Error : Paths are not allowed
            goto :askFile
        )

        rem Check it is not a folder 
        if exist "%%~nxa\" (
            echo. Error : Folder with same name present 
            goto :askFile
        )

        rem ASCII 0-31 check. Check file name can be created
        2>nul ( >>"%%~nxa" type nul ) || (
            echo. Error : File name is not valid for this file system
            goto :askFile
        )

        rem Ensure it was not a special file name by trying to delete the newly created file
        2>nul ( del /q /f /a "%%~nxa" ) || (
            echo. Error : Reserved file name used
            goto :askFile
        )

        rem Everything was OK - We have a file name 
        set "my_file=%%~nxa"
    )

    rem echo Selected file is "%my_file%"
    (endlocal 
     set "%~2=%my_file%")
goto :eof
rem ----------------------------------------------------------
:getSamples --- get sample names from %pfn%
::          --- %~1 column name
::          --- %~2 phenodata file name (default is "%iroot%/%pfn%")
::          --- %~3 output file (default is "%sroot%/Analytes.txt")
:: Return: writes the sample names (first two columns) to the output file
:: Example: call:getSamples %Assay_ID%
::
set "infile="
set "outfile="
if "%~2" NEQ "" (set "infile=%~2") else (set "infile=%iroot%/%pfn%")
if "%~3" NEQ "" (set "outfile=%~3") else (set "outfile=%sroot%/Analytes.txt")
:: dir %infile%
:: First line
set /P line1=<%infile%
:: echo - %line1%
setlocal enabledelayedexpansion
call:strfind %~1 "%line1%" where
:: echo -- %where%
:: echo ---- end
if %where% NEQ 0 (
if exist %outfile% del %outfile%
:: Process other lines
rem for /f "skip=1 tokens=1,2 delims=	 " %%a in (%infile%) do (
rem echo + %%a	%%b	%%c	%%d	%e
rem )
rem https://www.dostips.com/forum/viewtopic.php?t=3599
setlocal DisableDelayedExpansion
for /f "EOL=: delims=" %%L in (%infile%) do (
  set "line=%%L"
  setlocal EnableDelayedExpansion
  rem set "preparedLine=#!line:;=;#!"
  set "preparedLine=#!line:	=;#!"
  rem get first two and 'assayID' tokens
  FOR /F "tokens=1-2,%where% delims=;" %%c in ("!preparedLine!") DO (
    endlocal
    set "param1=%%c"
    set "param2=%%d"
    set "param3=%%e"
    setlocal EnableDelayedExpansion
    set "param1=!param1:~1!"
    set "param2=!param2:~1!"
    set "param3=!param3:~1!"
    rem echo $1=!param1! $2=*!param2!* $3=*!param3!*
    if "!param3!" NEQ "" echo !param1!	!param2!	!param3!>> %outfile%
    endlocal
  )
)
) 
rem else (echo No column %~1 in: & echo %line1%)
setlocal disabledelayedexpansion
goto:eof
rem ------------------------------------------------------------
:strfind    --- locate the first occurence of a string in a tab-separated set of strings
::          --- %~1 string to find/locate
::          --- %~2 longer tab separated set of strings
::          --- %~3 variable to get result
::
:: Return: index if found, 0 if not found
:: Example: call:strfind ble "bla	ble	blu" where (returns 2)
set "TAB=	"
set "what=%~1"
set "strings=%~2"
set what=%what: =.%
set strings=%strings: =.%
:: echo / %strings%
set pos=0
set found=0
for %%i in (%strings%) do (
  if !found!==0 set /a "pos=!pos!+1"
  :: echo //!pos! !found! %%i !what!
  if %%i==%what% set found=1 & goto:found
)
:found
(if %found% == 1 (
    :: echo /// %what% Found on position: %pos%
    set "%~3=%pos%") else (
    :: echo /// %what% not found
    set "%~3=0" )

)
goto:eof
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
SETLOCAL EnableDelayedExpansion
For /F "TOKENS=1-2 delims=	" %%A In (%~1) do (
    call:showTwoCol "%%A" "%%B"
    )
endlocal
goto :EOF
rem -------------------------------------------------------------------
:showTwoCol --- show one line
::			--- %~1 first column
::			--- %~2 second column
::
:: Example: call:showTwoCol "Item name" "Item value"
::
	set "_sp=                                         "
    set "iname=%~1%_sp%"
    set "iname=%iname:~0,35%"
    echo %iname% %~2
goto:eof
REM ----------------------------------------------------------
:processMeta  --- read meta ini file and loop through lines
::                --- %~1 file path
::                --- %~2 Variable to get result
:: Return:    >>> 
:: Example: call:processMeta %tmpldir%\%IDClass%\%IDType%\AssayType.ini"
rem first id is prefixed. will be reset to empty after the first line
echo off
call:normalizeDate today -
set "lfn=%~1"
if %lfn%=="" echo Nothing to process
SETLOCAL EnableDelayedExpansion
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %lfn%"`) do (
    call :processLine "%%a"
    )
echo off
goto :eof