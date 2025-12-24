; =======================================================================================
; FILE: FILE.ASM
; PURPOSE: Handle File I/O (Save/Load Screen)
; =======================================================================================

.CODE

; =======================================================================================
; CAPTURE SCREEN (VRAM -> BUFFER)
; =======================================================================================
CaptureScreen PROC
    ; Copy 64000 bytes from A000:0000 to vram_buffer (BUFFER_SEG:vram_buffer)
    PUSH AX BX CX DX SI DI DS ES

    ; Setup Source (DS:SI = A000:0000)
    MOV AX, 0A000h
    MOV DS, AX
    XOR SI, SI

    ; Setup Destination (ES:DI = BUFFER_SEG:vram_buffer)
    MOV AX, BUFFER_SEG
    MOV ES, AX
    MOV DI, OFFSET vram_buffer

    MOV CX, 64000
    REP MOVSB

    POP ES DS DI SI DX CX BX AX
    RET
CaptureScreen ENDP

; =======================================================================================
; SAVE SCREEN (PROMPT & SAVE BUFFER)
; =======================================================================================
SaveScreen PROC
    CALL set_text_mode
    CALL _clear_screen
    
    LEA DX, prompt_save_confirm
    CALL PrintString
    
    CALL ReadCharNoEcho
    
    CMP AL, 'y'
    JE do_save_echo
    CMP AL, 'Y'
    JE do_save_echo
    RET

do_save_echo:
    MOV DL, 'y'
    CALL PrintChar
    JMP do_save

do_save:
    ; Create/Open File
    LEA DX, filename
    MOV AH, 3Ch
    MOV CX, 0
    INT 21h
    MOV [file_handle], AX
    JC save_error

    ; Write Buffer to File
    MOV BX, [file_handle]
    MOV CX, 64000
    
    PUSH DS              ; Save @DATA
    MOV AX, BUFFER_SEG
    MOV DS, AX           ; Point DS to buffer segment
    MOV DX, OFFSET vram_buffer
    
    MOV AH, 40h
    INT 21h
    
    POP DS               ; Restore @DATA
    
    JC close_error_save

    ; Close File
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h

    LEA DX, msg_save_ok
    CALL PrintString
    CALL wait_for_key
    RET

save_error:
    LEA DX, msg_file_err
    CALL PrintString
    CALL wait_for_key
    RET

close_error_save:
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h
    JMP save_error
SaveScreen ENDP

; =======================================================================================
; LOAD SCREEN
; =======================================================================================
LoadScreen PROC
    ; 1. Switch Video Mode
    CALL set_video_mode

    ; 2. Open File
    LEA DX, filename
    MOV AL, 0            ; Read Only
    MOV AH, 3Dh
    INT 21h
    MOV [file_handle], AX
    JC load_error

    ; 3. Read into VRAM
    PUSH DS
    MOV AX, 0A000h
    MOV DS, AX
    XOR DX, DX           ; DS:DX = A000:0000
    MOV CX, 64000
    ; MOV BX, [file_handle] ; file_handle is in DATA, not VRAM segment!
    ; We need to read file_handle before switching DS or use CS override if in same segment (unlikely)
    ; But wait, file_handle is in DGROUP. 
    
    ; Restore DS to read handle
    POP DS
    MOV BX, [file_handle]
    
    ; Setup DS for VRAM again
    PUSH DS
    MOV AX, 0A000h
    MOV DS, AX
    XOR DX, DX

    MOV AH, 3Fh
    INT 21h
    POP DS
    JC close_error_load

    ; Close File
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h
    
    CALL wait_for_key
    CALL set_text_mode
    RET

load_error:
    CALL set_text_mode
    LEA DX, msg_file_err
    CALL PrintString
    CALL wait_for_key
    RET

close_error_load:
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h
    JMP load_error
LoadScreen ENDP
