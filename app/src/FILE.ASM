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
; RESTORE BUFFER (BUFFER_SEG:vram_buffer -> A000:0000)
; =======================================================================================
RestoreBufferToVRAM PROC
    PUSH AX BX CX DX SI DI DS ES

    ; Source: BUFFER_SEG:vram_buffer
    MOV AX, BUFFER_SEG
    MOV DS, AX
    MOV SI, OFFSET vram_buffer

    ; Destination: A000:0000
    MOV AX, 0A000h
    MOV ES, AX
    XOR DI, DI

    MOV CX, 64000
    REP MOVSB

    POP ES DS DI SI DX CX BX AX
    RET
RestoreBufferToVRAM ENDP

; =======================================================================================
; CHECK & LOAD EXISTING IMAGE FROM BUILD\IMAGE.BIN (if user agrees)
; =======================================================================================
CheckExistingImage PROC
    PUSH AX BX CX DX
    MOV has_loaded_image, 0       ; reset loaded flag each entry

    ; ------------------------------------------------------------------
    ; Try build\IMAGE.BIN first (relative to executable root)
    ; ------------------------------------------------------------------
    LEA DX, image_path_build
    MOV AL, 0
    MOV AH, 3Dh              ; open file read-only
    INT 21h
    JC try_current_path

    ; close handle, DX still points to build path
    MOV BX, AX
    MOV AH, 3Eh
    INT 21h
    JMP prompt_load_build

try_current_path:
    ; ------------------------------------------------------------------
    ; Fall back to current directory IMAGE.BIN
    ; ------------------------------------------------------------------
    LEA DX, filename
    MOV AL, 0
    MOV AH, 3Dh
    INT 21h
    JNC has_current_image
    JMP no_image_found

has_current_image:

    ; close handle, DX points to filename
    MOV BX, AX
    MOV AH, 3Eh
    INT 21h
    JMP prompt_load_current

prompt_load_build:
    CALL _clear_screen
    LEA DX, prompt_load_existing
    CALL PrintString
    CALL ReadCharNoEcho
    CMP AL, 'y'
    JE load_build_image
    CMP AL, 'Y'
    JE load_build_image
    JMP done_check                ; user declined; keep flag cleared

load_build_image:
    ; Ask whether to preview before drawing
    CALL _clear_screen
    LEA DX, prompt_preview_image
    CALL PrintString
    CALL ReadCharNoEcho
    CMP AL, 'y'
    JE load_build_with_preview
    CMP AL, 'Y'
    JE load_build_with_preview
    ; load into buffer only
    LEA DX, image_path_build
    CALL LoadImageToBuffer
    JMP done_check

load_build_with_preview:
    LEA DX, image_path_build
    CALL LoadImagePath
    JMP done_check

prompt_load_current:
    CALL _clear_screen
    LEA DX, prompt_load_existing
    CALL PrintString
    CALL ReadCharNoEcho
    CMP AL, 'y'
    JE load_current_image
    CMP AL, 'Y'
    JE load_current_image
    JMP done_check                ; user declined; keep flag cleared

load_current_image:
    ; Ask whether to preview before drawing
    CALL _clear_screen
    LEA DX, prompt_preview_image
    CALL PrintString
    CALL ReadCharNoEcho
    CMP AL, 'y'
    JE load_current_with_preview
    CMP AL, 'Y'
    JE load_current_with_preview
    ; load into buffer only
    LEA DX, filename
    CALL LoadImageToBuffer
    JMP done_check

load_current_with_preview:
    LEA DX, filename
    CALL LoadImagePath
    JMP done_check

no_image_found:
done_check:
    POP DX CX BX AX
    RET
CheckExistingImage ENDP

; =======================================================================================
; GENERIC LOAD: LOAD IMAGE AT DS:DX PATH INTO VRAM AND SHOW UNTIL KEY
; =======================================================================================
LoadImagePath PROC
    PUSH AX BX CX DX SI DI DS

    CALL set_video_mode

    ; Open file (read only) with DS:DX path
    MOV AL, 0
    MOV AH, 3Dh
    INT 21h
    MOV [file_handle], AX
    JC load_image_error

    ; Read image into VRAM
    MOV BX, AX               ; file handle
    PUSH DS
    MOV AX, 0A000h
    MOV DS, AX
    XOR DX, DX
    MOV CX, 64000
    MOV AH, 3Fh
    INT 21h
    POP DS
    JC close_error_image
    ; Close handle now that read is done
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h

    ; Mark buffer valid
    MOV has_loaded_image, 1

    ; Show image and wait (stay in video mode)
    MOV AH, 00h
    INT 16h

    ; Save loaded image into buffer before leaving video mode
    CALL CaptureScreen
    CALL set_text_mode
    JMP load_image_done

