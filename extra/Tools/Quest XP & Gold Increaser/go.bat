@echo off
echo Experience rate number you want to multiply it
echo (ie. 100 will do 100x all exp rates)
set /p rate=
tclkitsh.exe script.tcl %rate%
pause