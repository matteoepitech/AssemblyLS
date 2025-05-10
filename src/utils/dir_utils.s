; Dir utils for Assembly LS
%include "include/ls.inc"

; ------------------ DEFINES -----------------

%define FLAG_DIR (O_RDONLY | O_DIRECTORY)

; ------------------- TEXT -------------------
section .text

    global opendir
    global readdir

; ----------------------------------------
; int opendir(const char *pathname)
;
; Parameters:
;   rdi - const char *pathname
;
; Returns:
;   rax - int
; ----------------------------------------
opendir:
    mov rax, SYS_OPENAT
    mov rsi, rdi
    mov rdi, AT_FDCWD
    mov rdx, FLAG_DIR
    syscall
    ret

; ----------------------------------------
; int readdir(unsigned int fd, struct linux_dirent *dirp, unsigned int count)
;
; Parameters:
;   rdi - unsigned int fd
;   rsi - struct linux_dirent *dirp (buffer usually empty)
;   rdx - unsigned int count
;
; Returns:
;   rax - int
; ----------------------------------------
readdir:
    mov rax, SYS_GETDENTS64
    syscall
    ret
