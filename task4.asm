%include "io64_float.inc"

; y = th(a/x)
; th(a/x) = sh(a/x)/ch(a/x) - гиперболический тангенс
; sh(a) = (e^(a/x) - e^(-a/x)) / 2 - гиперболический синус
; ch(a) = (e^a/x) + e^(-a/x) / 2 - гипорболический косинус
; y = ((e^(a/x) - e^(-a/x)) / (e^(a/x) + e^(-a/x)) / x = (e^(2a/x) - 1) / (e^(2a/x) + 1) 
; ПОЛИЗ -> a x / th
; b = 2 a * x / e ^ 
; y = b 1 - b 1 + / 
section .rodata
    a: dd 2.5
    e: dd 2.71828
    x: dd 5.0
    y: dd 0.46211 
    two: dd 2.0   
    
section .data
    b: dd 0.0
    result: dd 0.0
    
section .text
global main
main:
    fld dword[a]
    fld dword[two]
    fmul
    fld dword[x]
    fdiv
    fld dword[e]
    
    fyl2x ;вычисляем показатель
    fld1 ;загружаем +1.0 в стек
    fld st1 ;дублируем показатель в стек
    fprem ;получаем дробную часть
    f2xm1 ;возводим в дробную часть показателя
    fadd ;прибавляем 1 из стека
    fscale ;возводим в целую часть и умножаем
    fstp st1 ; выталкиваем лишнее из стека
    
    fstp dword[b]
    
    fld dword[b]
    fld1
    fsub
    fld dword[b]
    fld1
    fadd
    fdiv
    
    fstp dword[result]
    
    fld dword[y]
    fld dword[result]
    fcomip
    fstp st0
    je true
    jmp false
true:
    PRINT_DEC 4, 1
    jmp end
false:
    PRINT_DEC 4, 0
    jmp end

end:
    xor rax, rax
    ret
    
    
    
    
    
    
