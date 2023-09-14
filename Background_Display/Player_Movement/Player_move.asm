    processor 6502
;
    include "vcs.h"
    include "macro.h"
;
    seg.u Variables
    org $80
P0xPos byte
;

    seg code
    org $F000
Reset: 
    CLEAN_START

    ldx #$EA
    stx COLUBK
     
    lda #$45
    sta COLUPF 

    lda #10
    sta P0XPos  

; starting frame
StartFrame:
    lda #2
    sta VBLANK
    sta VSYNC

    REPEAT 3
        sta WSYNC
    REPEND
    lda #0
    sta VSYNC


    lda P0XPos     ; load register A with desired X position
    and #$7F       ; AND position with $7F to fix range
    sta WSYNC      ; wait for next scanline
    sta HMCLR      ; clear old horizontal position values

    sec            ; set carry flag before subtraction
DivideLoop:
    sbc #15        ; subtract 15 from the accumulator
    bcs DivideLoop ; loop while carry flag is still set

    eor #7         ; adjust the remainder in A between -8 and 7
    asl            ; shift left by 4, as HMP0 uses only 4 bits
    asl
    asl
    asl
    sta HMP0       ; set fine position
    sta RESP0      ; reset 15-step brute position
    sta WSYNC      ; wait for next scanline
    sta HMOVE 

    REPEAT 35
        sta WSYNC
    REPEND 
    lda #0
    sta VBLANK
    

    ldy #17         ; counter to draw 17 rows of player0 bitmap
DrawBitmap:
    lda P0Bitmap,Y ; load player bitmap slice of data
    sta GRP0       ; set graphics for player 0 slice

    lda P0Color,Y  ; load player color from lookup table
    sta COLUP0     ; set color for player 0 slice

    sta WSYNC      ; wait for next scanline

    dey
    bne DrawBitmap 
    
    lda #0
    sta GRP0       ; disable P0 bitmap graphics

    lda #$FF       ; enable grass playfield
    sta PF0
    sta PF1
    sta PF2

    REPEAT 15
        sta WSYNC  ; wait for remaining 15 empty scanlines
    REPEND

    lda #0         ; disable grass playfield
    sta PF0
    sta PF1
    sta PF2

Overscan:
    lda #2
    sta VBLANK
    REPEAT 30
       sta WSYNC
    REPEND

CheckP0Up:
    lda #%00010000
    bit SWCHA
    bne CheckP0Down
    inc P0XPos

CheckP0Down:
    lda #%00100000
    bit SWCHA
    bne CheckP0Left
    dec P0XPos

CheckP0Left:
    lda #%01000000
    bit SWCHA
    bne CheckP0Right
    dec P0XPos

CheckP0Right:
    lda #%10000000
    bit SWCHA
    bne NoInput
    inc P0XPos

NoInput:
    ; fallback when no input was performed

   ; dec playerYpos

    jmp StartFrame

P0Bitmap:
    byte #%00000000
    byte #%00100100
    byte #%00100100
    byte #%01011010
    byte #%01011010
    byte #%01111110
    byte #%00011000
    byte #%00111100
    byte #%00111100

P0Color:
    byte #$00
    byte #$08
    byte #$08
    byte #$63
    byte #$63
    byte #$63
    byte #$EF
    byte #$EF
    byte #$00

    org $FFFC
    word Reset
    word Reset