# Architecture

## System Overview

This application follows a modular architecture with clear separation of concerns. The system is organized into distinct modules, each responsible for specific functionality.

```
┌─────────────────────────────────────────────────┐
│                   MAIN.ASM                      │
│         (Entry Point & Orchestration)           │
└────────────┬────────────────────────────────────┘
             │
             ├──► DATA.ASM (Data Segment & Constants)
             │
             ├──► IO.ASM (Display & Graphics I/O)
             │
             ├──► MENU.ASM (Main Menu Controller)
             │      │
             │      ├──► DRAWM.ASM (Medium Drawing)
             │      ├──► DRAWL.ASM (Large Drawing)
             │      └──► DRAWS.ASM (Small Drawing)
             │
             └──► INP.ASM (Input Handling)
```

## Module Responsibilities

### MAIN.ASM
- **Purpose**: Application entry point and orchestration
- **Responsibilities**:
  - Initialize data segment
  - Clear screen  
  - Transfer control to menu system
- **Target**: Intel 8086 (16-bit real mode)

### DATA.ASM
- **Purpose**: Centralized data segment
- **Contains**:
  - String constants
  - Menu text
  - Configuration values
  - Shared variables

### IO.ASM
- **Purpose**: Display and graphics operations
- **Provides**:
  - Screen clearing
  - Text mode output
  - VGA Mode 13h graphics initialization
  - Video memory access (A000h segment)

### MENU.ASM
- **Purpose**: Main menu controller
- **Responsibilities**:
  - Display menu options
  - Handle user selection
  - Route to appropriate drawing module
  - Exit handling

### Drawing Modules

#### DRAWM.ASM (Medium)
- Medium-sized graphics rendering

#### DRAWL.ASM (Large)
- Large-sized graphics rendering

#### DRAWS.ASM (Small)
- Small-sized graphics rendering

### INP.ASM
- **Purpose**: User input handling
- **Provides**:
  - Keyboard input via INT 21h
  - Key waiting via INT 16h
  - Input validation

## Interrupt Usage

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

## Memory Model

- **Model**: SMALL
- **Code Segment**: Single 64KB segment
- **Data Segment**: Single 64KB segment  
- **Stack**: 256 bytes (100h)

## Video Modes

### Text Mode (Default)
- 80x25 character display
- Used for menu interface

### Graphics Mode 13h
- 320x200 resolution
- 256 colors
- Linear frame buffer at A000h
- Used for drawing operations

## Build Process

The build process involves two stages:

1. **Assembly** (TASM): Converts `.ASM` source to `.OBJ` object files
2. **Linking** (TLINK): Combines object files into executable `.EXE`

All INCLUDE directives are resolved during assembly, as TASM processes the source files from the `src/` directory.
