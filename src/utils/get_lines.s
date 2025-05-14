; -------------------------------------------------------
; GetLine utils for Assembly LS
%include "include/ls.inc"

    extern put_nmbr
    extern strlen
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
    saved_fd: dd 0
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

    cmp rdi, [saved_fd]
    jne .MODIFY_FD
    jmp .CONTINUE_GET_LINE

.MODIFY_FD:
    mov [saved_fd], rdi

.CONTINUE_GET_LINE:
    xor rax, rax
    xor rbx, rbx
    xor rdx, rdx
    xor rsi, rsi
    xor rcx, rcx
    xor r8, r8
    xor r9, r9
    xor r10, r10
    xor r11, r11
    mov rax, SYS_READ
    mov rsi, buffer_get_line
    mov rdx, 4096
    syscall

    xor r11, r11
    mov r11d, [stream_index_get_line]
    cmp r11, 4096
    jge .GET_LINES_DONES

    lea rdi, [buffer_get_line + r11]
    movzx rsi, byte [newline]
    call strlen_char
    mov r8, rax

    lea rdi, [line_get_line]
    mov rsi, 256
    call reset_buffer

    lea rdi, [line_get_line]
    lea rsi, [buffer_get_line + r11]
    mov rdx, r8
    call strncpy			; Result of the get_line into rax

    add [stream_index_get_line], rax
    add dword [stream_index_get_line], 1

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





; ----------------------------------------
; void reset_buffer(char *buffer, size_t size_buffer)
;
; Paramaters:
;   rdi - char *buffer
;   rsi - size_t buffer
;
; ----------------------------------------
reset_buffer:
    push rbp
    mov rbp, rsp

    xor rcx, rcx
    cmp rcx, rsi
    jge .RESET_BUFFER_DONE
    jmp .RESET_BUFFER_CYCLE

.RESET_BUFFER_CYCLE:
    mov byte [rdi + rcx], 0x00
    inc rcx
    cmp rcx, rsi
    jge .RESET_BUFFER_DONE
    jmp .RESET_BUFFER_CYCLE

.RESET_BUFFER_DONE:
    leave
    ret
