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
set /p ID=Enter Investigation ID: 
rem echo %ID%
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
set iroot=%cd%
set "proot=.."
set "mroot=..\%proot%"
call:getLayer _p_ pname
md presentations
md reports
rem put something to the directories
rem to force git to add them
echo # Investigation %ID% >  .\README.MD
echo # Reports for investigation %ID% >  .\reports\README.MD
echo # Presentations for investigation %ID% >  .\presentations\README.MD
echo # Describe samples > .\phenodata.txt
echo # Feature Summary Table> .\FST.txt
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
echo project:	%pname%> %descFile%
echo Investigation:	%iname%>> %descFile%
echo ### INVESTIGATION>> %descFile%
echo Short Name:	%ID%>> %descFile%
  call:inputMeta "Title" aTitle *
  call:inputMeta "Description" aDesc *
copy %descFile%+..\common.ini %descFile%
copy ..\common.ini .
rem copy bla.tmp %descFile%
echo Phenodata:	./data/phenodata.txt>> %descFile%
echo Featuredata:	./data/featuredata.txt>> %descFile%
echo #### STUDIES!LF!>>  %descFile%
echo INVESTIGATION:	%ID%>> ..\_PROJECT_METADATA.TXT

rem
rem  make main readme.md file
copy %mroot%\makeStudy.bat .
copy %proot%\showTree.bat .
copy %proot%\showMetadata.bat .
copy %proot%\xcheckMetadata.bat .

type README.MD
del *.tmp
dir.
type %descFile%
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
echo %~1:	%xMeta% >> %descFile%
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
   set "%~2=%_result%")
   rem echo %iname%
   endlocal
goto :eof
REM ------------------------------------------------------
:hexPrint  string  [rtnVar]
  for /f eol^=^%LF%%LF%^ delims^= %%A in (
    'forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(%~1"'
  ) do if "%~2" neq "" (set %~2=%%A) else echo(%%A
GOTO:EOF
