# Assembly Graphics Project - Documentation

Welcome to the comprehensive documentation for the DOS Assembly Graphics Project.

> [!NOTE]
> This folder is configured as an **Obsidian vault**. Open it in Obsidian for the best experience with linked navigation between documents.

## 📂 Documentation Structure

### 01-Getting-Started
Start here! Everything you need to get up and running.
- [[01-Getting-Started/Project-Overview|Project Overview]] - Complete project information, features, and structure
- [[01-Getting-Started/Build-Guide|Build Guide]] - How to build and run the project

### 02-Technical  
Deep dive into the system architecture and design.
- [[02-Technical/Architecture|Architecture]] - System design and module structure

### 03-Reference
Detailed reference documentation for developers.
- [[03-Reference/Modules|Module Reference]] - Detailed module documentation

## Quick Start

New to this project? Follow this path:

1. **[[01-Getting-Started/Project-Overview|Project Overview]]** - Understand what this project is about
2. **[[01-Getting-Started/Build-Guide|Build Guide]]** - Build and run your first executable
3. **[[02-Technical/Architecture|Architecture]]** - Learn the system design
4. **[[03-Reference/Modules|Module Reference]]** - Explore individual modules

## 📖 Documentation Index

### Getting Started
- **Project Overview** - Features, structure, quick start
- **Build Guide** - Build methods, troubleshooting, DOSBox-X usage

```

## Project Components

### Source Code (`../src/`)
- `MAIN.ASM` - Entry point
- `DATA.ASM` - Data segment
- `IO.ASM` - Display & graphics
- `MENU.ASM` - Menu controller
- `DRAW*.ASM` - Drawing modules
- `INP.ASM` - Input handling

### Build Scripts (`../scripts/`)
- `build.bat` - Build script (DOS/DOSBox-X)
- `clean.bat` - Clean build artifacts

### Tools (`../tools/`)
- TASM, TLINK, TD (Turbo Debugger)

## Technology Stack

- **Language**: x86 Assembly (16-bit)
- **Assembler**: TASM
- **Target**: DOS via DOSBox-X
- **Graphics**: Mode 13h (320x200, 256 colors)

---

**University**: Universitatea Transilvania din Brașov  
**Course**: MIC (Microcomputers)  
**Year**: 2025
