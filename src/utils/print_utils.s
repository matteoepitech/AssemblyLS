; Print utils for Assembly LS
%include "include/ls.inc"

; ------------------- TEXT -------------------
section .text

    global put_nmbr

; ----------------------------------------
; void put_nmbr(int number)
;
; Parameters:
;   rdi - int number
;
; ----------------------------------------
put_nmbr:
    push rbp
    mov rbp, rsp

    push rax
    push rdi
    push rsi
    push rdx

    xor rax, rax
    push rax		; Used for the write syscall (pointer to the char)

    mov r14, rdi	; = number
    mov r15, 1		; = tmp_multiplier

.CHECK_MULTIPLY_TMP:
    mov rax, r15
    mov rcx, 10
    mul rcx		; rax = r15 * 10
    cmp rax, r14
    jg .PRINT_DIGIT
    mov r15, rax
    jmp .CHECK_MULTIPLY_TMP

.PRINT_DIGIT:
    cmp r15, 0
    jle .PRINT_DONE

    xor rdx, rdx
    mov rax, r14
    div r15		; rax = rax / r15, rdx = r14 % r15
    mov r14, rdx

    add al, '0'
    mov [rsp], al
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [rsp]
    mov rdx, 1
    syscall

    mov rax, r15
    mov rcx, 10
    xor rdx, rdx
    div rcx		; r15 = r15 / 10
    mov r15, rax
    jmp .PRINT_DIGIT

.PRINT_DONE:
    mov al, 10
    mov [rsp], al
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [rsp]
    mov rdx, 1
    syscall
    pop rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
    leave
    ret

