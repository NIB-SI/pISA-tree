@ECHO OFF
pushd %~dp0
rem find root directory and call pISA routine refered by the file name
for %%G in (.,..,..\..,..\..\..,..\..\..\..) do if exist %%G\Templates\x.lib\pISA.cmd set "root=%%G" && goto:next
:next
call %root%\Templates\x.lib\pISA.cmd :pISA %~n0 %1 %2 %3 %4
pause
goto:EOF