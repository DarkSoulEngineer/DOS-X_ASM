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
;  \___/|_||_|_|\_/\___|_| /__/_|\__\__,_|\__\___\__,_|   |_||_| \__,_|_||_/__/_|_|\_/\__,_|_||_|_\__,_| \__,_|_|_||_| |___/_| \__,_/__/\___/\_/ 
; MENU.ASM
; =======================================================================================
; FILE: MENU.ASM
; MODULE: Unified Menu System (Text UI)
; 
; PURPOSE:
;   - Present main menu and all submenus (Draw, File)
;   - Dispatch to drawing routines in SHAPES.ASM and file routines in FILE.ASM
;   - Handle navigation between menus
; 
; DEPENDENCIES:
;   - DATA.ASM (prompts)
;   - IO.ASM (I/O)
;   - SHAPES.ASM (Drawing)
;   - INP.ASM (Input)
;   - FILE.ASM (Save/Load)
; =======================================================================================

.CODE

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
; FILE SUBMENU
; =======================================================================================
ShowFileMenu PROC

show_file_menu:
    CALL _clear_screen
    LEA DX, prompt_file
    CALL PrintString

    MOV ah, 01h
    INT 21h

    CMP AL, '1'
    JE do_load_screen
    
    CMP AL, '2'
    JNE check_file_exit
    JMP draw_menu
    
check_file_exit:
    CMP AL, '3'
    JE _program_end_file

    JMP show_file_menu

do_load_screen:
    CALL LoadScreen              ; FILE.ASM
    JMP show_file_menu

_program_end_file:
    CALL _clear_screen
    CALL _exit_program
    RET

ShowFileMenu ENDP

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
    
    CALL draw_line               ; draw_line from SHAPES.ASM

    MOV ah, 00h
    INT 16h                      ; Wait for key to view drawing
    
    CALL CaptureScreen           ; Copy VRAM to Buffer
    CALL set_text_mode           ; Switch to Text Mode
    CALL SaveScreen              ; Prompt and Save (from Buffer)

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
    CALL sqr_user_input          ; from INP.ASM
    CALL _clear_screen
    CALL set_video_mode
    CALL draw_square             ; from SHAPES.ASM (filled square)
    
    MOV ah, 00h
    INT 16h                      ; Wait for key
    
    CALL CaptureScreen
    CALL set_text_mode
    CALL SaveScreen
    
    RET

prepare_outline_square:
    CALL sqr_user_input          ; from INP.ASM
    CALL _clear_screen
    CALL set_video_mode
    CALL draw_square_outline     ; from SHAPES.ASM
    
    MOV ah, 00h
    INT 16h                      ; Wait for key
    
    CALL CaptureScreen
    CALL set_text_mode
    CALL SaveScreen

    RET

_program_end_sqr:
    CALL _clear_screen
    CALL _exit_program
    RET
