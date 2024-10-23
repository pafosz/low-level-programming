%include "io64.inc"

section .rodata
    x: dd 2.1
    
section .bss
    result: resd 1
    
section .text
    global main
    
    fpu_set_round_toward_up:
        sub rsp, 8 ; выделяем 8 байт в стеке
        fstcw [rsp] ; сохраняем контрольное слово (проверяет на наличие отложенных необработанных исключений)
        mov al, [rsp+1] ; получим старшие 8 бит
        and al, 0xf3 ; сбросим значение поля RC на 0
        or al, 8 ; установим для поля RC значение 8 (округление вверх)
        mov [rsp+1], al
        fldcw [rsp] ; загрузим контрольное слово
        add rsp, 8 ; освободим место в стеке
        ret 
        
    sse_set_round_toward_up:
        movss xmm0, dword[x] ; Загружаем значение из памяти в xmm0
        roundss xmm0, xmm0, 2 ; 2 - округление вверх (по стандарту SSE)
        movss [result], xmm0 ; Сохраняем результат в памяти
        ret       
        
    main:
        fld dword[x]
        fist dword[result]
        mov eax, [result]        
        PRINT_DEC 4, eax
        NEWLINE
        
        PRINT_STRING "Result FPUx87: "
        call fpu_set_round_toward_up
        fist dword[result]
        mov eax, [result]
        PRINT_DEC 4, eax
        xor eax, eax
        NEWLINE
        
        PRINT_STRING "Result SSE: "
        call sse_set_round_toward_up
        cvtss2si eax, [result]
        PRINT_DEC 4, eax
        xor eax, eax
        ret
                            