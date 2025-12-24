# Module Documentation

Detailed documentation for each module in the assembly project.

## MAIN.ASM

**Purpose**: Application entry point and orchestration

**File**: [MAIN.ASM](file:///../src/MAIN.ASM)

**Responsibilities**:
- Initialize data segment (`DS`) 
- Clear screen before showing menu
- Transfer control to main menu

**Entry Points**:
- `MAIN` - Program entry point (defined with `END MAIN`)

**Dependencies**:
- DATA.ASM (data segment)
- IO.ASM (`_clear_screen`)
- MENU.ASM (`ShowMenu`)
- DRAWM.ASM, DRAWL.ASM, DRAWS.ASM (drawing modules)
- INP.ASM (input handling)

**Call Graph**:
```
MAIN
  ├─ _clear_screen (IO.ASM)
  └─ ShowMenu      (MENU.ASM)
```

---

## DATA.ASM

**Purpose**: Centralized data segment and constants

**File**: [DATA.ASM](file:///../src/DATA.ASM)

**Contains**:
- `.DATA` segment definition
- String constants for menus
- Message text
- Configuration values
- Shared variables

**Usage**: Included by MAIN.ASM, provides shared data for all modules

---

## IO.ASM

**Purpose**: Display and graphics I/O operations

**File**: [IO.ASM](file:///../src/IO.ASM)

**Provides**:
- `_clear_screen` - Clear screen in text mode
- Graphics mode initialization (Mode 13h)
- Video memory access (segment A000h)
- Screen output utilities

**Interrupts Used**:
- INT 10h - Video services (mode set, cursor, scroll)
- INT 21h - DOS services (string output)

---

## MENU.ASM

**Purpose**: Main menu controller and user interface

**File**: [MENU.ASM](file:///../src/MENU.ASM)

**Provides**:
- `ShowMenu` - Display main menu and handle selection

**Responsibilities**:
- Display menu options
- Read user input
- Route to appropriate drawing module based on selection
- Handle exit command

**Interrupts Used**:
- INT 21h - DOS services (input/output, exit)
- INT 16h - BIOS keyboard (wait for key)

---

## FILE.ASM

**Purpose**: Screen capture, save/load/preview, buffer restore  
**File**: [`src/FILE.ASM`](file:///../src/FILE.ASM)

**Key Routines**
- `CaptureScreen` / `RestoreBufferToVRAM`
- `SaveScreen` (prompted save to `IMAGE.BIN`)
- `LoadImagePath` (preview + buffer capture)
- `LoadImageToBuffer` (load without preview)
- `CheckExistingImage` (find build/current image, ask to load/preview)
- `PreviewExistingImage` (menu option)
- `LoadScreen` (load `IMAGE.BIN` into VRAM)

**Notes**
- Uses `has_loaded_image` to decide buffer restoration before drawing

---

## PIXEL.ASM

**Purpose**: Pixel primitive for Mode 13h  
**File**: [`src/PIXEL.ASM`](file:///../src/PIXEL.ASM)

**Provides**
- `putpixel` (X=CX, Y=DX, color=AL)

---

## SHAPES.ASM

**Purpose**: Drawing routines built on pixels  
**File**: [`src/SHAPES.ASM`](file:///../src/SHAPES.ASM)

**Provides**
- `draw_line`
- `draw_square` (filled)
- `draw_square_outline`

## INP.ASM

**Purpose**: Numeric input and prompts  
**File**: [`src/INP.ASM`](file:///../src/INP.ASM)

**Provides**
- `get_line_parameters`, `sqr_user_input`
- `read_number`, `new_line`

---

## Module Interaction Flow (current)

```
MAIN
  └─ ShowMenu
        ├─ Draw -> CheckExistingImage -> ShowDrawMenu
        │       ├─ draw_line_menu   -> draw_line   -> SaveScreen
        │       └─ draw_square_menu -> draw_square/outline -> SaveScreen
        ├─ Preview -> PreviewExistingImage
        ├─ About -> logo screen
        └─ Exit
```

## Common Patterns

### Module Structure

Most modules follow this pattern:

```asm
; Module comments and documentation
.CODE

; Procedure definitions
ProcedureName PROC
    ; Implementation
    RET
ProcedureName ENDP

; Additional procedures...
```

### INCLUDE Files

MAIN.ASM includes all other modules:

```asm
INCLUDE DATA.ASM    ; Must be first (data segment)
INCLUDE IO.ASM
INCLUDE MENU.ASM
INCLUDE PIXEL.ASM
INCLUDE SHAPES.ASM
INCLUDE FILE.ASM
INCLUDE INP.ASM
```

### Interrupt Usage

Standard interrupt calling pattern:

```asm
MOV AH, function_number
MOV AL, parameter       ; if needed
INT interrupt_number
```

## See Also

- [[Architecture]] - System architecture overview
- [[Build-Guide]] - How to build and run
- [[README]] - Documentation home
