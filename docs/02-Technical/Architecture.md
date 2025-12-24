# Architecture

## System Overview

This application follows a modular architecture with clear separation of concerns. The system is organized into distinct modules, each responsible for specific functionality.

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

#### SHAPES.ASM (Medium)
- Medium-sized graphics rendering

### INP.ASM
- **Purpose**: User input handling
- **Provides**:
  - Keyboard input via INT 21h
  - Key waiting via INT 16h
  - Input validation

## Memory Model

- **Model**: SMALL
- **Code Segment**: Single 64KB segment
- **Data Segment**: Single 64KB segment  
- **Stack**: 256 bytes (100h)