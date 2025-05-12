; Main file for the Assembly LS
%include "include/ls.inc"

; Dir functions utils
    extern opendir
    extern readdir
    extern strlen
    extern put_nmbr
    extern write_blue
    extern reset_color

; ------------------ RODATA ------------------
section .rodata

    current_path: db ".", 0x00
    new_line: db 0x0a, 0x00
    new_space: db 0x20, 0x20, 0x00
    tmp_rights: db "---------", 0x00

    finished_read: db 0x0a, "LS just finished to read the directory.", 0x0a, 0x00
    finished_read_len equ $-finished_read - 1

    readdir_fail: db "readdir: Failed.", 0x0a, 0x00
    readdir_fail_len equ $-readdir_fail - 1

; ------------------- DATA -------------------
section .data
    option_flags: db 0x00
    fd_opendir: dq 0

; ------------------- BSS --------------------
section .bss
    stat_buffer: resb 144

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
    je .PARSE_A
    cmp byte [r14 + 1], ASCII_L
    je .PARSE_L
    jmp .PARSE_GO_NEXT

.PARSE_A:
    or byte [option_flags], A_OPTION
    jmp .PARSE_GO_NEXT

.PARSE_L:
    or byte [option_flags], L_OPTION
    jmp .PARSE_GO_NEXT

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
    mov [fd_opendir], rax

    ; Verify error when opendir (FAIL_SYS = -1 = Failed to open the dir)
    cmp rax, FAIL_SYS
    je .READ_FAILED

.read_current_dir_buffer:
    ; Calling an readdir
    mov rdi, [fd_opendir]	; FD from opendir
    lea rsi, [rbp - 4096]	; Buffer variable
    mov rdx, 4096		; 4096 buffer length
    call readdir    
    mov r13, rax		; Size read

    cmp rax, FAIL_SYS		; Verify error when readdir (FAIL_SYS = -1, rax = 0 = Empty)
    je QUIT_PROGRAM_FAIL
    test rax, rax
    jz QUIT_PROGRAM

    ; Print the content of the directory
    lea rdi, [rbp - 4096]
    mov rsi, r13
    mov r12, r13
    call print_dir_content

    jmp .read_current_dir_buffer

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
    jne .GET_FILE_STAT
    test byte [option_flags], A_OPTION
    jnz .GET_FILE_STAT
    jmp .LOOP_NEXT_FILE

.GET_FILE_STAT:
    ; Get the file information using stat()
    mov rax, SYS_STAT
    lea rdi, [r8 + D_NAME]
    lea rsi, [rel stat_buffer]
    syscall

    cmp rax, 0
    jl .PRINT_FILE_NAME
    jmp .PRINT_FILE

.PRINT_FILE_INFORMATIONS:
    call print_file_informations
    jmp .PRINT_FILE_NAME_COLORS

.PRINT_FILE:
    test byte [option_flags], L_OPTION
    jnz .PRINT_FILE_INFORMATIONS
    jmp .PRINT_FILE_NAME_COLORS

.PRINT_DIR_COLOR:
    call write_blue
    jmp .PRINT_FILE_NAME
    
.PRINT_REGFILE_COLOR:
    call reset_color
    jmp .PRINT_FILE_NAME

.PRINT_FILE_NAME_COLORS:
    mov eax, dword [stat_buffer + ST_MODE]
    and eax, S_IFMT
    cmp rax, S_IFDIR
    je .PRINT_DIR_COLOR
    jmp .PRINT_REGFILE_COLOR

.PRINT_FILE_NAME:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [r8 + D_NAME]
    mov rdi, rdi
    syscall
    call reset_color
    jmp .LOOP_NEXT_FILE


.PRINT_NEW_LINE_FILE:
    ; Print newline
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, new_line
    mov rdx, 1
    syscall
    jmp .LOOP_PRINT_DIR_CONTENT

.PRINT_NEW_SPACE_FILE:
    ; Print new space
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, new_space
    mov rdx, 2
    syscall
    jmp .LOOP_PRINT_DIR_CONTENT

.LOOP_NEXT_FILE:
    movzx rcx, word [r8 + D_RECLEN]
    add r8, rcx

    ; Did we hit the end of the buffer
    cmp r8, r9
    jge .LOOP_DONE_PRINT_DIR_CONTENT
    ; There is no more information or still
    mov rdx, qword [r8]
    test rdx, rdx
    jz .LOOP_DONE_PRINT_DIR_CONTENT

    movzx rax, byte [r8 + D_NAME]
    cmp rax, ASCII_DOT
    jne .CHOOSE_SPACE_LAYOUT
    test byte [option_flags], A_OPTION
    jz .LOOP_PRINT_DIR_CONTENT
    jmp .CHOOSE_SPACE_LAYOUT

.CHOOSE_SPACE_LAYOUT:
    test byte [option_flags], L_OPTION
    jnz .PRINT_NEW_LINE_FILE
    jmp .PRINT_NEW_SPACE_FILE

.LOOP_DONE_PRINT_DIR_CONTENT:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, new_line
    mov rdx, 1
    syscall
    leave
    ret





; ----------------------------------------
; void print_file_informations(void)
; ----------------------------------------
print_file_informations:
    push rbp
    mov rbp, rsp
    push rax
    push rdi
    push rsi
    push rdx
    
    mov eax, dword [stat_buffer + ST_MODE]
    and eax, S_IFMT
 
    cmp rax, S_IFDIR
    je .FILE_TYPE_D
    jmp .FILE_TYPE_REG

.FILE_TYPE_D:
    push rax
    mov byte [rsp], ASCII_D
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax
    jmp .PRINT_RIGHTS

.FILE_TYPE_REG:
    push rax
    mov byte [rsp], ASCII_DASH
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax
    jmp .PRINT_RIGHTS

.PRINT_RIGHTS:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, tmp_rights
    mov rdx, 9
    syscall
    jmp .PRINT_SPACE_AFTER_RIGHTS

.PRINT_SPACE_AFTER_RIGHTS:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, new_space
    mov rdx, 1
    syscall

.PRINT_NBLINKS:
    mov rdi, qword [stat_buffer + ST_NLINK]
    call put_nmbr

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, new_space
    mov rdx, 1
    syscall

.PRINT_FILE_INFORMATIONS_DONE:
    pop rdx
    pop rsi
    pop rdi
    pop rax
    leave
    ret
