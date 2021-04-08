REM XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
REM X DANGEROUS ZONE::: DO NOT CHANGE ANYTHING IN THIS FILE X
REM XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
@echo off
rem get parameters
call %*
goto :EOF
rem pISA makeLayer batch files packed into the library
:pISA
@echo off
set "$ver=pISA-tree v.3.0.1"
set "$analini=Analytes_Template.txt"
set "$metaTypeini=meta_AType_Template.txt"
rem first argument defines where to go (calling batch file name)
call :%1 %2 %3 %4
goto:EOF
rem
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
rem ---------- core make-p-I-S-A routines -----------------
rem 
:makeProject
rem
rem Create a new project tree _p_xxx in current directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if the folder exists
rem robocopy %ID% X-%ID% /MIR
rem ------------------------------------------------------
TITLE %$ver%
set     hd=======================================/
set hd=%hd%      pISA-tree: make PROJECT/
set hd=%hd%--------------------------------------/
call :displayhd "%hd%"
echo Location: %cd%
echo.
rem ----------- init directories
set descFile=".\_PROJECT_METADATA.TXT"
set pISAroot=%cd%
set mroot=%cd%
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
rem -----------
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
call :askFile "Enter project ID: " ID
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call :askFile "Enter project ID: " ID
if %ID% EQU "" goto Ask
IF EXIST _p_%ID% (
REM Dir exists
echo ERROR: project named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
rem echo Creating project %ID%
)
rem ----------------------------------------------
rem Make new project directory tree
rem set project root
rem set PPath=:getparentdir %cd%
rem set \ to /
rem set "PPath=!PPath:\=/!"
rem echo %PPath%
rem
set pdir=_p_%ID%
md %pdir%
cd %pdir%
rem echo %cd%
set proot=%cd%
md presentations
md reports
rem put something to the directories
rem to force git to add them
REM
echo # Project %ID%>  .\README.MD
echo # Reports for project %ID%>  .\reports\README.MD
echo # Presentations for project %ID%>  .\presentations\README.MD
echo # Feature Summary Table> .\FST.txt
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
::Create a TAB variable
REM not really needed
rem call :hexprint "0x09" TAB
rem -----------------------------------------------
call :getLayer _p_ pname
set hd=%hd%project:                           %pname:~3%/
REM -----------------------------------------------
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!PROJECT	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_METADATA.TXT
echo project:	%pname%> %descFile%
echo Short Name:	%ID%>> %descFile%
  call :inputMeta "Title" aTitle *
  call :inputMeta "Description" aDesc *
