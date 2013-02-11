@echo off
echo Droprate number you want to use for all the items
set /p rate=
tclkitsh.exe script.tcl %rate%
pause