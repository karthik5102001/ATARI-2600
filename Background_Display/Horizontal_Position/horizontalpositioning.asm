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

    ldx #$00
    stx COLUBK

    lda #50
    sta P0xPos
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
;    
;
    lda P0xPos  ;loading the A value to P0xPOS
    and #$7F    ;ANDing the value A to 7F so that the output wont be in negative form

    sec 

    sta WSYNC
    sta HMCLR   ;clearing the horizontal line
         
Divideloop:
    sbc #15
    bcs Divideloop

    eor #7
    asl
    asl
    asl
    asl
    sta HMP0
    sta RESP0
    sta WSYNC
    sta HMOVE
    REPEAT 35
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK
    REPEAT 60
        sta WSYNC
    REPEND

    ldy 8
DrawBitmap:
    lda P0Bitmap,Y
    sta GRP0

    lda P0Color,Y
    sta COLUP0

    sta WSYNC

    dey
    bne DrawBitmap

    lda #0
    sta GRP0

    REPEAT 124
        sta WSYNC
    REPEND
Overscan:
    lda #2
    sta VBLANK
    REPEAT 30
    sta WSYNC
    REPEND
        
    ;inc P0xPos

    lda P0xPos
    cmp #80
    bpl resetXpos
    jmp incXpos
resetXpos:
    lda #40
    sta P0xPos
incXpos:
    inc P0xPos    
    
    jmp StartFrame
P0Bitmap:
    byte #%00000000        
    byte #%00010000
    byte #%00001000
    byte #%00011100
    byte #%00110110
    byte #%00101110
    byte #%00101110
    byte #%00111110
    byte #%00011100

P0Color:
    byte #$00
    byte #$02
    byte #$02
    byte #$52
    byte #$52
    byte #$52
    byte #$52
    byte #$52
    byte #$52

    org $FFFC
    word Reset
    word Reset