echo pISA projects path:	%pISAroot:\=/%>> %descFile%
rem copy bla.tmp %descFile%
rem
rem  make main readme.md file
copy %libdir%\call.bat .\makeInvestigation.bat >NUL
copy %mroot%\showTree.bat . > NUL
copy %mroot%\showMetadata.bat . > NUL
copy %mroot%\xcheckMetadata.bat . > NUL
rem del *.tmp > NUL
rem process level specific items
call :processMeta %mroot%\meta_p_Template.txt
copy %tmpldir%\meta_I_Template.txt %proot%
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo      project METADATA
echo ======================================
call :showDesc %descFile%
cd..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
rem pause
echo.
echo ============================== pISA ==
echo.
echo project %ID% is ready.
echo Location: %cd%\%pname%
echo.
echo ======================================
rem PAUSE
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:makeInvestigation
rem ---------------------------------- make Investigation
@echo off
rem -------------------------------------  pISA-tree %$ver%
rem
rem Create a new Investigation tree _I_xxx in current directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016-
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if the folder exists
rem robocopy %ID% X-%ID% /MIR
rem ------------------------------------------------------
TITLE %$ver%
set     hd=======================================/
set hd=%hd%      pISA-tree: make INVESTIGATION/
set hd=%hd%--------------------------------------/
call :displayhd "%hd%"
echo Location: %cd%
echo.
rem ----------- init directories
set descFile=".\_INVESTIGATION_METADATA.TXT"
set "proot=%cd%"
set "pISAroot=%proot%\.."
set "mroot=%proot%\.."
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
call :normalizedate today -
rem -----------
call :getLayer _p_ pname
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
call :askFile "Enter Investigation ID: " ID
rem echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call :askFile "Enter Investigation ID: " ID
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST _I_%ID% (
REM Dir exists
echo ERROR: Investigation named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
rem echo %ID%
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
rem echo %cd%
set iroot=%cd%

call :getLayer _p_ pname
md presentations
md reports
rem put something to the directories
rem to force git to add them
echo # Investigation %ID%>  .\README.MD
echo # Reports for investigation %ID%>  .\reports\README.MD
echo # Presentations for investigation %ID%>  .\presentations\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
::Create a TAB variable (not realy needed)
REM Throws an error??
REM call :hexprint "0x09" TAB
rem -----------------------------------------------
call :getLayer _p_ pname
call :getLayer _I_ iname
set hd=%hd%Investigation:                     %iname:~3%/
set hd=%hd%project:                           %pname:~3%/
REM -----------------------------------------------
REM echo SHORT NAME	!LF!DESCRIPTION	 !LF!INVESTIGATOR	!LF!INVESTIGATION	!LF!FITOBASE LINK	!LF!RAW DATA	!LF!> .\_experiments\_EXPERIMENT_METADATA.TXT
echo Investigation:	%iname%> %descFile%
echo Short Name:	%ID%>> %descFile%
  call :inputMeta "Title" aTitle *
  call :inputMeta "Description" aDesc *
rem echo Investigation Path:	%cd:\=/%>> %descFile%
rem copy bla.tmp %descFile%
rem create phenodata file name
call :normalizeDate danes
set pfn=phenodata_%danes%.txt
if exist %pfn% (
	echo Phenodata %pfn% already exists: will not overwrite it
	) else (
	rem Make test phenodata file
	echo Phenodata:	./%pfn%>> %descFile%
	echo SampleID	SampleName	Date_of_change	AdditionalField1	_A_Assay001-RNAisol> %pfn%
	echo SMPL001	Sample_001	%today%	B1	x>> %pfn%
	echo SMPL002	Sample_002	%today%	B2	>> %pfn%
	echo SMPL003	Sample_003	%today%	B3	x>> %pfn%
	echo SMPL004	Sample_004	%today%	B4	>> %pfn%
rem End test %pfn%
)
rem echo INVESTIGATION:	%ID%>> ..\_PROJECT_METADATA.TXT

rem
rem  make main readme.md file
copy %libdir%\call.bat .\makeStudy.bat > NUL
copy %proot%\showTree.bat . > NUL
copy %proot%\showMetadata.bat . > NUL
copy %proot%\xcheckMetadata.bat . > NUL
rem process level specific items
 call :processMeta %proot%\meta_I_Template.txt
 copy %tmpldir%\meta_S_Template.txt %iroot%
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo      Investigation METADATA
echo ======================================
call :showDesc %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
rem pause
echo.
echo ============================== pISA ==
echo.
echo Investigation %ID% is ready.
echo Location: %cd%\%iname%
echo.
echo ======================================
rem PAUSE
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:makeStudy
@echo off
rem -------------------------------------  %$ver%
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
TITLE %$ver%
set     hd=======================================/
set hd=%hd%      pISA-tree: make STUDY/
set hd=%hd%--------------------------------------/
call :displayhd "%hd%"
echo Location: %cd%
echo.
rem ----------- init directories
set descFile=".\_STUDY_METADATA.TXT"
set "iroot=%cd%"
set "pISAroot=%iroot%\..\.."
set "mroot=%iroot%\..\.."
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
rem -----------
call :getLayer _I_ iname
rem Check Investigation existence
if x%iname::=%==x%iname% goto iok
echo.
echo ERROR: Make Investigation first!
echo.
pause
goto:eof
:iok
rem Investigation already created
rem Ask for study ID, loop if empty
set ID=""
if "%1" EQU "" (
rem echo @
call :askFile "Enter Study ID: " ID
rem echo %ID%
) else (
set ID=%1
)
:Ask
if %ID% EQU "" call :askFile "Enter Study ID: " ID
if %ID% EQU "" goto Ask
REM Check existence/uniqueness
IF EXIST _S_%ID% (
REM Dir exists
echo ERROR: Study named *%ID%* already exists
set ID=""
goto Ask
) ELSE (
REM Continue creating directory
rem echo %ID%
)
rem ----------------------------------------------
rem Make new Study directory tree
set Sdir=_S_%ID%
md %Sdir%
cd %Sdir%
rem echo %cd%
set sroot=%cd%
set "iroot=.."
set "proot=%iroot%\.."
set "mroot=%proot%\.."
md reports
rem put something to the directories
rem to force git to add them
echo # Study %ID%>  .\README.MD
echo # Reports for study %ID%>  .\reports\README.MD
rem
setlocal EnableDelayedExpansion
set LF=^


REM Two empty lines are necessary
rem -----------------------------------------------
call :getLayer _p_ pname
call :getLayer _I_ iname
call :getLayer _S_ sname
set hd=%hd%Study:                             %sname:~3%/
set hd=%hd%Investigation:                     %iname:~3%/
rem -----------------------------------------------
echo Study:	%sname%> %descFile%
echo Short Name:	%ID%>> %descFile%
  call :inputMeta "Title" aTitle *
  call :inputMeta "Description" aDesc *
rem echo Study Path:	%cd:\=/%>> %descFile%
echo Raw Data:	>> %descFile%
rem echo #### ASSAYS>>  %descFile%
rem echo STUDY:	%ID%>> ..\_INVESTIGATION_METADATA.TXT
rem 
rem  make main readme.md file
copy %libdir%\call.bat .\makeAssay.bat > NUL
copy %iroot%\showTree.bat . > NUL
copy %iroot%\showMetadata.bat . > NUL
copy %iroot%\xcheckMetadata.bat . > NUL
REM
rem process level specific items
 call :processMeta %iroot%\meta_S_Template.txt
 copy %tmpldir%\meta_A_Template.txt %sroot%
rem append common.ini
copy %descFile%+..\common.ini %descFile% /b> NUL
copy ..\common.ini . /b > NUL
rem Display metadata
cls
echo ======================================
echo      Study METADATA
echo ======================================
call :showDesc %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
echo.
echo ============================== pISA ==
echo.
echo Study %ID% is ready.
echo Location: %cd%\%sname%
echo.
echo ======================================
rem PAUSE
goto:eof

rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:makeAssay
@echo off
rem -------------------------------------  pISA-tree %$ver%
rem
rem Create a new Assay tree _A_xxx in the current study directory
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem cd d:\_X
rem Backup copy if assay folder exists
rem robocopy %1 X-%1 /MIR
rem ------------------------------------------------------
rem
TITLE %$ver%
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
set "TAB=	"
set     hd=======================================/
set hd=%hd%      pISA-tree: make ASSAY/
set hd=%hd%--------------------------------------/
call :displayhd "%hd%"
echo Location: %cd%
echo.
rem ----------- init directories
set descFile=".\_ASSAY_METADATA.TXT"
set "sroot=%cd%"
set "pISAroot=%sroot%\..\..\.."
set "mroot=%sroot%\..\..\.."
set "tmpldir=%mroot%\Templates"
set "libdir=%tmpldir%\x.lib"
set "batdir=%libdir%"
rem -----------
call :getLayer _S_ sname
rem Check Study existence
if x%sname::=%==x%sname% goto sok
echo.
echo ERROR: Make Study first!
echo.
pause
goto:eof
:sok
rem Study already created
call :displayhd "%hd%"
echo Location: %cd%
echo.
set sroot=%cd%
set "iroot=.."
set "proot=..\%iroot%"
set "mroot=..\%proot%"
rem dir %tmpldir%
rem pause
rem ----------------------------------------------
rem Class: use argument 1 if present
rem set today=%date:~13,4%-%date:~9,2%-%date:~5,2%
call :normalizeDate today -
rem set IDClass=
rem if "%1" EQU "" (
rem echo @
rem set /p IDClass=Enter Assay Class [ Wet/Dry ]: 
rem ) else (
rem set IDClass=%1
rem )
rem ---------------------------------------------
rem Ask for Class, loop if empty
:Ask1
rem if %IDClass% EQU "" set /p IDClass=Enter Assay Class [ Wet/Dry ]: 
rem if %IDClass% EQU "" goto Ask1
rem /I: case insensitive compare
rem if /I %IDClass% EQU dry (set IDClass=Dry)
rem if /I %IDClass% EQU d set IDClass=Dry
rem if /I %IDClass% EQU wet set IDClass=Wet
rem if /I %IDClass% EQU w set IDClass=Wet
SETLOCAL ENABLEDELAYEDEXPANSION
rem Supported classes
SET "types="
FOR /f "delims=" %%i IN ('dir %tmpldir%\*. /AD/B') DO (
    SET types=!types!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
if "%1" EQU "" (
 set "IdClass="
 call :getMenu "Select Assay Class" %types% IDClass ) else (
 set "IdClass=%1"
)
set "hd=%hd%Assay Class:		 %~4%IDClass%/"
call :displayhd "%hd%"
echo Selected: %IDClass%
rem ----------------------------------------------
rem Supported types
rem if /I %IDClass% EQU Wet set "types=NGS / RT"
rem if /I %IDClass% EQU Dry set "types=R / Stat"
SETLOCAL ENABLEDELAYEDEXPANSION
SET "types="
FOR /f "delims=" %%i IN ('dir %tmpldir%\%IDClass% /AD/B') DO (
    SET types=!types!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
if "%2" EQU "" (
set "IDType="
rem echo %tmpldir%\%IDClass%
call :getMenu "Select Assay Type" "%types%Other" IDType ) else (
set "IDType=%2"
)
rem process Other type
if %IDType% EQU Other (
rem Create new assay type if needed
echo:
set "NewType=""
:Ask4
if %NewType%* EQU * call :askFile "Enter new Assay Type ID: " NewType 
if %NewType%* EQU * goto Ask4
rem check type existence/uniqueness
if exist %tmpldir%\%IDClass%\%NewType% ( 
  echo.
  echo. ERROR: %IDClass% assay type %NewType% already exists
  echo.
  set "NewType=" 
  goto Ask4)
rem type ok
md %tmpldir%\%IDClass%\%NewType%
echo #Key name	Key value>   %tmpldir%\%IDClass%\%NewType%\%$metaTypeini%
echo #Creation date	%today%>> %tmpldir%\%IDClass%\%NewType%\%$metaTypeini%
echo New %IDClass% Assay Type was created: %NewType%
set "IDType=%NewType%"
)
rem Other finished
set "hd=%hd%Assay Type:		 %~4%IDType%/"
call :displayhd "%hd%"
rem echo Selected: %IDType%
rem ----------------------------------------------
rem Type: use argument 2 if present
rem set IDType=""
rem if "%2" EQU "" (
rem set /p IDType=Enter Assay Type [ %types% ]: 
rem ) else (
rem set IDType=%2
rem )
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask2
rem if %IDType% EQU "" set /p IDType=Enter Assay Type [ %types% ]: 
rem if %IDType% EQU "" goto Ask2
rem ----------------------------------------------
rem ID : use argument 3 if present
set IDName=""
if "%3" EQU "" (
call :askFile "Enter Assay ID: " IDName 
) else (
set IDName=%3
)
rem dir %IDType%* /B /AD
rem Similar Assay IDs
rem %IDType%* /AD
:Ask3
if %IDName% EQU "" call :askFile "Enter Assay ID: " IDName 
if %IDName% EQU "" goto Ask3
rem ----------------------------------------------
rem concatenate ID name
set ID=%IDName%-%IDType%
echo %ID%
rem ----------------------------------------------
rem Check existence
IF EXIST _A_%ID% (
REM Dir exists
echo ERROR: Assay named *%ID%* already exists
rem set IDType=""
rem set IDClass=""
set IDName=""
set ID=""
goto Ask3
) ELSE (
REM Continue creating directory
)
set "hd=%hd%Assay ID:		 %~4%ID%/"
call :displayhd "%hd%"
set Adir=_A_%ID%
md %Adir%
cd %Adir%
set aroot=%cd%
set "sroot=.."
set "iroot=%sroot%\.."
set "proot=%iroot%\.."
set "mroot=%proot%\.."
goto %IDClass%
rem ----------------------------------------------
rem Make new assay directory tree
rem ----------------------------------------------
:dry
REM set IDClass=Dry
md input
md reports
md scripts
md output
md other
rem put something in to force git to add new directories
echo # Assay %ID%>  .\README.MD
echo # Input for assay %ID%>  .\input\README.MD
echo # Reports for assay %ID%>  .\reports\README.MD
echo # Scripts for assay %ID%>  .\scripts\README.MD
echo # Output of assay %ID%>  .\output\README.MD
echo # Other files for assay %ID%>  .\other\README.MD
goto Forall
rem ----------------------------------------------
:wet
REM set IDClass=Wet
md reports
md output
cd output
md raw
cd ..
md other
rem put something in to force git to add new directories
echo # Assay %ID%>  .\README.MD
echo # Reports for assay %ID%>  .\reports\README.MD
echo # Output of assay %ID%>  .\output\README.MD
echo # Raw output of assay %ID%>  .\output\raw\README.MD
echo # Other files for assay %ID%>  .\other\README.MD
goto Forall
rem ----------------------------------------------
:Forall
rem
rem echo %cd%
setlocal EnableDelayedExpansion
set LF=^


REM Keep two empty lines above - they are neccessary!!
set "TAB=	"
rem -----------------------------------------------
call :getLayer _p_ pname
call :getLayer _I_ iname
call :getLayer _S_ sname
call :getLayer _A_ aname
set hd=%hd%Study:                             %sname:~3%/
rem set hd=%hd%Assay:                             %aname:~3%/
rem -------------------------------------- make ASSAY_METADATA
echo Assay:	%Adir%> %descFile%
echo Short Name:	%ID%>> %descFile%
echo Assay Class:	%IDClass%>> %descFile%
echo Assay Type:	%IDType%>> %descFile%
rem ECHO ON
  rem set analytesInput=Analytes.txt
  rem if exist ../%analytesInput% ( copy ../%analytesInput% ./%analytesInput% )
  call :inputMeta "Title" aTitle *
  call :inputMeta "Description" aDesc *
rem echo Assay Path:	%cd:\=/%>> %descFile%
rem set phenodata file
rem process level specific items
 call :processMeta %sroot%\meta_A_Template.txt
 call :processMeta %tmpldir%\%IDClass%\%IDType%\%$metaTypeini%
SETLOCAL ENABLEDELAYEDEXPANSION
SET "pfns="
FOR /f "delims=" %%i IN ('dir %iroot%\phenodata_20*.txt /B /O:-N') DO (
    SET pfns=!pfns!%%i/
)
SETLOCAL DISABLEDELAYEDEXPANSION
call :getMenu "Select phenodata file" "%pfns%None" pfn
if "%pfn%" EQU "None" ( echo Phenodata:	%pfn%>> %descFile%
) ELSE ( echo Phenodata:	%iroot:\=/%/%pfn%>> %descFile%)
echo Featuredata:	>> %descFile%
rem ---- Type specific fields
set tasdir=%tmpldir%\%IDClass%\%IDType%
    set "line1="
    set "line2="
if /I "%IDClass%"=="WET" goto wetclass
if /I "%IDClass%"=="DRY" goto dryclass
rem if /I "%IDType%" == "R" goto R
rem if /I "%IDType%" == "Stat" goto Stat
echo .
echo Warning: Unseen Assay Type: *%IDType%* - will make Generic %IDClass% Assay
echo .
goto Finish
rem
:wetclass
REM ------------------------------------------ wetclass
rem cd
rem echo tst %tmpldir%\%IDClass%\%IDType%\%$analini%
rem dir %tmpldir%
rem dir ..\%tmpldir%
rem Assay type directory
rem dir %tasdir%
rem dir %tmpldir%
:: echo %cd%
set "analytesInput=Analytes.txt"
::call :getSamples %IDName% %iroot%\%pfn% %aroot%\%analytesInput%
call :getSamples %Adir% %iroot%\%pfn% %aroot%\%analytesInput%

setlocal disabledelayedexpansion
rem  if exist %sroot%\%analytesInput% ( copy %sroot%\%analytesInput% %aroot%\%analytesInput% )
  rem dir %tmpldir%\%IDClass%\%IDType%\
    set "line1="
    set "line2="
if exist %tasdir%\%$analini% call :processAnalytes %tasdir%\%$analini%

 rem echo tst after processAnalytes: line1 %line1%
 rem echo tst after processAnalytes: line2 %line2%
 goto Finish
REM ------------------------------------------/wetclass
:dryclass
REM ---------------------------------------- dryclass
    copy %tmpldir%\upload.bat . > NUL
    copy %tmpldir%\ignore.txt . > NUL
    set "line1="
    set "line2="
    if exist %tasdir%\%$analini% call :processAnalytes %tasdir%\%$analini%
    goto Finish
REM ---------------------------------------- /dryclass
:Finish
echo Data:	>> %descFile%
rem ------------------------------------  include common.ini from project level
copy %descFile%+..\common.ini %descFile% \b >NUL
rem echo ASSAY:	%ID%>> ..\_STUDY_METADATA.TXT
copy %sroot%\showTree.bat . >NUL
copy %sroot%\showMetadata.bat . >NUL
copy %sroot%\xcheckMetadata.bat . >NUL

rem
rem  make main readme.md file
rem type README.MD
rem dir .
cls
echo ======================================
echo      Assay METADATA
echo ======================================
call :showDesc %descFile%
cd ..
rem copy existing files from nonversioned tree (if any)
rem robocopy X-%ID% %ID% /E
rem dir .\%ID% /s/b
echo.
echo ============================== pISA ==
echo.
echo Assay %ID% is ready.
echo Location: %cd%\%aname%
echo.
echo ======================================
rem PAUSE
goto:eof
rem ====================================== / makeAssay
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:showMetadata
@echo off
rem -------------------------------------  pISA-tree %$ver%
rem
rem Prepare Metadata for levels below the current level
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
TITLE %$ver%
setlocal EnableDelayedExpansion
set rtyp=txt
call:getMenu "Select report type" "Markdown/Plain text" rtip
if "%rtip%" EQU "Markdown" ( set "rtyp=md" ) 
set lfn=Metadata.%rtyp%
set LF=^


REM Two empty lines are necessary
echo !LF!*!LF!>line.tmp
where /R . _*.txt > src.tmp
rem change \ with /
echo # Metadata files>!lfn!
set "mycd=%cd:\=;%"
if "%rtyp%" EQU "md" set "mycd=%mycd:_=\_%
echo %mycd:;=  !LF!/%>>!lfn!
For /F "tokens=1*" %%i in (src.tmp) do (
	rem (echo.|set /p =## %%i!LF!)>name.tmp
	rem copy !lfn!+line.tmp !lfn!
	echo !LF!---!LF!>>!lfn!
	rem copy !lfn!+name.tmp !lfn!
	rem Shorten the path( remove project root) and change \ to /
	set "fname=%%i"
	set "fname=!fname:%cd%= * **!"
	@echo. !fname!
	set "fname=!fname:\=/!"
	if "%rtyp%" EQU "md" set "fname=!fname:_=\_!"
	(echo.|set /p =" !fname!**!LF!")>>!lfn!
	echo !LF!---!LF!>>!lfn!
	REM set /p="TextHere" <nul >>!lfn!
	REM Add two blanks to each line
	set addtext="  "
	if exist tmpfile.tmp del /q tmpfile.tmp
	if "%rtyp%" EQU "md" (
		echo ^|Key^|Value^| >> tmpfile.tmp
		echo ^|:---^|:---^| >> tmpfile.tmp
		) ELSE (
		echo Key	Value >> tmpfile.tmp
		)
		for /f "delims=" %%l in (%%i) Do (
			if "%rtyp%" EQU "md" (
				set "iv=%%l"
				set "iv=!iv::	=:|!"
				set "iv=!iv:_=\_!"
				echo ^| !iv!  %addtext% ^| >> tmpfile.tmp
			) ELSE (
			echo %%l >> tmpfile.tmp
			)
		)
	REM
	copy !lfn!+tmpfile.tmp !lfn!>NUL
	REM copy !lfn!+"%%i" !lfn!
)
echo !LF!---!LF!>>!lfn!
del *.tmp
::@echo on
@echo.
@echo.Metadata of levels below %cd% are in !lfn!
@echo.
if %rtyp% EQU txt start excel !lfn! 
if %rtyp% NEQ txt open !lfn!
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:xcheckMetadata
@echo off
rem -------------------------------------  pISA-tree %$ver%
rem
rem Check Metadata for levels below the current level
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
TITLE %$ver%
setlocal EnableDelayedExpansion
set lfn=xCheckMetadata.md
set LF=^


REM Two empty lines are necessary
echo !LF!*!LF!>line.tmp
where /R . _*.txt > src.tmp
rem change \ with /
echo # Check for missing metadata >!lfn!
set "mycd=%cd:\=;%"
set "mycd=%mycd:_=\_%
echo %mycd:;=  !LF!/%>>!lfn!
For /F "tokens=1*" %%i in (src.tmp) do (
	rem (echo.|set /p =## %%i!LF!)>name.tmp
	rem copy !lfn!+line.tmp !lfn!
	echo !LF!---!LF!>>!lfn!
	rem copy !lfn!+name.tmp !lfn!
	rem Shorten the path( remove project root) and change \ to /
	set "fname=%%i"
	set "fname=!fname:%cd%= * !"
	set "fname=!fname:\=/!"
	set "fname=!fname:_=\_!"
	echo !fname!
	(echo.|set /p =" !fname! !LF!")>>!lfn!
	echo !LF!---!LF!>>!lfn!
	REM set /p="TextHere" <nul >>!lfn!
	REM Add two blanks to each line
	set addtext="  "
	rem find stars
	for /f "delims=" %%a in ('findstr "*" %%i') do echo  ?? MISSING: %%a %addtext% >> !lfn!
	rem 
	if exist tmpfile.tmp del /q tmpfile.tmp
)
echo !LF!---!LF!>>!lfn!
del *.tmp
@echo on
rem type Metadata.md
@echo Metadata levels below %cd%
open !lfn!
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
:showTree
@echo off
rem -------------------------------------  pISA-tree %$ver%
rem
rem make a directory tree in TREE.txt
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem
rem echo %~dp0 > d.tmp
TITLE %$ver%
echo %cd%> d.tmp
tree /A /F > t.tmp
copy d.tmp+t.tmp TREE.TXT
del *.tmp
type tree.txt
echo. Directory tree file: TREE.TXT
open tree.txt
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
rem 
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
echo ======================================
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
echo ======================================
echo.
echo %~1
echo.
set mn=%~2
rem 
IF NOT "%mn:~-1%"=="/" set mn=%mn%/
set _mn=%mn%
set nl=0
set "mchl=123456789ABCDEFGHIJKLMNOP"
set "mch="
rem echo %mn%
rem echo. 
:top
rem if "%mn%"=="" goto :done
set /A "nl=%nl%+1"
set cprf=%mchl:~0,1%
set mchl=%mchl:~1%
set mch=%mch%%cprf%
for /F "tokens=1 delims=/" %%H in ("%mn%") DO echo    %cprf% %%H
set mn=%mn:*/=%
if NOT "%mn%"=="" goto :top
rem :done
echo. 
choice /C:%mch% /M:Select 
(ENDLOCAL
    for /F "tokens=%errorlevel% delims=/" %%H in ("%_mn%") DO set "%~3=%%H"
)
GOTO:EOF
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
REM ----------------------------------------------------------
:processAnalytes  --- read Analytes.ini and loop through lines
::                --- %~1 file path
::                --- %~2 Variable to get result
:: Return:    >>> 
:: Example: call:processAnalytes %tmpldir%\%IDClass%\%IDType%\Analytes.ini"
rem first id is prefixed. will be reset to empty after the first line
set postfix=_%IDName%
set "lfn=%~1"
if %lfn%=="" set "lfn=%tmpldir%\%IDClass%\%IDType%\%$analini%"
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
::            --- %~1 line from Analytes.ini template (two tab delimited strings)
::
:: Example: call:processLine "Descriptor	Option1/Option2"
SET "string=%~1"
REM the line starts with "nn:" - cut off the numbers and colon
set "string=%string:*:=%
rem echo "$%string:~0,1%"
if "$%string:~0,1%" EQU "$#" goto:eof
REM parse Key/Value line (separator is TAB) - do not forget to use "..."
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
::            --- %~1 line from Analytes.ini template (two tab delimited strings)
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
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
rem -----------------------------------
:TRIM
SET %2=%1
GOTO :EOF
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
   CALL :TRIM %_result% _result
   rem echo *%_result%*
   (endlocal 
   set "%~2=%_result%")
   endlocal
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
    for /f tokens^=2^ delims^=^<^>^:^.^,()$[]^"^/^\^|^?^*^ eol^= %%y in ("A!my_file!A") do (
        rem If we are here there is a second token, so, there is a special character
        echo. Error : Non allowed character in ID
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
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
  :: echo !line!
  setlocal EnableDelayedExpansion
  rem set "preparedLine=#!line:;=;#!"
  rem replace TAB with ;#
  set "preparedLine=#!line:	=;#!"
  :: echo !preparedLine!
  rem get first two and 'assayID' tokens
  FOR /F "tokens=1-2,%where% delims=;" %%c in ("!preparedLine!") DO (
    endlocal
    set "param1=%%c"
    set "param2=%%d"
    set "param3=%%e"
    setlocal EnableDelayedExpansion
    rem echo $1=!param1! $2=*!param2!* $3=*!param3!*
    rem remove leading #
    set "param1=!param1:~1!"
    set "param2=!param2:~1!"
    if "!param3!" NEQ "" set "param3=!param3:~1!"
    rem echo $1=!param1! $2=*!param2!* $3=*!param3!*
    if "!param3!" NEQ "" echo !param1!	!param2!	!param3!>> %outfile%
    endlocal
  )
)
) 
rem else (echo No column %~1 in: & echo %line1%)
setlocal disabledelayedexpansion
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
:: echo /+ %strings%
rem Replace ?
set "strings=%strings:?=-QM-%"
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
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
goto:EOF
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
rem -------------------------------------------------------------------
:showTwoCol --- show one line
::			--- %~1 first column
::			--- %~2 second column
::
:: Example: call:showTwoCol "Key name" "Key value"
::
	set "_sp=                                         "
    set "iname=%~1%_sp%"
    set "iname=%iname:~0,35%"
    echo %iname% %~2
goto:eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
REM ----------------------------------------------------------
:processMeta  --- read meta ini file and loop through lines
::                --- %~1 file path
::                --- %~2 Variable to get result
:: Return:    >>> 
:: Example: call:processMeta %tmpldir%\%IDClass%\%IDType%\Analytes.ini"
rem first id is prefixed. will be reset to empty after the first line
echo off
call:normalizeDate today -
set "lfn=%~1"
if not exist %lfn% goto:eof
if %lfn%=="" echo Nothing to process
SETLOCAL EnableDelayedExpansion
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %lfn%"`) do (
	 call :processLine "%%a"
    )
echo off
goto :eof
rem XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX