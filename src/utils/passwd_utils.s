; Passwd utils for Assembly LS
%include "include/ls.inc"

; ------------------- TEXT -------------------
section .text

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
    push rax
    push rdi
    push rsi
    push rdx



    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
