; -------------------------------------------------------
; GetLine utils for Assembly LS
%include "include/ls.inc"

    extern put_nmbr
    extern strlen_char
    extern strncpy

; ------------------ RODATA ------------------
section .rodata
    newline: db 10

; ------------------- BSS --------------------
section .bss
    buffer_get_line: resb 4096
    line_get_line: resb 256

; ------------------- DATA--------------------
section .data
    stream_index_get_line: dd 0

; ------------------- TEXT -------------------
section .text

    global get_line

; ----------------------------------------
; char* get_line(int fd)
;
; Paramaters:
;   rdi - int fd
;
; Return:
;   rax - char *line
;
; ----------------------------------------
get_line:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11

    mov rax, SYS_READ
    mov rsi, buffer_get_line
    mov rdx, 4096
    syscall

    xor r11, r11
    mov r11, [stream_index_get_line]
    lea rdi, [buffer_get_line + r11]
    movzx rsi, byte [newline]
    call strlen_char
    mov r8, rax

    lea rdi, [line_get_line]
    lea rsi, [buffer_get_line + r11]
    mov rdx, r8
    call strncpy
    mov r9, rax

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, r9
    mov rdx, r8
    syscall

    mov rdi, rax
    call put_nmbr


.GET_LINES_DONES:
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbx
    leave
    ret
