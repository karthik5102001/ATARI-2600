     processor 6502
     include "vcs.h"
     include "macro.h"
     seg
     org $f000
RESET:
     CLEAN_START
     ldx #$80
     stx COLUBK
     lda #$1C
     sta COLUPF
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;setting the CTRLPF accordingly;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ldx #%00000001
     stx CTRLPF
     ldx #0
     stx PF0
     stx PF1
     stx PF2
     REPEAT 7
         sta WSYNC
     REPEND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;starting the basic lines for next 7 lines;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ldx #%11100000
     stx PF0
     ldx #%11111111
     stx PF1
     stx PF2
     REPEAT 7
         sta WSYNC
     REPEND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Starting the next lnes for battelfield;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ldx #%00100000
     stx PF0
     ldx #0
     stx PF1
     stx PF2
     REPEAT 164
          sta WSYNC
     REPEND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;same as above the 7 scanlines to render;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #%11101111
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
       sta WSYNC   ; repeat PF config for 7 scanlines
    REPEND

    ; Skip 7 vertical lines with no PF set
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; next for over scan as per NTSc frame set;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     lda #2
     sta VBLANK
     REPEAT 30
         sta WSYNC
     REPEND 
     
     jmp STARTFRAME
     org $fffc
     .word RESET 
     .word RESET
      
       
       
       
       
       