; Main file for the Assembly LS
%include "include/ls.inc"

; Dir functions utils
    extern opendir
    extern readdir
    extern strlen

; ------------------ RODATA ------------------
section .rodata

    current_path: db ".", 0x00
    new_line: db 0x0a, 0x00

    finished_read: db 0x0a, "LS just finished to read the directory.", 0x0a, 0x00
    finished_read_len equ $-finished_read - 1

    readdir_fail: db "readdir: Failed.", 0x0a, 0x00
    readdir_fail_len equ $-readdir_fail - 1

; ------------------- DATA -------------------
section .data
    option_flags: db 0x00

; ------------------- TEXT -------------------
section .text

    global _start

; Entry point of the program
_start:

    ; Prologue of function
    push rbp
    mov rbp, rsp

    mov rdi, [rbp + 8]		; ARGC
    lea rsi, [rbp + 16]		; ARGV
    ; Calling the parse options function
    call parse_options

    ; Calling the read to the current directory
    call read_current_dir

    ; Finished LS
    jmp QUIT_PROGRAM

; Quit program with exit 0
QUIT_PROGRAM:
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall

; Quit program with exit 1
QUIT_PROGRAM_FAIL:
    mov rax, SYS_EXIT
    mov rdi, 1
    syscall





; ----------------------------------------
; void parse_options(int argc, char **argv)
;
; Parameters:
;   rdi - int argc
;   rsi - char **argv
;
; ----------------------------------------
parse_options:
    push rbp
    mov rbp, rsp

    mov r15, rdi		; ARGC
    mov r14, [rsi]		; ARGV[0]
    
    xor rcx, rcx
    
    jmp .PARSE_SINGLE_OPTION

.PARSE_SINGLE_OPTION:
    cmp byte [r14], ASCII_DASH
    jne .PARSE_GO_NEXT
    cmp byte [r14 + 1], ASCII_A
    jne .PARSE_GO_NEXT
    or byte [option_flags], A_OPTION
    jmp .PARSE_END

.PARSE_GO_NEXT:
    inc rcx
    add rsi, 8			; Add 8 bytes ( pointer size )
    mov r14, [rsi]
    cmp rcx, r15
    je .PARSE_END
    jmp .PARSE_SINGLE_OPTION

.PARSE_END:
    leave
    ret





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

    sub rsp, 4096		; Variable buffer

    ; Calling an opendir function
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
    mov r13, rax		; Size read

    cmp rax, FAIL_SYS		; Verify error when readdir (FAIL_SYS = -1, rax = 0 = Empty)
    je QUIT_PROGRAM_FAIL
    test rax, rax
    jz QUIT_PROGRAM_FAIL

    ; Print the content of the directory, a file by line
    lea rdi, [rbp - 4096]
    mov rsi, r13
    call print_dir_content

    jmp QUIT_PROGRAM

.READ_FAILED:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, readdir_fail
    mov rdx, readdir_fail_len
    syscall
    jmp QUIT_PROGRAM_FAIL

.READ_FINISHED:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, finished_read
    mov rdx, finished_read_len
    syscall
    jmp QUIT_PROGRAM





; ----------------------------------------
; int print_dir_content(struct linux_dirent64 *dirp, int size_dirp)
;
; Parameters:
;   rdi - struct linux_dirent64 *dirp
;   rsi - int size_dirp
;
; Returns:
;   rax - int
; ----------------------------------------
print_dir_content:
    push rbp
    mov rbp, rsp

    ; Store the buffer into r8 and start printing
    lea r8, [rdi]
    lea r9, [rdi + rsi]

.LOOP_PRINT_DIR_CONTENT:
    ; Did we hit the end of the buffer
    cmp r8, r9
    jge .LOOP_DONE_PRINT_DIR_CONTENT
    ; There is no more information or still
    mov rdx, qword [r8]
    test rdx, rdx
    jz .LOOP_DONE_PRINT_DIR_CONTENT

    ; Get the length of the string d_name and put it on RDX
    lea rdi, [r8 + D_NAME]
    call strlen
    mov rdx, rax

    movzx rax, byte [r8 + D_NAME]
    cmp rax, ASCII_DOT
    jne .PRINT_FILE
    test byte [option_flags], A_OPTION
    jnz .PRINT_FILE
    jmp .LOOP_NEXT_FILE

.PRINT_FILE:
    ; Print the file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [r8 + D_NAME]
    syscall

    ; Print newline
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, new_line
    mov rdx, 1
    syscall
    jmp .LOOP_NEXT_FILE

.LOOP_NEXT_FILE:
    movzx rcx, word [r8 + D_RECLEN]
    add r8, rcx

    jmp .LOOP_PRINT_DIR_CONTENT

.LOOP_DONE_PRINT_DIR_CONTENT:
    leave
    ret
