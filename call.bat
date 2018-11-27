::@ECHO OFF
rem find root directory and call pISA routine refered by the file name
for %%G in (..\..\..\..,..\..\..,..\..,..,.) do if exist %%G\Templates set root=%%G && goto:next
:next
echo %root%
pause
::call %root%\Templates\x.lib\lib.cmd :pISA %~n0 %1 %2 %3 %4
goto:EOF