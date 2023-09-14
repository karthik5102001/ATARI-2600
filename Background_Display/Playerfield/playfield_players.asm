     processor 6502
     include "vcs.h"
     include "macro.h"
     seg
     org $f000
RESET:
     CLEAN_START
     ldx #$80
     stx COLUBK
     lda #%1111
     sta COLUPF
     lda #$48
     sta COLUP0
     lda #$C6
     sta COLUP1

STARTFRAME:
     lda #02
     sta VSYNC
     sta VBLANK
     ; first vertical scanlines
     REPEAT 3
        sta WSYNC
     REPEND
     ;the vertical scanline
     lda #0
     sta VSYNC
     ;repeating the same for 37 times for vertical blank
     REPEAT 37
     sta WSYNC
     REPEND
     
     ;lda #0
     sta VBLANK
visiablescanline:
     REPEAT 10
      sta WSYNC
    REPEND
    ldy #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;for scoreboard display;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
Scoreboardloop:
     lda NUMBERBITMAP,y
     sta PF1
     sta WSYNC
     iny
     cpy #10
     bne Scoreboardloop
     lda #0
     sta PF1
     repeat 50
      sta WSYNC
      repend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;for players 0 displaying;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
     ldy #0       
playerdisplayloop:
     lda PlAYERSbitMAP,y
     sta GRP0
     sta WSYNC
     iny
     cpy #10
     bne playerdisplayloop
     sta GRP0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;for players 1 displaying;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
     ldy #0       
playerdisplayloop:
     lda PlAYERSbitMAP,y
     sta GRP1
     sta WSYNC
     iny
     cpy #10
     bne playerdisplayloop
     sta GRP1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 10 + 10 + 50 + 10 + 10 = 90;;;;;;;;;;;;;;;;;;;;;;
;;;;;;(192-90)=102 empty lines;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     repeat 102
     sta WSYNC
     repend    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; next for over scan as per NTSc frame set;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     lda #2
     sta VBLANK
     REPEAT 30
         sta WSYNC
     REPEND 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;player bit map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFE8
    PlAYERSbitMAP:
       .byte #%01111110
       .byte #%11111111
       .byte #%10011001
       .byte #%11111111
       .byte #%11111111
       .byte #%10111101
       .byte #%11000011
       .byte #%11111111
       .byte #%01111110
       .byte #%00000000
      
    org $FFF2
    NUMBERBITMAP:
       .byte #%00001110
       .byte #%00001110
       .byte #%00000010
       .byte #%00000010
       .byte #%00001110
       .byte #%00001110
       .byte #%00001000
       .byte #%00001000
       .byte #%00001110
       .byte #%00001110

     org $fffc
     .word RESET 
     .word RESET
      
       
       
       
       
       