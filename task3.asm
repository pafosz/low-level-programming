;%include "io64_float.inc"

; log2(tg(x+a)) = b
; tg(x+a)=2^b
; x + a = arctg(2^b)
; x = arctg(2^b) - a
; ПОЛИЗ -> 2 b ^ arctg a -

section .bss
    x: resd 1
    
section .rodata
    a: dd 0.0838
    b: dd 4.0
    two: dd 2.0
    
section .text
global main
main:

    fld dword[b] ; st0 = b
    fld dword[two] ;st0 = 2 st1 = b
    
    fyl2x ;вычисляем показатель
    fld1 ;загружаем +1.0 в стек
    fld st1 ;дублируем показатель в стек
    fprem ;получаем дробную часть
    f2xm1 ;возводим в дробную часть показателя
    fadd ;прибавляем 1 из стека
    fscale ;возводим в целую часть и умножаем
    fstp st1 ; выталкиваем лишнее из стека
    
    fld1 ; st1 = 1
    fpatan ; st0 = arctan(st0/st1) = arctan(b^2/1) st1 = 0
    fld dword[a] ; st1 = a
    fsub ; st0 = st0 - st1 = arctan(b^2/1) - a    st1 = 0
    fstp dword[x] ; x = st0 = arctan(b^2/1) - a    st0 = 0
    ;PRINT_FLOAT [x] 
    xor rax, rax
    
    ret
    