load_image_error:
    CALL set_text_mode
    LEA DX, msg_file_err
    CALL PrintString
    CALL wait_for_key
    JMP load_image_done

close_error_image:
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h
    JMP load_image_error

load_image_done:
    POP DS DI SI DX CX BX AX
    RET
LoadImagePath ENDP

; =======================================================================================
; LOAD IMAGE AT DS:DX INTO BUFFER (NO PREVIEW)
; =======================================================================================
LoadImageToBuffer PROC
    PUSH AX BX CX DX DS

    ; Open file read-only
    MOV AL, 0
    MOV AH, 3Dh
    INT 21h
    JC lib_error
    MOV [file_handle], AX
    MOV BX, AX                 ; keep handle in BX

    ; Read into buffer segment
    PUSH DS
    MOV AX, BUFFER_SEG
    MOV DS, AX
    MOV DX, OFFSET vram_buffer
    MOV CX, 64000
    MOV AH, 3Fh
    INT 21h
    POP DS
    JC lib_close_error

    ; Close file
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h

    ; Mark buffer valid
    MOV has_loaded_image, 1
    JMP lib_done

lib_error:
    LEA DX, msg_file_err
    CALL PrintString
    CALL wait_for_key
    JMP lib_done

lib_close_error:
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h
    JMP lib_error

lib_done:
    POP DS DX CX BX AX
    RET
LoadImageToBuffer ENDP

; =======================================================================================
; PREVIEW EXISTING IMAGE IF FOUND (build\IMAGE.BIN or current)
; =======================================================================================
PreviewExistingImage PROC
    PUSH AX BX CX DX

    ; Try build path first
    LEA DX, image_path_build
    MOV AL, 0
    MOV AH, 3Dh
    INT 21h
    JC preview_try_current

    MOV BX, AX
    MOV AH, 3Eh
    INT 21h
    LEA DX, image_path_build
    CALL LoadImagePath
    JMP preview_done

preview_try_current:
    LEA DX, filename
    MOV AL, 0
    MOV AH, 3Dh
    INT 21h
    JC preview_not_found

    MOV BX, AX
    MOV AH, 3Eh
    INT 21h
    LEA DX, filename
    CALL LoadImagePath
    JMP preview_done

preview_not_found:
    LEA DX, msg_no_image
    CALL PrintString
    CALL wait_for_key

preview_done:
    POP DX CX BX AX
    RET
PreviewExistingImage ENDP

; =======================================================================================
; LOAD IMAGE FROM BUILD\IMAGE.BIN INTO VRAM AND PAUSE FOR VIEW
; =======================================================================================
LoadImageFromBuild PROC
    LEA DX, image_path_build
    CALL LoadImagePath
    RET
LoadImageFromBuild ENDP

; =======================================================================================
; SAVE SCREEN (PROMPT & SAVE BUFFER)
; =======================================================================================
SaveScreen PROC
    PUSH AX BX CX DX SI DI        ; preserve caller registers
    CALL set_text_mode
    CALL _clear_screen
    
    LEA DX, prompt_save_confirm
    CALL PrintString
    
    CALL ReadCharNoEcho
    
    CMP AL, 'y'
    JE do_save_echo
    CMP AL, 'Y'
    JE do_save_echo
    JMP save_return              ; user chose not to save

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
    JMP save_return

save_error:
    LEA DX, msg_file_err
    CALL PrintString
    CALL wait_for_key
    JMP save_return

close_error_save:
    MOV AH, 3Eh
    MOV BX, [file_handle]
    INT 21h
    JMP save_error
SaveScreen ENDP

save_return:
    POP DI SI DX CX BX AX
    RET

; =======================================================================================
; LOAD SCREEN
; =======================================================================================
LoadScreen PROC
    LEA DX, filename
    CALL LoadImagePath
    RET
LoadScreen ENDP
