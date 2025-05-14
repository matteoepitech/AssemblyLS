; String utils for Assembly LS
%include "include/ls.inc"

; ------------------- TEXT -------------------
section .text

    global strlen
    global strlen_char
    global strlen_char_n
    global strncpy
    global strcmp
    global strncmp

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





; ----------------------------------------
; int strlen_char(const char *string, char c)
;
; Parameters:
;   rdi - const char *string
;   rsi - char c
;
; Returns:
;   rax - int
; ----------------------------------------
strlen_char:
    xor rcx, rcx
    jmp .LOOP_STRLEN

.LOOP_STRLEN:
    test rdi, rdi
    jz .LOOP_DONE
    movzx rax, byte [rdi]
    test rax, rax
    jz .LOOP_DONE
    cmp rax, rsi
    je .LOOP_DONE
    inc rcx
    inc rdi
    jmp .LOOP_STRLEN

.LOOP_DONE:
    mov rax, rcx
    ret





; ----------------------------------------
; int strlen_char_n(const char *string, char c, size_t n)
;
; Parameters:
;   rdi - const char *string
;   rsi - char c
;   rdx - n
;
; Returns:
;   rax - int
; ----------------------------------------
strlen_char_n:
    xor rcx, rcx
    test rdi, rdi
    jz .LOOP_DONE

.LOOP_STRLEN_N:
    movzx rax, byte [rdi]
    test rax, rax
    jz .LOOP_DONE

    inc rcx
    cmp al, sil
    jne .NOT_C
    
    dec rdx
    jz .LOOP_DONE

.NOT_C:
    inc rdi
    jmp .LOOP_STRLEN_N

.LOOP_DONE:
    mov rax, rcx
    ret





; ----------------------------------------
; char *strncpy(char *dest, const char *src, size_t n)
;
; Parameters:
;   rdi - char *dest
;   rsi - const char *src
;   rdx - size_t n
;
; Returns:
;   rax - char *dest
; ----------------------------------------
strncpy:
    push rdi
    xor rcx, rcx
    jmp .LOOP_STRNCPY

.LOOP_STRNCPY:
    cmp rcx, rdx
    jge .LOOP_DONE
    movzx rax, byte [rsi]
    mov byte [rdi], al
    test rax, rax
    jz .PAD_ZEROS
    inc rcx
    inc rdi
    inc rsi
    jmp .LOOP_STRNCPY

.PAD_ZEROS:
    inc rcx
    inc rdi
    cmp rcx, rdx
    jge .LOOP_DONE
    mov byte [rdi], 0
    jmp .PAD_ZEROS

.LOOP_DONE:
    pop rax
    ret





; ----------------------------------------
; int strcmp(const char *s1, const char *s2)
;
; Parameters:
;   rdi - const char *s1
;   rsi - const char *s2
;
; Returns:
;   rax - int
; ----------------------------------------
strcmp:
    push rbx
    jmp .LOOP_STRCMP

.LOOP_STRCMP:
    movzx rax, byte [rdi]
    movzx rbx, byte [rsi]
    cmp rax, rbx
    jne .LOOP_DONE
    test rax, rax
    jz .LOOP_DONE
    inc rsi
    inc rdi
    jmp .LOOP_STRCMP

.LOOP_DONE:
    sub rax, rbx
    pop rbx
    ret





; ----------------------------------------
; int strncmp(const char *s1, const char *s2, size_t n)
;
; Parameters:
;   rdi - const char *s1
;   rsi - const char *s2
;   rdx - size_t n
;
; Returns:
;   rax - int
; ----------------------------------------
strncmp:
    push rbx
    jmp .LOOP_STRNCMP

.LOOP_STRNCMP:
    test rdx, rdx
    jz .LOOP_DONE
    movzx rax, byte [rdi]
    movzx rbx, byte [rsi]
    cmp rax, rbx
    jne .LOOP_DONE
    test rax, rax
    jz .LOOP_DONE
    inc rsi
    inc rdi
    dec rdx
    jmp .LOOP_STRNCMP

.LOOP_DONE:
    sub rax, rbx
    pop rbx
    ret
