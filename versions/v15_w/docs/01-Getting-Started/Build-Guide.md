# Build Guide

## Prerequisites

- **DOSBox-X** (or DOSBox) installed and configured
- Project files organized in the new structure

## Quick Build

### Option 1: Direct Build (32-bit Windows or with 16-bit support)

From the project root directory, simply run:

```batch
scripts\build.bat
```

This will automatically build `MAIN.ASM` (the default) and output to `build\MAIN.EXE`.

### Option 2: DOSBox-X Build (64-bit Windows)

If you're on 64-bit Windows and cannot run 16-bit executables directly, use:

```batch
scripts\build-dosbox.bat
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
   mount c C:\path\to\ACTIVE
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
- Check the TASM output for specific error messages
- Verify all included files exist in `src/` directory
- Ensure syntax is correct for 8086 assembly

### Linking Failed

**Error**: `Linking failed!`

**Cause**: Undefined symbols or linker configuration issues

**Solution**:
- Ensure all procedures called are defined
- Check that `.MODEL SMALL` is used consistently
- Verify stack segment is properly defined

### INCLUDE Files Not Found

**Error**: Files included with `INCLUDE` directive not found

**Cause**: TASM cannot find included files

**Solution**: 
- The build script handles this automatically by changing to `src/` directory
- If building manually, ensure you're in the `src/` directory
- Verify all included files exist in `src/`

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
