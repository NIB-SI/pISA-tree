@echo off
rem -------------------------------------  pISA-tree v.0.4.2
rem
rem Create a new Study tree _S_xxxx in current directory
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
call:getLayer _I_ iname
rem Check Investigation existence
if x%iname::=%==x%iname% goto iok
echo.
echo ERROR: Make Investigation first!
echo.
pause
goto:eof
:iok
rem Investigation already created
set descFile=".\_STUDY_METADATA.TXT"
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
set /p ID=Enter Study ID: 
rem echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" set /p ID=Enter Study ID: 
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST %ID% (
REM Dir exists
echo ERROR: Study named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
echo %ID%
)
rem ----------------------------------------------
rem Make new Study directory tree
set Sdir=_S_%ID%
md %Sdir%
cd %Sdir%
set sroot=%cd%
set "iroot=.."
set "proot=..\%iroot%"
set "mroot=..\%proot%"

md reports
rem put something to the directories
rem to force git to add them
echo # Study %ID% >  .\README.MD
echo # Reports for study %ID% >  .\reports\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
rem -----------------------------------------------
call:getLayer _p_ pname
call:getLayer _I_ iname
call:getLayer _S_ sname
rem -----------------------------------------------
echo project:	%pname%> %descFile%
echo Investigation:	%iname%>> %descFile%
echo Study:	%sname%>> %descFile%
echo ### STUDY>> %descFile%
echo Short Name:	%ID%>> %descFile%
  call:inputMeta "Title" aTitle *
  call:inputMeta "Description" aDesc *
copy %descFile%+..\common.ini %descFile%
copy ..\common.ini .
echo Fitobase link:	>> %descFile%
echo Raw Data:	>> %descFile%
echo #### ASSAYS>>  %descFile%
echo STUDY:	%ID%>> ..\_INVESTIGATION_METADATA.TXT
rem 
rem  make main readme.md file
copy %mroot%\makeAssay.bat .
copy %iroot%\showTree.bat .
copy %iroot%\showMetadata.bat .
copy %iroot%\xcheckMetadata.bat .
rem Make test Analytes file
echo Sample ID	Field1	Field2> Analytes.txt
echo SMPL001	A1	B1>> Analytes.txt
echo SMPL002	A2	B2>> Analytes.txt
echo SMPL003	A3	B3>> Analytes.txt
rem End Analytes.txt
type README.MD
del *.tmp
dir .
type %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
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
