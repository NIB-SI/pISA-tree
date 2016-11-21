rem copy files down the tree
rem 
where /R . makeAssay.bat > src.tmp
For /F "tokens=1*" %%a in (src.tmp) do copy /y makeAssay.bat %%a
rem for /r "." %%a in (where /R . makeAssay.bat) do echo "%%a"