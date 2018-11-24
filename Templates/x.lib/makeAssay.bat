@ECHO OFF
rem call pISA routine refered by file name
call ..\..\..\Templates\x.lib\lib.cmd :pISA %~n0 %1 %2 %3 %4
goto:EOF