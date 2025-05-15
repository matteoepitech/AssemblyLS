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
    buffer_size_get_line: dd 0
    bytes_in_buffer: dd 0

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
    push rbx
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11

    cmp rdi, [saved_fd]
    jne .change_fd
    jmp .continue

.change_fd:
    mov [saved_fd], edi
    mov dword [stream_index_get_line], 0
    mov dword [buffer_size_get_line], 0

.continue:
    mov eax, [stream_index_get_line]
    cmp eax, [buffer_size_get_line]
    jl .process_line

    mov rax, SYS_READ
    mov rdi, [saved_fd]
    mov rsi, buffer_get_line
    mov rdx, 4096
    syscall

    test rax, rax
    jle .eof

    mov [buffer_size_get_line], eax
    mov dword [stream_index_get_line], 0

.process_line:
    xor r11, r11
    mov r11d, [stream_index_get_line]
    lea rdi, [buffer_get_line + r11d]
    mov rsi, 10
    call strlen_char
    mov r8, rax

    lea rdi, [line_get_line]
    mov rsi, 256
    call reset_buffer

    lea rdi, [line_get_line]
    lea rsi, [buffer_get_line + r11d]
    mov rdx, r8
    call strncpy

    add r11d, r8d
    inc r11d
    mov [stream_index_get_line], r11d

    lea rax, [line_get_line]
    jmp .done

.eof:
    xor rax, rax

.done:
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
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
    ret
