; ▀████    ▐████▀ ████████▄     ▄████████    ▄████████    ▄█   ▄█▄    ▄████████  ▄██████▄  ███    █▄   ▄█       
;   ███▌   ████▀  ███   ▀███   ███    ███   ███    ███   ███ ▄███▀   ███    ███ ███    ███ ███    ███ ███       
;    ███  ▐███    ███    ███   ███    ███   ███    ███   ███▐██▀     ███    █▀  ███    ███ ███    ███ ███       
;    ▀███▄███▀    ███    ███   ███    ███  ▄███▄▄▄▄██▀  ▄█████▀      ███        ███    ███ ███    ███ ███       
;    ████▀██▄     ███    ███ ▀███████████ ▀▀███▀▀▀▀▀   ▀▀█████▄    ▀███████████ ███    ███ ███    ███ ███       
;   ▐███  ▀███    ███    ███   ███    ███ ▀███████████   ███▐██▄            ███ ███    ███ ███    ███ ███       
;  ▄███     ███▄  ███   ▄███   ███    ███   ███    ███   ███ ▀███▄    ▄█    ███ ███    ███ ███    ███ ███▌    ▄ 
; ████       ███▄ ████████▀    ███    █▀    ███    ███   ███   ▀█▀  ▄████████▀   ▀██████▀  ████████▀  █████▄▄██     
;
;  _   _      _                _ _        _              _____                 _ _               _           _ _        ___                      
; | | | |_ _ (_)_ _____ _ _ __(_) |_ __ _| |_ ___ __ _  |_   _| _ __ _ _ _  __(_) |_ ____ _ _ _ (_)__ _   __| (_)_ _   | _ )_ _ __ _ ___ _____ __
; | |_| | ' \| \ V / -_) '_(_-< |  _/ _` |  _/ -_) _` |   | || '_/ _` | ' \(_-< | \ V / _` | ' \| / _` | / _` | | ' \  | _ \ '_/ _` (_-</ _ \ V /
;  \___/|_||_|_|\_/\___|_| /__/_|\__\__,_|\__\___\__,_|   |_||_| \__,_|_||_/__/_|_|\_/\__,_|_||_|_|\__,_| \__,_|_|_||_| |___/_| \__,_/__/\___\_/ 
; MENU.ASM
; =======================================================================================
; FILE: MENU.ASM
; MODULE: Unified Menu System (Text UI)
; 
; PURPOSE:
;   - Present main menu and all drawing-related submenus
;   - Dispatch to drawing routines in DRAWL.ASM and DRAWS.ASM
;   - Handle navigation between menus (forward and back)
; 
; PERIPHERALS AND SERVICES:
;   - Display (INT 10h via IO.ASM for clear)
;   - Keyboard input via DOS (INT 21h/AH=01h)
;   - DOS output (INT 21h/AH=09h) through PrintString
; 
; ENTRY POINTS:
;   - ShowMenu - Main menu
;   - ShowDrawMenu - Drawing submenu
;   - draw_line_menu - Line drawing menu and execution
;   - draw_square_menu - Square drawing submenu
; 
; UI FLOW:
;   ShowMenu (Main)
;     ├─ '1' → ShowDrawMenu
;     ├─ '2' → Credits screen
;     └─ '3' → Exit program
;
;   ShowDrawMenu (Draw Submenu)
;     ├─ '1' → draw_line_menu (DRAWL.ASM primitives)
;     ├─ '2' → draw_square_menu
;     ├─ '3' → back to ShowMenu
;     └─ '4' → Exit program
;
;   draw_square_menu (Square Submenu)
;     ├─ '1' → Filled square (DRAWS.ASM)
;     ├─ '2' → Outline square (DRAWS.ASM)
;     ├─ '3' → back to ShowDrawMenu
;     └─ '4' → Exit program
; =======================================================================================

; =======================================================================================
; MAIN MENU
; =======================================================================================
ShowMenu PROC

draw_menu:
    CALL _clear_screen           ; ensure a clean text screen
    LEA DX, prompt_menu
    CALL PrintString             ; display main menu

    MOV ah, 01h                  ; read single character from STDIN (echo)
    INT 21h                      ; AL = ASCII

    CMP AL, '1'
    JNE check_credits
    JMP show_draw_menu            ; draw menu

check_credits:

    CMP AL, '2'                  ; credits
    JE _draw_credit

    CMP AL, '3'                  ; exit
    JE _program_end

    JMP draw_menu                ; loop back to menu

_draw_credit:
    CALL _clear_screen
    LEA DX, logo                 ; simple credits / about block
    CALL PrintString

    MOV ah, 01h                  ; wait for any key
    INT 21h

    JMP draw_menu

_program_end:
    CALL _clear_screen
    CALL _exit_program           ; graceful exit (IO.ASM)

ShowMenu ENDP

; =======================================================================================
; DRAWING SUBMENU
; =======================================================================================
ShowDrawMenu PROC

show_draw_menu:     
    CALL _clear_screen

    LEA DX, prompt_draw
    CALL PrintString

    mov ah, 01h
    int 21h                      ; AL = input key

    CMP AL, '1'                  ; draw line
    JE draw_line_menu

    CMP AL, '2'                  ; draw square
    JE call_square_menu

    CMP AL, '3'                  ; back to main menu
    JNE check_exit
    JMP draw_menu

check_exit:

    CMP AL, '4'                  ; exit
    JE _program_end

    jmp show_draw_menu

call_square_menu:
    call draw_square_menu        ; enter square submenu

ShowDrawMenu ENDP

; =======================================================================================
; LINE DRAWING MENU
; =======================================================================================
draw_line_menu:
    CALL _clear_screen
    
    CALL get_line_parameters     ; from INP.ASM

    CALL set_video_mode          ; from IO.ASM

    MOV cx, [line_x]
    MOV dx, [line_y]
    MOV al, [line_color]
    
    CALL draw_line               ; draw_line from DRAWL.ASM

    MOV ah, 00h
    INT 16h

    CALL set_text_mode           ; from IO.ASM
    JMP show_draw_menu

; =======================================================================================
; SQUARE DRAWING SUBMENU
; =======================================================================================
draw_square_menu:
    CALL _clear_screen
    LEA DX, prompt_square
    CALL PrintString
    
    MOV ah, 01h                    ; read user selection
    INT 21h

    CMP AL, '1'                  ; draw filled square
    JE prepare_filled_square
    CMP AL, '2'                  ; draw outline square
    JE prepare_outline_square
    
    CMP AL, '3'                  ; back to draw menu
    JNE check_sqr_exit
    JMP show_draw_menu           ; usage of JMP (near) instead of JE (short)

check_sqr_exit:
    CMP AL, '4'                  ; exit
    JE _program_end_sqr

    JMP draw_square_menu

prepare_filled_square:
    CALL sqr_user_input          ; from DRAWS.ASM
    CALL _clear_screen
    CALL set_video_mode
    CALL draw_square             ; from DRAWS.ASM (filled square)
    RET

prepare_outline_square:
    CALL sqr_user_input          ; from DRAWS.ASM
    CALL _clear_screen
    CALL set_video_mode
    CALL draw_square_outline     ; from DRAWS.ASM

_program_end_sqr:
    CALL _clear_screen
    CALL _exit_program
    RET
