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
;  \___/|_||_|_|\_/\___|_| /__/_|\__\__,_|\__\___\__,_|   |_||_| \__,_|_||_/__/_|_|\_/\__,_|_||_|_\__,_| \__,_|_|_||_| |___/_| \__,_/__/\___\_/ 
; PIXEL.ASM
; =======================================================================================
; FILE: PIXEL.ASM
; MODULE: Pixel Drawing Primitive
; 
; PURPOSE:
;   - Provide low-level pixel drawing capability
;   - Handle boundary checks
;   - Calculate VRAM offsets for Mode 13h
; 
; DEPENDENCIES:
;   - DATA.ASM for SCREEN_WIDTH, SCREEN_HEIGHT, line_color
;   - ES register set to A000h (Video Memory)
; 
; ENTRY POINTS:
;   - draw_pixel
; =======================================================================================

.CODE

draw_pixel:
    ; Draw one pixel at (CX, DX) with color in [line_color], bounds-checked
    PUSH ax bx cx dx di
    
    CMP cx, [SCREEN_WIDTH]
    JAE skip_pixel
    CMP dx, [SCREEN_HEIGHT]
    JAE skip_pixel
    
    ; Calculate VRAM offset: offset = y * SCREEN_WIDTH + x
    MOV ax, dx                 ; y coordinate
    MOV bx, [SCREEN_WIDTH]     ; screen width
    MUL bx                     ; ax = y * SCREEN_WIDTH
    ADD ax, cx                 ; ax = y * SCREEN_WIDTH + x
    MOV di, ax                 ; di = memory offset
    MOV al, [line_color]

    MOV BYTE PTR es:[di], al
    
skip_pixel:
    POP di dx cx bx ax
    RET
