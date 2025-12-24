# Project Overview

A DOS-based graphics application written in 16-bit x86 assembly language for the Intel 8086 processor, demonstrating text mode interfaces and VGA Mode 13h graphics.

## Features

- **Text Mode Interface**: Menu-driven flow in 80x25 text mode
- **VGA Graphics**: Mode 13h (320x200, 256 colors) drawing
- **Drawing Primitives**: Pixels/lines/squares with color selection
- **File I/O**: Save screen to `IMAGE.BIN`, load/preview existing images, draw on top of loaded images
- **Resumable Canvas**: Loaded images are buffered and restored before each new draw
- **DOS Compatible**: Runs on DOS or DOSBox/DOSBox-X

## Quick Start

### Build the Project

```batch
scripts\build.bat
```

### Clean Build Artifacts

```batch
scripts\clean.bat
```

### Run in DOSBox-X

```batch
dosbox-x -c "mount c ." -c "c:" -c "build\MAIN.exe"
```

## Project Structure

```
ACTIVE/
├── src/              # Assembly source files (.ASM)
│   ├── MAIN.ASM      # Entry point and orchestration
│   ├── DATA.ASM      # Data segment, prompts, globals, buffer segment
│   ├── IO.ASM        # Text/video mode helpers, clear, exit
│   ├── MENU.ASM      # Menus (main/draw/file), dispatch, preview
│   ├── FILE.ASM      # Save/load, preview, buffer capture/restore
│   ├── PIXEL.ASM     # Pixel primitive
│   ├── SHAPES.ASM    # Line and square drawing
│   └── INP.ASM       # Numeric input helpers
│
├── scripts/          # Build and utility scripts
│   ├── build.bat         # Assemble/link (writes build\build_log.log)
│   └── clean.bat         # Clean build artifacts
│
├── tools/            # Development tools
│   ├── TASM.EXE      # Turbo Assembler
│   ├── TLINK.EXE     # Turbo Linker
│   ├── TD.EXE        # Turbo Debugger
│   └── ...           # Support files
│
├── build/            # Build output directory
│   ├── *.OBJ         # Object files
│   ├── *.MAP         # Map files
│   └── *.EXE         # Executables
│
└── docs/             # Documentation (Obsidian vault)
    ├── README.md            # This vault's index
    ├── 01-Getting-Started/  # Overview & build notes
    ├── 02-Technical/        # Architecture notes
    └── 03-Reference/        # Module references
```

## Technology Stack

- **Language**: x86 Assembly (16-bit, Intel 8086)
- **Assembler**: Turbo Assembler (TASM)
- **Linker**: Turbo Link (TLINK)
- **Target Platform**: DOS (via DOSBox-X)
- **Memory Model**: SMALL (single code and data segment)

## Interrupts Used

### INT 10h (Video Services)
- Mode setting (text/graphics)
- Cursor control
- Screen scrolling and clearing

### INT 21h (DOS Services)
- Keyboard input (functions 01h, 0Ah)
- String output (function 09h)
- Program exit (function 4Ch)

### INT 16h (BIOS Keyboard)
- Wait for keypress (function 00h)
- Check key status (function 01h)

## Video Modes

### Text Mode (Default)
- 80x25 character display
- Used for menu interface

### Graphics Mode 13h
- 320x200 resolution
- 256 colors
- Linear frame buffer at A000h
- Used for drawing operations

---

**University**: Universitatea Transilvania din Brașov  
**Course**: MIC (Microcontrollers)  
**Year**: 2025

## See Also

- [[Architecture]] - Detailed system architecture
- [[Build-Guide]] - Complete build instructions
- [[Modules]] - Module reference documentation
