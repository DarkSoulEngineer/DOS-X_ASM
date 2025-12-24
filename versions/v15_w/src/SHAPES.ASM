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
; SHAPES.ASM
; =======================================================================================
; FILE: SHAPES.ASM
; MODULE: Shape Drawing Algorithms
; 
; PURPOSE:
;   - Consolidate all shape rendering logic (Line, Square)
;   - Provide user input helpers for specific shapes
; 
; ENTRY POINTS:
;   - draw_line: Render line based on params (horiz/vert)
;   - draw_square: Render filled square
;   - draw_square_outline: Render square border
;   - sqr_user_input: Collect square params
; 
; DEPENDENCIES:
;   - PIXEL.ASM (draw_pixel)
;   - DATA.ASM (variables)
; =======================================================================================

.CODE

; =======================================================================================
; LINE DRAWING
; =======================================================================================

draw_line:
    ; Draw a horizontal or vertical line using draw_pixel
    PUSH ax bx cx dx si di

    MOV cx, [line_x]
    MOV dx, [line_y]                                                                                                                                                                                                                                                                                                                                           

    CMP byte ptr [line_type], '1'          ; '1' = horizontal
    JE draw_h_loop

    CMP byte ptr [line_type], '2'          ; '2' = vertical
    JE draw_v_loop                                                                                                                                                                                                                                                                                                                                           

    POP di si dx cx bx ax
    RET

; draw horizontal line
draw_h_loop:
    MOV si, cx
    MOV di, [line_param]
    ADD di, si
    
draw_h_pixel:
    CALL draw_pixel
    INC cx
    CMP cx, di
    JL draw_h_pixel
    JMP done_line

; draw vertical line
draw_v_loop:
    MOV si, dx
    MOV di, [line_param]
    ADD di, si
    
draw_v_pixel:
    CALL draw_pixel
    INC dx
    CMP dx, di
    JL draw_v_pixel                                                                                                                                                                                                                                                                                                                                      
    JMP done_line

; done line
done_line:
    POP di si dx cx bx ax
    RET

; =======================================================================================
; SQUARE DRAWING
; =======================================================================================

draw_square:
    ; Draw a filled square at (square_x, square_y) with side = square_size
    PUSH ax bx cx dx si di
    
    MOV ax, [square_x]
    MOV bx, [square_y]
    MOV cx, [square_size]
    
    MOV si, bx
    MOV di, bx                                                                                                                                                                                                                                                                                                                              
    ADD di, cx
    
draw_square_loop:
    MOV [line_x], ax
    MOV [line_y], si
    MOV [line_param], cx
    MOV byte ptr [line_type], '1'   ; horizontal line
    MOV dl, [square_color]
    MOV [line_color], dl
    
    CALL draw_line
    
    INC si
    CMP si, di
    JL draw_square_loop
    
    POP di si dx cx bx ax
    RET
    
draw_square_outline:
    ; Draw only the 4 borders (top, bottom, left, right)
    PUSH ax bx cx dx
    
    MOV ax, [square_x]
    MOV bx, [square_y]
    MOV cx, [square_size]
    MOV dl, [square_color]
    
    MOV [line_x], ax
    MOV [line_y], bx
    MOV [line_param], cx
    MOV byte ptr [line_type], '1'
    MOV [line_color], dl
    CALL draw_line                ; top
    
    MOV [line_x], ax
    MOV dx, bx
    ADD dx, cx
    DEC dx
    MOV [line_y], dx
    MOV [line_param], cx                                                                                                                                                                                                                                                                                                                              
    MOV byte ptr [line_type], '1'
    CALL draw_line                ; bottom
    
    MOV [line_x], ax
    MOV [line_y], bx
    MOV [line_param], cx
    MOV byte ptr [line_type], '2'
    CALL draw_line                ; left

    MOV dx, ax
    ADD dx, cx
    DEC dx
    MOV [line_x], dx
    MOV [line_y], bx
    MOV [line_param], cx
    MOV byte ptr [line_type], '2'
    CALL draw_line                ; right

    POP dx cx bx ax
    RET
