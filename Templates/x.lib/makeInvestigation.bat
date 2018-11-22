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
rem ----------- init directories
set descFile=".\_INVESTIGATION_METADATA.TXT"
set "proot=%cd%"
set "pISAroot=%proot%\.."
set "mroot=%proot%\.."
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
rem -----------
call %libdir%\lib.cmd :getLayer _p_ pname
rem Check project existence
if x%pname::=%==x%pname% goto pok
echo.
echo ERROR: Make project first!
echo.
pause
goto:eof
:pok
rem project already created
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
call %libdir%\lib.cmd :askFile "Enter Investigation ID: " ID
rem echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call %libdir%\lib.cmd :askFile "Enter Investigation ID: " ID
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

call %libdir%\lib.cmd :getLayer _p_ pname
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
call %libdir%\lib.cmd :getLayer _p_ pname
call %libdir%\lib.cmd :getLayer _I_ iname
REM -----------------------------------------------
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!INVESTIGATION	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_METADATA.TXT
echo Investigation:	%iname%> %descFile%
echo Short Name:	%ID%>> %descFile%
  call %libdir%\lib.cmd :inputMeta "Title" aTitle *
  call %libdir%\lib.cmd :inputMeta "Description" aDesc *
rem echo Investigation Path:	%cd:\=/%>> %descFile%
rem copy bla.tmp %descFile%
rem create phenodata file name
call %libdir%\lib.cmd :normalizeDate danes
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
rem process level specific items
 call %libdir%\lib.cmd :processMeta %proot%\meta_i.ini
 copy %libdir%\meta_S.ini %iroot%
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo      Investigation METADATA
echo ======================================
call %libdir%\lib.cmd :showDesc %descFile%
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
