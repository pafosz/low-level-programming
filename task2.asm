%include "io64_float.inc"

section .rodata  
      
    minus_one: dd -1.0
    one: dd 1.0
    two: dd 2.0
    three: dd 3.0
    loop_count: dd 4
    
section .bss
    y: resd 1
 
section .text
    global main 
    
    cal_cos:
        movss xmm1, [one] ;1
        movss xmm2, xmm0 ;x
        mulss xmm2, xmm2 ;x^2
        divss xmm2, [two] ;x^2/2
        mulss xmm2, [minus_one] ;-x^2/2
        addss xmm1, xmm2 ;1 - x^2/2
        movss xmm3, [two]
        mov ecx, [loop_count]
        mov ebx, 1
        cvtsi2ss xmm15, ebx ; 1
        neg ebx
        cvtsi2ss xmm14, ebx ; -1
         
        
    loop:
        mulss xmm2, xmm0 ;-x^3/2!
        mulss xmm2, xmm0 ;-x^4/2!
        addss xmm3, xmm15 ; + 1 = 3
        divss xmm2, xmm3 ;-x^4/(3!)
        addss xmm3, xmm15 ; + 1 = 3
        divss xmm2, xmm3 ;-x^4/(4!)
        mulss xmm2, xmm14
        addss xmm1, xmm2
        sub ecx, 1
        jnz loop
        ret         
        
    main:
    
        mov rbp, rsp
        READ_FLOAT xmm0
        
        call cal_cos
        
        PRINT_FLOAT xmm1
        
        xor rax, rax
        ret
        
    
