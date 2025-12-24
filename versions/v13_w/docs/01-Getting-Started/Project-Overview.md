# Project Overview

A DOS-based graphics application written in 16-bit x86 assembly language for the Intel 8086 processor, demonstrating text mode interfaces and VGA Mode 13h graphics.

## Features

- **Text Mode Interface**: Clean menu-driven interface in 80x25 text mode
- **VGA Graphics**: Mode 13h (320x200, 256 colors) graphics rendering
- **Modular Design**: Clean separation of concerns across modules
- **Multiple Drawing Modes**: Small, medium, and large drawing options
- **DOS Compatible**: Runs on DOS or DOSBox/DOSBox-X

## Quick Start

### Build the Project

```batch
scripts\build-dosbox.bat
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
│   ├── DATA.ASM      # Data segment and constants
│   ├── IO.ASM        # Display and graphics I/O
│   ├── MENU.ASM      # Main menu controller
│   ├── DRAWM.ASM     # Medium drawing module
│   ├── DRAWL.ASM     # Large drawing module
│   ├── DRAWS.ASM     # Small drawing module
│   └── INP.ASM       # Input handling
│
├── scripts/          # Build and utility scripts
│   ├── build-dosbox.bat  # Build with DOSBox-X (recommended)
│   ├── build.bat         # Direct build (16-bit support required)
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
    ├── README.md           # This vault's index
    ├── Project-Overview.md # This file
    ├── Architecture.md     # System architecture
    ├── Build-Guide.md      # Build instructions
    └── Modules.md          # Module documentation
```

## Technology Stack

- **Language**: x86 Assembly (16-bit, Intel 8086)
- **Assembler**: Turbo Assembler (TASM)
- **Linker**: Turbo Link (TLINK)
- **Target Platform**: DOS (via DOSBox-X)
- **Memory Model**: SMALL (single code and data segment)

## System Overview

The application follows a modular architecture with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│                   MAIN.ASM                      │
│         (Entry Point & Orchestration)           │
└────────────┬────────────────────────────────────┘
             │
             ├──► DATA.ASM (Data Segment)
             ├──► IO.ASM (Display & Graphics)
             ├──► MENU.ASM (Main Menu)
             │      ├──► DRAWM.ASM (Medium)
             │      ├──► DRAWL.ASM (Large)
             │      └──► DRAWS.ASM (Small)
             └──► INP.ASM (Input Handling)
```

For detailed architecture information, see [[Architecture]].

## Development

### Prerequisites

- DOSBox or DOSBox-X
- Understanding of x86 assembly
- Basic knowledge of DOS interrupts

### Adding New Modules

1. Create `.ASM` file in `src/`
2. Add `INCLUDE` directive in `MAIN.ASM`
3. Rebuild with `scripts\build-dosbox.bat`

### Debugging

Use Turbo Debugger (included in `tools/`):

```batch
# In DOSBox-X
tools\TD build\MAIN.exe
```

## Building

The build process is streamlined with smart build scripts that handle INCLUDE directives automatically.

### Default Build (MAIN.ASM)

```batch
scripts\build-dosbox.bat
```

### Build Specific File

```batch
scripts\build-dosbox.bat <filename>
```

Example:
```batch
scripts\build-dosbox.bat MENU
```

The build script:
1. Creates temporary DOSBox-X configuration
2. Runs TASM in DOSBox-X environment to assemble source
3. Links object files into executable
4. Outputs to `build/` directory
5. Reports build success/failure

For detailed build information, see [[Build-Guide]].

## Module Overview

### Core Modules

- **MAIN.ASM** - Application entry point, initializes system and calls menu
- **DATA.ASM** - Centralized data segment with constants and variables
- **IO.ASM** - Display operations, screen clearing, graphics mode setup
- **MENU.ASM** - Main menu display and user interaction
- **INP.ASM** - Keyboard input handling and validation

### Drawing Modules

- **DRAWS.ASM** - Small-sized graphics rendering
- **DRAWM.ASM** - Medium-sized graphics rendering  
- **DRAWL.ASM** - Large-sized graphics rendering

For detailed module documentation, see [[Modules]].

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
**Course**: MIC (Microcomputers)  
**Year**: 2025

## See Also

- [[Architecture]] - Detailed system architecture
- [[Build-Guide]] - Complete build instructions
- [[Modules]] - Module reference documentation
