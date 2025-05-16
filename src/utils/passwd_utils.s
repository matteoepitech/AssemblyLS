; Passwd utils for Assembly LS
%include "include/ls.inc"

    extern get_nmbr
    extern get_line
    extern QUIT_PROGRAM_FAIL
    extern strlen_char_n
    extern strlen_char
    extern put_nmbr
    extern print_debug

; ------------------ RODATA ------------------
section .rodata

semicolon: db 58
    etc_passwd_path: db "/etc/passwd", 0x00
    etc_group_path: db "/etc/group", 0x00

; ------------------- TEXT -------------------
section .text

    global get_gid_name
    global get_uid_name

; ----------------------------------------
; char *get_uid_name(int uid)
;
; Parameters:
;   rdi - int uid
;
; Returns:
;   rax - char *name
; ----------------------------------------
get_uid_name:
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    mov r15, rdi		; The UID
    mov rax, SYS_OPEN
    mov rdi, etc_passwd_path
    mov rsi, 0
    mov rdx, 0
    syscall
    test rax, rax
    js QUIT_PROGRAM_FAIL
    mov r12, rax

.FIND_THE_LINE_UID_OWNER:
    mov rdi, r12
    call get_line
    lea r10, [rax]
    
    test rax, rax
    jz .CLOSE_FD
    test al, al
    jz .CLOSE_FD

    mov rdi, r10
    mov r8, rdi
    mov al, byte [semicolon]
    movzx rsi, al
    mov rdx, 2
    call strlen_char_n

    lea r9, [r8 + rax]
    lea rdi, [r9]
    mov al, byte [semicolon]
    movzx rsi, al
    call strlen_char

    mov byte [r9 + rax], 0		; R9 is currently the buffer string
    lea rdi, [r9]
    call get_nmbr

    cmp rax, r15
    je .DONE_UID
    jmp .FIND_THE_LINE_UID_OWNER

.DONE_UID:
    mov rdi, r8
    mov al, byte [semicolon]
    movzx rsi, al
    call strlen_char

    mov byte [r8 + rax], 0		; R9 is currently the buffer string
    mov r9, r8

.CLOSE_FD:
    mov rax, SYS_CLOSE
    mov rdi, r12
    syscall
    mov rax, r9
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    ret





; ----------------------------------------
; char *get_gid_name(int gid)
;
; Parameters:
;   rdi - int gid
;
; Returns:
;   rax - char *name
; ----------------------------------------
get_gid_name:
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    mov r15, rdi		; The GID
    mov rax, SYS_OPEN
    mov rdi, etc_group_path
    mov rsi, 0
    mov rdx, 0
    syscall
    test rax, rax
    js QUIT_PROGRAM_FAIL
    mov r12, rax

.FIND_THE_LINE_GID_OWNER:
    mov rdi, r12
    call get_line
    lea r10, [rax]
    
    test rax, rax
    jz .CLOSE_FD
    test al, al
    jz .CLOSE_FD

    mov rdi, r10
    mov r8, rdi
    mov al, byte [semicolon]
    movzx rsi, al
    mov rdx, 2
    call strlen_char_n

    lea r9, [r8 + rax]
    lea rdi, [r9]
    mov al, byte [semicolon]
    movzx rsi, al
    call strlen_char

    mov byte [r9 + rax], 0		; R9 is currently the buffer string
    lea rdi, [r9]
    call get_nmbr

    cmp rax, r15
    je .DONE_GID
    jmp .FIND_THE_LINE_GID_OWNER

.DONE_GID:
    mov rdi, r8
    mov al, byte [semicolon]
    movzx rsi, al
    call strlen_char

    mov byte [r8 + rax], 0		; R9 is currently the buffer string
    mov r9, r8

.CLOSE_FD:
    mov rax, SYS_CLOSE
    mov rdi, r12
    syscall
    mov rax, r9
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    ret
