; String utils for Assembly LS
%include "include/ls.inc"

; ------------------- TEXT -------------------
section .text

    global strlen

; ----------------------------------------
; int strlen(const char *string)
;
; Parameters:
;   rdi - const char *string
;
; Returns:
;   rax - int
; ----------------------------------------
strlen:
    xor rcx, rcx
    jmp .LOOP_STRLEN

.LOOP_STRLEN:
    movzx rax, byte [rdi]
    test rax, rax
    jz .LOOP_DONE
    inc rcx
    inc rdi
    jmp .LOOP_STRLEN

.LOOP_DONE:
    mov rax, rcx
    ret
