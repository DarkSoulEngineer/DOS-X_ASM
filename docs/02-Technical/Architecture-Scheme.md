# Architecture Scheme

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      INTEL 8086 SYSTEM                          │
├─────────────────────────────────────────────────────────────────┤
│                          MAIN.ASM                               │
│         (Application Entry Point & Orchestration)               │
├─────┬─────────┬─────────┬──────────┬─────────┬──────────────────┤
│     │         │         │          │         │                  │
│IO.ASM      MENU.ASM   DATA.ASM   SHAPES.ASM  INP.ASM            │
│     │         │         │          │         │                  │
└─────┴─────────┴─────────┴──────────┴─────────┴──────────────────┘
```

## Detailed Component Relationships

### Control Flow
```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌──────────┐
│ MAIN.ASM│───▶│ IO.ASM  │───▶│MENU.ASM │───▶│SHAPES.ASM│
└─────────┘    └─────────┘    └─────────┘    └──────────┘
     │              │              │               │
     ▼              ▼              ▼               ▼
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌──────────┐
│Terminate│    │Graphics │    │ INP.ASM │    │ IO.ASM   │
│         │    │Output   │    │         │    │(Display) │
└─────────┘    └─────────┘    └─────────┘    └──────────┘
```

### Data Flow
```
┌─────────┐    ┌─────────┐    ┌─────────┐
│DATA.ASM │◄───│MENU.ASM │◄───│ INP.ASM │
│(Strings,│    │(Menu    │    │(User    │
│ Config) │    │Control) │    │ Input)  │
└─────────┘    └─────────┘    └─────────┘
     │              │
     ▼              ▼
┌─────────┐    ┌──────────┐
│IO.ASM   │    │SHAPES.ASM│
│(Display)│    │(Graphics)│
└─────────┘    └──────────┘
```

## Memory Architecture

### Segment Layout
```
┌─────────────────────────────────────────────────┐
│               1MB ADDRESS SPACE                 │
├─────────────────────────────────────────────────┤
│ 00000h ┌─────────────────────────────────────┐  │
│        │           BIOS AREA                 │  │
│        ├─────────────────────────────────────┤  │
│        │           DOS / TSR                 │  │
│        ├─────────────────────────────────────┤  │
│ A0000h │         VIDEO MEMORY                │  │
│        │      (VGA Mode 13h - A000h)         │  │
│        ├─────────────────────────────────────┤  │
│        │           APPLICATION               │  │
│        │  ┌───────────────────────────────┐  │  │
│        │  │          CODE SEGMENT         │  │  │
│        │  │        (MAIN + Modules)       │  │  │
│        │  ├───────────────────────────────┤  │  │
│        │  │          DATA SEGMENT         │  │  │
│        │  │        (Variables, Strings)   │  │  │
│        │  ├───────────────────────────────┤  │  │
│        │  │           STACK               │  │  │
│        │  │         (256 bytes)           │  │  │
│        │  └───────────────────────────────┘  │  │
│        ├─────────────────────────────────────┤  │
│ FFFF0h │          SYSTEM ROM                │  │
│        └─────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

## Module Interaction Matrix

| Module     | MAIN.ASM | IO.ASM | MENU.ASM | DATA.ASM | SHAPES.ASM | INP.ASM |
|------------|----------|--------|----------|----------|------------|---------|
| **MAIN.ASM** | -        | Calls  | Calls    | Accesses | -          | -       |
| **IO.ASM**   | Called   | -      | Called   | Accesses | Called     | -       |
| **MENU.ASM** | Called   | Calls  | -        | Accesses | Calls      | Calls   |
| **DATA.ASM** | Shared   | Shared | Shared   | -        | Shared     | Shared  |
| **SHAPES.ASM**| -       | Calls  | Called   | Accesses | -          | -       |
| **INP.ASM**  | -        | -      | Called   | Accesses | -          | -       |

## Execution Flow Chart

```
Start (Power On)
    │
    ▼
┌─────────┐
│ BIOS    │
│ Initial │
└─────────┘
    │
    ▼
┌─────────┐
│ DOS     │
│ Loader  │
└─────────┘
    │
    ▼
┌─────────┐
│MAIN.ASM │
│Entry    │
└─────────┘
    │
    ▼
┌─────────┐
│IO.ASM   │
│Clear    │
│Screen   │
└─────────┘
    │
    ▼
┌─────────┐
│MENU.ASM │
│Display  │
│Menu     │
└─────────┘
    │
    ▼
┌─────────┐
│INP.ASM  │
│Get Input│
└─────────┘
    │
    ▼
┌─────────────────┐
│Selection Handler│
│Route to Module  │
└─────────────────┘
    │
    ▼
┌──────────┐    ┌─────────┐
│SHAPES.ASM│    │Exit     │
│Graphics  │    │Option   │
└──────────┘    └─────────┘
    │                │
    ▼                ▼
┌─────────┐      ┌─────────┐
│IO.ASM   │      │System   │
│Display  │      │Shutdown │
│Output   │      └─────────┘
└─────────┘
    │
    ▼
┌─────────┐
│Return to│
│Menu     │
└─────────┘
```

## Hardware Interface Diagram

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│CPU      │◄──▶│Memory   │◄──▶│VGA      │
│8086     │    │Controller│    │Adapter  │
└─────────┘    └─────────┘    └─────────┘
     │              │              │
     ▼              ▼              ▼
┌─────────┐    ┌─────────┐    ┌─────────┐
│BIOS     │    │DOS      │    │Keyboard │
│Services │    │Services │    │Input    │
│(INT)    │    │(INT)    │    │(INT)    │
└─────────┘    └─────────┘    └─────────┘
```

This architecture scheme provides a comprehensive visual representation of how the 8086 assembly application is structured, including module relationships, memory layout, and execution flow.
"