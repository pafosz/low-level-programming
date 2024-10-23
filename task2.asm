%include "io64_float.inc"

section .rodata
    x: dd 60.0
    n: equ 15

    
section .bss
    y: resd 1
 
section .text
    global main
    
    ; jpu
    fpu_cos:
        fld dword[x]
        fcos
        fstp dword[y]
        ret
        
    
    factorial:
        ; if n == 0, return 1
        cmp rdi, 0
        je .base_case
        
        ; rdi > 0, recursive
        push rdi
        sub rdi, 1
        call factorial
        pop rdi
        
        imul rax, rdi ; rax = n * (n-1)!
        ret
        
    .base_case:
        mov rax, 1
        ret
        
    ; sse
    sse_cos:
        ; cos(x) = a0 - x^2/2! + x^4/4! - x^6/6! + x^8/8! - x^10/10! + ...
        xor rdi, rdi ; i = 0
        movss xmm1, xmm0 ; xmm1 = x
        mov rax, 1 ; a0 = 1
        cvtsi2ss xmm2, rax    ; xmm2 = a0 (1.0)
        
    .loop:
        ; Вычислим x^(2*i)
        mulss xmm1, xmm1
        call factorial
        cvtsi2ss xmm3, rax    ; xmm3 = (2*i)!
                
        divss xmm1, xmm3 ; xmm1 = x^(2*i) / (2*i)!
        
        test rdi, 1
        jz .add
        
        subss xmm2, xmm1 ; a0 -= x^(2*i) / (2*i)!
        jmp .next
        
    .add:        
        addss xmm2, xmm1 ; a0 += x^(2*i) / (2*i)!
        
    .next:
        add rsi, 1
        cmp rdi, n 
        jl .loop
        
        movss xmm0, xmm2
        ret
        
    main:
        PRINT_STRING "Result FPUx87: "
        call fpu_cos
        movss xmm0, [y]                
        PRINT_FLOAT xmm0
        NEWLINE
        
        PRINT_STRING "Result SSE: "
           
        movss xmm0, dword[x]
        mov rax, 5
        PRINT_FLOAT xmm0
        cvtsi2ss xmm0, rax
        PRINT_FLOAT xmm0
        
       ; call sse_cos       
       ; PRINT_FLOAT xmm0
                   
        
        ret