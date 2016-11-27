rem echo off
rem Ask for study ID, loop if empty
call:getInput "Study ID" ID *
echo Input was: %ID%
call:getInput "Assay ID" ID default
echo Input was: %ID%
call:getInput "Assay ID" ID
echo Input was: "%ID%"
set descFile="./bla.txt"
call:putMeta "Assay Title" "*"



echo.&pause&goto:eof
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
if "%x%" EQU * goto done
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
:putMeta   --- get metadata and append to descFile
::         --- descFile - should be set befor the call
::          --- %~1 Input message (what o type
::          --- %~2 (optional) missing: input required
::          ---                * : can be skipped, return *
:: Example: call:putMeta "Type something" xx default
SETLOCAL
call:getInput "%~1" xMeta "%~2"
echo "%~1" --- %xMeta% >> %descFile%
ENDLOCAL
GOTO:EOF