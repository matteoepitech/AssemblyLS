; Main file for the Assembly LS
%include "include/ls.inc"

; Dir functions utils
    extern opendir
    extern readdir

; ------------------ RODATA ------------------
section .rodata

    current_path: db ".", 0x00

    finished_read: db 0x0a, "LS just finished to read the directory.", 0x0a, 0x00
    finished_read_len equ $-finished_read - 1

    readdir_fail: db "readdir: Failed.", 0x0a, 0x00
    readdir_fail_len equ $-readdir_fail - 1

; ------------------- TEXT -------------------
section .text

    global _start

; Entry point of the program
_start:

    ; Prologue of function
    push rbp
    mov rbp, rsp

    call read_current_dir

    ; Finished LS
    jmp QUIT_PROGRAM

; Quit program with exit 0
QUIT_PROGRAM:
    mov rax, SYS_EXIT
    xor rdi, rdi
    leave
    syscall

; Quit program with exit 1
QUIT_PROGRAM_FAIL:
    mov rax, SYS_EXIT
    mov rdi, 1
    leave
    syscall

; ----------------------------------------
; int read_current_dir(void)
;
; Returns:
;   rax - int
; ----------------------------------------
read_current_dir:

    ; Prologue of function
    push rbp
    mov rbp, rsp

    sub rsp, 4096   ; Variable buffer

    ; Calling an opendir
    lea rdi, [rel current_path]
    call opendir

    ; Verify error when opendir (FAIL_SYS = -1 = Failed to open the dir)
    cmp rax, FAIL_SYS
    je .READ_FAILED

    ; Calling an readdir
    mov rdi, rax		; FD from opendir
    lea rsi, [rbp - 4096]	; Buffer variable
    mov rdx, 4096		; 4096 buffer length
    call readdir
    
    ; Verify error when readdir (FAIL_SYS = -1, rax = 0 = Empty)
    cmp rax, FAIL_SYS
    je QUIT_PROGRAM_FAIL
    test rax, rax
    jz QUIT_PROGRAM_FAIL

    jmp .READ_FINISHED

.READ_FAILED:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, readdir_fail
    mov rdx, readdir_fail_len
    syscall
    ; Jump to exit the program with fail
    jmp QUIT_PROGRAM_FAIL

.READ_FINISHED:
    ; Say we just finished the readding of the directory
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, finished_read
    mov rdx, finished_read_len
    syscall
    ; Jump to exit the program
    jmp QUIT_PROGRAM
