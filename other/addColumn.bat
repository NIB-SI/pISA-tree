@echo off
set mydate=%date:~13,4%/%date:~9,2%/%date:~5,2%
echo %mydate%
set analytesInput=Analytes.txt
set analytesOutput=analytesdata.txt
set /p z=<%analytesInput%
set x3=X 3 1
rem set str=%str: =%
echo %z%	%x3: =%	X4  > %analytesOutput%
for /f "skip=1 tokens=*" %%a in (%analytesInput%) do (
  echo %%a	%mydate%	second >> %analytesOutput%
)
type %analytesOutput%
pause