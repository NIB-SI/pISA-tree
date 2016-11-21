@echo off
rem -------------------------------------  pISA-tree v.0.2
rem
rem make a directory tree in TREE.txt
rem ------------------------------------------------------
rem Author: A Blejec <andrej.blejec@nib.si>
rem (c) National Institute of Biology, Ljubljana, Slovenia
rem 2016
rem ------------------------------------------------------
rem
rem echo %~dp0 > d.tmp
echo %cd% > d.tmp
tree /A /F > t.tmp
copy d.tmp+t.tmp TREE.TXT
del *.tmp
type tree.txt
echo Directory tree file: TREE.TXT
pause