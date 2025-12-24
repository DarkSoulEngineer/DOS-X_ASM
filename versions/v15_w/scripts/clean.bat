@echo off
REM ==========================================
REM Clean all build artifacts in build/ folder
REM ==========================================

echo Cleaning build artifacts...

REM Go to project root
cd ..

REM Delete build artifacts
del build\*.OBJ
del build\*.MAP
del build\*.EXE
del build\*.BIN
del build\*.LOG

echo Done.
echo.
echo All build artifacts cleared from build\ directory.