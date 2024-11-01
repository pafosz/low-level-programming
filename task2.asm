%include "io64_float.inc"

section .rodata
    a0: dd 1.0
    x: dd 4.0
    double_pi: dd 6.283185307
    factorials: dd 2.0, 24.0, 720.0, 40320.0, 3628800.0, 479001600.0,

section .bss
    y: resd 1
 
section .text
    global main
    
    ; fpu
    fpu_cos:
        fld dword[x]
        fcos
        fstp dword[y]
        ret        
    
    ; sse
    sse_cos:        
    
        movss xmm0, [a0] ; a0 = 1
        movss xmm1, [x] ; cos(x) = a0 - x^2/2! + x^4/4! ... 
        movss xmm5, [double_pi] ; xmm5 = 2*pi
    .start:
        comiss xmm5, xmm1 ; 2*pi < x ?
        jb .end
        
        mulss xmm1, xmm1 ; xmm1 = x^2
        movss xmm2, xmm1 ; xmm2 = x^2
        movss xmm3, xmm2 ; xmm3 = x^2
        movss xmm4, [factorials] ; xmm4 = 2!
        divss xmm3, xmm4 ; x^2/2!
        subss xmm0, xmm3 ; 1 - x^2/2!
        
        mulss xmm2, xmm1 ; xmm2 = x^4
        movss xmm3, xmm2 ; xmm3 = x^4
        divss xmm3, [factorials + 4] ; x^4/4!
        addss xmm0, xmm3 ; 1 - x^2/2! + x^4/4!
        
        mulss xmm2, xmm1 ; xmm2 = x^6
        movss xmm3, xmm2 ; xmm3 = x^6
        divss xmm3, [factorials + 8] ; x^6/6!
        subss xmm0, xmm3 ; 1 - x^2/2! + x^4/4! - x^6/6!
        
        mulss xmm2, xmm1 ; xmm2 = x^8
        movss xmm3, xmm2 ; xmm3 = x^8
        divss xmm3, [factorials + 12] ; x^8/8!
        addss xmm0, xmm3 ; 1 - x^2/2! + x^4/4! - x^6/6! + x^8/8!
        
        mulss xmm2, xmm1 ; xmm2 = x^10
        movss xmm3, xmm2 ; xmm3 = x^10
        divss xmm3, [factorials + 16] ; x^10/10!
        subss xmm0, xmm3 ; 1 - x^2/2! + x^4/4! - x^6/6! + x^8/8! - x^10/10!
        
        mulss xmm2, xmm1 ; xmm2 = x^12
        movss xmm3, xmm2 ; xmm3 = x^12
        divss xmm3, [factorials + 20] ; x^12/12!
        addss xmm0, xmm3 ; 1 - x^2/2! + x^4/4! - x^6/6! + x^8/8! - x^10/10! + x^12/12!
        
        ret
        
    .end:
        subss xmm1, xmm5
        jmp .start
        
        
    main:
        PRINT_STRING "Result FPUx87: "
        call fpu_cos
        movss xmm0, [y]                
        PRINT_FLOAT xmm0
        NEWLINE
        
        PRINT_STRING "Result SSE: "
           
        movss xmm0, dword[x]
        
        call sse_cos
        PRINT_FLOAT xmm0
        
        mov rax, rax                                 
        
        ret