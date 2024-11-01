%include "io64_float.inc"

; log2(tg(x+a)) = b
; tg(x+a)=2^b
; x + a = arctg(2^b)
; x = arctg(2^b) - a
; 2 b ^ arctg a -
section .rodata
    a: dd 0.0838
    b: dd 4.0
    
section .text
global main
main:
    fld 2