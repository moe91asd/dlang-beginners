@echo off

REM Change to your environment
set source=app.d
set target=dlang_learn.exe

echo Build and Run: %target%

dmd src\%source% -of%target% -release -O -boundscheck=off

del *.obj /Q

pause

start %target%

