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

## DRAWM.ASM

**Purpose**: Medium-sized graphics rendering

**File**: [DRAWM.ASM](file:///../src/DRAWM.ASM)

**Provides**:
- Medium-sized drawing operations
- Graphics rendering in Mode 13h

**Called By**: MENU.ASM (on user selection)

---

## DRAWL.ASM

**Purpose**: Large-sized graphics rendering

**File**: [DRAWL.ASM](file:///../src/DRAWL.ASM)

**Provides**:
- Large-sized drawing operations
- Graphics rendering in Mode 13h

**Called By**: MENU.ASM (on user selection)

---

## DRAWS.ASM

**Purpose**: Small-sized graphics rendering

**File**: [DRAWS.ASM](file:///../src/DRAWS.ASM)

**Provides**:
- Small-sized drawing operations
- Graphics rendering in Mode 13h

**Called By**: MENU.ASM (on user selection)

---

## INP.ASM

**Purpose**: User input handling and validation

**File**: [INP.ASM](file:///../src/INP.ASM)

**Provides**:
- Keyboard input reading
- Input validation
- Key waiting utilities

**Interrupts Used**:
- INT 21h - DOS keyboard input (functions 01h, 0Ah)
- INT 16h - BIOS keyboard (function 00h - wait for keypress)

---

## Module Interaction Flow

```
User starts program
        │
        ▼
    MAIN.ASM (initialize, clear screen)
        │
        ▼
    MENU.ASM (display menu, get input)
        │
        ├──► Choice 1 ──► DRAWS.ASM
        ├──► Choice 2 ──► DRAWM.ASM
        ├──► Choice 3 ──► DRAWL.ASM
        └──► Exit     ──► Program terminates
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
INCLUDE DRAWM.ASM
INCLUDE DRAWL.ASM
INCLUDE DRAWS.ASM
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
