%include "io64.inc"

section .data
space db ' ', 0

section .bss
array: resd 100

section .text
global main
main:

    GET_UDEC 4, r8d
    
    xor ecx, ecx
    
.cycle1_start:

    cmp ecx, r8d
    je .cycle1_end
    
    GET_DEC 4, [array + 4*ecx]
    add ecx, 1
    jmp .cycle1_start
    
.cycle1_end:

    xor r9d, r9d
    mov r10d, r8d
    sub r10d, 1
    xor r11, r11
    xor ecx, ecx
.cycle2_start:
    cmp r9d, r10d
    je .cycle2_end ; Jump if Equal  
    
    xor ecx, ecx
    
.cycle2d1_start:
    cmp ecx, r10d
    je .cycle2d1_end
    
    mov eax, [array + 4*ecx]
    mov ebx, [array + 4*ecx + 4]
    
    cmp ebx, eax
    jge .next1
    
    mov [array + 4*ecx], ebx
    mov [array + 4*ecx + 4], eax
    mov r11d, ecx    

.next1:
    inc ecx
    jmp .cycle2d1_start
    
.cycle2d1_end:

    mov r10d, r11d
    mov ecx, r10d
    
.cycle2d2_start:
    cmp ecx, r9d
    je .cycle2d2_end
    
    mov eax, [array + 4*(ecx)]
    mov ebx, [array + 4*(ecx-1)]
    
    cmp eax, ebx
    jge .next2
    
    mov [array + 4*(ecx)], ebx
    mov [array + 4*(ecx-1)], eax
    mov r11d, ecx
    
.next2:
    dec ecx
    jmp .cycle2d2_start
    
.cycle2d2_end:

    mov r9d, r11d
    mov ecx, r9d
       
    jmp .cycle2_start
    
.cycle2_end:

    xor ecx, ecx
    
.print_loop:
    cmp ecx, r8d
    je .end_print
    mov eax, [array + 4*ecx]
    PRINT_DEC 4, eax
    PRINT_STRING [space]
    inc ecx  
    jmp .print_loop
.end_print:
    
    ret


