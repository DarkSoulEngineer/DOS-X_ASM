@echo off
REM ==========================================
REM Build script for DOS (DOSBox-X)
REM Usage: scripts\build.bat [filename]
REM Example: scripts\build.bat MAIN
REM Default: MAIN
REM ==========================================

REM Default to MAIN if no parameter provided
if "%1"=="" goto defaultname
set FILENAME=%1
goto start

:defaultname
set FILENAME=MAIN

:start
set LOGPATH=..\build\build_log.log
if exist %LOGPATH% del %LOGPATH%
echo ==========================================
echo Building %FILENAME%.ASM
echo ==========================================
echo.

REM Change to src directory for INCLUDE directives
cd ..
cd src

REM Assemble
echo Assembling %FILENAME%.ASM...
echo Build %FILENAME%.ASM > %LOGPATH%
..\tools\tasm.exe %FILENAME%.asm ..\build\%FILENAME%.obj >> %LOGPATH%

if errorlevel 1 goto asmfail

echo Assembly successful!
echo.

REM Go back to root
cd ..

REM Link
echo Linking %FILENAME%.OBJ...
tools\tlink.exe .\build\%FILENAME%.obj, .\build\%FILENAME%.exe

if errorlevel 1 goto linkfail

echo.
echo ==========================================
echo BUILD SUCCESS!
echo Output: build\%FILENAME%.EXE
echo ==========================================

cd build
%FILENAME%.exe
goto end

:asmfail
cd ..
echo.
echo ==========================================
echo ASSEMBLY FAILED!
echo ==========================================
goto end

:linkfail
echo.
echo ==========================================
echo LINKING FAILED!
echo ==========================================
goto end

:end