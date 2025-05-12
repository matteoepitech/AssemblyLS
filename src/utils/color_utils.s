; Color utils for Assembly LS
%include "include/ls.inc"

; ------------------ RODATA ------------------
section .rodata
    color_blue: db 0x1b, "[0;94m", 0x00
    color_blue_len equ $ - color_blue - 1

    color_reset: db 0x1b, "[0m", 0x00
    color_reset_len equ $ - color_reset - 1

; ------------------- TEXT -------------------
section .text

    global write_blue
    global reset_color

; ----------------------------------------
; void write_blue(void)
; ----------------------------------------
write_blue:
    push rax
    push rdi
    push rsi
    push rdx
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [rel color_blue]
    mov rdx, color_blue_len
    syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret





; ----------------------------------------
; void reset_color(void)
; ----------------------------------------
reset_color:
    push rax
    push rdi
    push rsi
    push rdx
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [rel color_reset]
    mov rdx, color_reset_len
    syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
