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
; DATA.ASM                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025
; =======================================================================================
; FILE: DATA.ASM
; MODULE: Data Definitions, Messages, and Constants
; 
; PURPOSE:
;   - Centralize all textual prompts and UI assets
;   - Provide shared variables for parameters and buffers
;   - Define min/max ranges for basic validation
; =======================================================================================

.DATA
     ; --- Credits / About block (shown from MENU.ASM) ---
     logo DB ' ==================== CREDITS ==================== ' ,13,10
          DB '              __         __                  __    ' ,13,10
          DB '     __ _____/ /__ _____/ /__ ___ ___  __ __/ /    ' ,13,10
          DB '     \ \ / _  / _ `/ __/  \_/(_-</ _ \/ // / /     ' ,13,10
          DB '    /_\_\\_,_/\_,_/_/ /_/\_\/___/\___/\_,_/_/      ' ,13,10,13,10

          DB '              _              __         _          ' ,13,10
          DB '       __ _  (_)__________  / /__    __(_)         ' ,13,10
          DB '      /    \/ / __/ __/ _ \/ __/ |/|/ / /          ' ,13,10
          DB '     /_/_/_/_/\__/_/  \___/\__/|__,__/_/           ' ,13,10,13,10

          DB '             ___    __      __                     ' ,13,10
          DB '            / _/__ / /____ / /__                   ' ,13,10
          DB '           / _/ -_) __/ -_) / -_)                  ' ,13,10
          DB '          /_/ \__/\__/\__/_/\__/  doc              ' ,13,10,13,10

          DB ' ================================================= ' ,13,10 
          DB '      16-bit DOS asm for 2D figures rendering      ' ,13,10
          DB ' =================================================$'

     ; --- Main menu prompt ---
     prompt_menu DB '===== MENU =====     ' ,13,10,13,10
                 DB '1. [  Draw    ]      ' ,13,10
                 DB '2. [  Preview ]      ' ,13,10
                 DB '3. [  About   ]      ' ,13,10
                 DB '4. [  Exit    ]      ' ,13,10,13,10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                 DB 'Choose option (1-4): $'
     
     ; --- Draw submenu prompt ---
     prompt_draw DB '===== DRAW =====     ' ,13,10,13,10
                 DB '1. [  Line    ]      ' ,13,10
                 DB '2. [  Sqr     ]      ' ,13,10
                 DB '3. [  Back    ]      ' ,13,10
                 DB '4. [  Exit    ]      ' ,13,10,13,10
                 DB 'Choose option (1-4): $'

     ; --- File submenu prompt ---
     prompt_file DB '===== FILES =====    ' ,13,10,13,10
                 DB '1. [  Save    ]      ' ,13,10
                 DB '2. [  Load    ]      ' ,13,10
                 DB '3. [  Back    ]      ' ,13,10
                 DB '4. [  Exit    ]      ' ,13,10,13,10
                 DB 'Choose option (1-4): $'


     ; --- Line type prompt ---
     prompt_line_type DB '===== LINE TYPE =====' ,13,10,13,10
                      DB '1. [  Horizontal  ]       ' ,13,10
                      DB '2. [  Vertical    ]       ' ,13,10
                      DB '3. [  Back        ]       ' ,13,10
                      DB '4. [  Exit        ]       ' ,13,10,13,10
                      DB 'Choose option (1-4): $    '


     ; --- Square menu prompt ---
     prompt_square DB '=== DRAW SQUARE ===   ' ,13,10,13,10                                                                                                                                                                                                                                                                                                                                           
                   DB '1. [  FILLED  ]       ' ,13,10
                   DB '2. [  OUTLINE ]       ' ,13,10
                   DB '3. [  BACK    ]       ' ,13,10
                   DB '4. [  Exit    ]       ' ,13,10,13,10
                   DB 'Choose option (1-4): $'

     newl           DB 13,10,'$'         ; CRLF sequence for DOS AH=09h

     prompt_width  DB 13,10, 'Enter width: $'
     prompt_height DB 13,10, 'Enter height: $'                                                                                                                                                                                                                                                                                                                                           
     prompt_x      DB 13,10, 'Enter x: $'
     prompt_y      DB 13,10, 'Enter y: $'
     prompt_color  DB 13,10, 'Enter color: $'

     prompt_square_size   DB 13,10,'Enter square size: $'
     prompt_square_x      DB 13,10,'Enter X position: $'
     prompt_square_y      DB 13,10,'Enter Y position: $'
     prompt_square_color  DB 13,10,'Enter color: $'

     ; --- global variables ---
     SCREEN_WIDTH  DW 320
     SCREEN_HEIGHT DW 200

     ; --- File Operations ---
     filename      DB 'IMAGE.BIN', 0
     file_handle   DW ?
     msg_save_ok   DB 13, 10, 'Image Saved Successfully! Press Key.', 13, 10, '$'
     msg_file_err  DB 13, 10, 'File Error! Press Key.', 13, 10, '$'
     prompt_save_confirm DB 'Save screen to file? (y/n): ', 13, 10, '$'
     prompt_load_existing DB 13, 10, 'Existing image found in build. Load it? (y/n): ', 13, 10, '$'
     prompt_preview_image DB 13, 10, 'Preview image before drawing? (y/n): ', 13, 10, '$'
     msg_no_image       DB 13, 10, 'No saved image found. Press any key.', 13, 10, '$'
     image_path_build DB 'build\IMAGE.BIN', 0
     has_loaded_image DB 0

     ; --- Shared parameters for line drawing ---
     line_x DW 0
     line_y DW 0
     line_param DW 0
     line_color DB ?
     line_type DB ?

     ; --- Shared parameters for square drawing ---
     square_x     DW ?
     square_y     DW ?
     square_size  DW ?
     square_color DB ?

.DATA?
BUFFER_SEG SEGMENT
    vram_buffer DB 64000 DUP(?)
BUFFER_SEG ENDS

.DATA
     ; --- DOS 0Ah buffered input: [maxlen, curlen, bytes...] ---
     input_buffer DB 6, 0, 6 dup(0)
     input DB 1 dup(?)                                                                                                                                                                                                                                                                                                                                           
