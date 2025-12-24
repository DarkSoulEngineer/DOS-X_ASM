# Build Guide

## Prerequisites

- **DOSBox-X** (or DOSBox) installed and configured
- Project files organized in the new structure

## DOSBox-X Build (64-bit Windows)

```batch
scripts\build.bat
```

This script uses DOSBox-X to run TASM and TLINK in a DOS environment.

## Build Specific File

To build a different assembly file:

```batch
scripts\build.bat <filename>
```

Example:
```batch
scripts\build.bat MENU
```

## How the Build Works

The build script performs the following steps:

1. **Changes to src/ directory** - This ensures TASM can resolve INCLUDE directives
2. **Assembles the source** - Converts `.ASM` to `.OBJ` object file
3. **Links the object** - Creates final `.EXE` executable
4. **Outputs to build/** - All artifacts go to the `build/` directory

## Clean Build Artifacts

To remove all build artifacts:

```batch
scripts\clean.bat
```

This removes all `.OBJ`, `.MAP`, `.EXE`, and `.LST` files from the `build/` directory.

## Running in DOSBox-X

### Method 1: Command Line

```batch
dosbox-x -c "mount c ." -c "c:" -c "build\MAIN.exe"
```

### Method 2: Interactive

1. Launch DOSBox-X
2. Mount the project directory:
   ```
   mount c C:\path\
   ```
3. Switch to C drive:
   ```
   c:
   ```
4. Run the executable:
   ```
   build\MAIN.exe
   ```

## Troubleshooting

### Assembly Failed

**Error**: `Assembly failed!`

**Cause**: Syntax errors in `.ASM` files or missing includes

**Solution**: 
- Check the build\build_log.log output for specific error messages
- Verify all included files exist in `src/` directory
- Ensure syntax is correct for 8086 assembly

## Manual Build (Advanced)

If you need to build manually:

```batch
REM Navigate to src directory
cd src

REM Assemble
..\tools\tasm.exe MAIN.asm ..\build\MAIN.obj

REM Go back to root
cd ..

REM Link
.\tools\tlink.exe .\build\MAIN.obj, .\build\MAIN.exe
```

## Project Structure

```
ACTIVE/
├── src/              # Source .ASM files
├── scripts/          # Build scripts
├── tools/            # TASM, TLINK, etc.
├── build/            # Build output (.EXE, .OBJ, .MAP)
└── docs/             # Documentation (this file)
```
