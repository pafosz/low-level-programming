%include "io64.inc"

section .rodata
    fmtu: db "%u", 0
    fmt: db "%i ", 0
    space: db ' ', 0 ; ?? rodata   

CEXTERN malloc
CEXTERN prinf
CEXTERN scanf
CEXTERN free


section .text

global main
main:
    ;   ECX - index
    ;   R8D - number of array elements
    ;   R9D - left border
    ;   R10D - right border
    ;   EAX - array[index]
    ;   EBX - array[index +- 1]
    ;   R11D - last swap
    ;   rsi - buffer    
   
    push ebp
    mov ebp, esp
    
    sub esp, 8+32+8
    
    lea ecx, [fmtu] 
    lea edx, [rbp-4]
    xor rax, rax
    xor r12, r12
    call scanf
    mov r12d, dword[rbp-4]
    
    lea rcx, [r12*4]
    ;mov rcx, r12
    ;shl rcx, 2
    call malloc
    lea rsi, [rax]   
    
    xor edi, edi
    
.cycle1_start:
    cmp rdi, r12 
    je .cycle1_end    
    
    lea rcx, [fmt]
    lea rdx, [rbp-4]
    xor rax, rax
    call scanf
    
    mov rbx, [rbp-4]
    mov [rsi + 4*rdi], ebx 
    
    add edi, 1
    jmp .cycle1_start
    
.cycle1_end:
    xor r9d, r9d
    mov r10d, r12d
    sub r10d, 1
    xor r11, r11
    xor rdi, rdi
    
.cycle2_start:
    cmp r9d, r10d ; if (left border == right border)
    je .cycle2_end ; Jump if Equal  
    
    xor rdi, rdi
    
.cycle2d1_start:
    cmp edi, r10d ; while (index != right border)
    je .cycle2d1_end
    
    mov eax, [rsi + 4*rdi]
    mov ebx, [rsi + 4*rdi + 4]
    
    cmp ebx, eax
    jge .next1 ; <- unsigned? jae
    
    mov [rsi + 4*rdi], ebx
    mov [rsi + 4*rdi + 4], eax
    mov r11d, edi    

.next1:
    add edi, 1 
    jmp .cycle2d1_start
    
.cycle2d1_end:

    mov r10d, r11d
    mov edi, r10d
    
.cycle2d2_start:
    cmp edi, r9d
    je .cycle2d2_end
    
    mov eax, [rsi + 4*(rdi)]
    mov ebx, [rsi + 4*rdi-4]
    
    cmp eax, ebx
    jge .next2
    
    mov [rsi + 4*(rdi)], ebx
    mov [rsi + 4*(rdi-1)], eax
    mov r11d, edi
    
.next2:
    sub edi, 1
    jmp .cycle2d2_start
    
.cycle2d2_end:

    mov r9d, r11d
    mov edi, r9d
       
    jmp .cycle2_start
    
.cycle2_end:

    xor rdi, rdi
   
.print_loop:
    cmp rdi, r12
    je .end_print
    lea rcx, [fmt]
    mov rdx, [rsi + 4*rdi]
    
    xor rax, rax
    call printf
    inc rdi
    jmp .print_loop
    
.end_print:

    lea rcx, [rsi]
    call free
    leave
    
    xor rax, rax    
    
    ret