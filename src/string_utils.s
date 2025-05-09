; String utils for Assembly LS
%include "include/ls.inc"

; ------------------- TEXT -------------------
section .text

    global strlen

; ----------------------------------------
; int strlen(const char *string)
;
; Parameters:
;   rdi - const char *string
;
; Returns:
;   rax - int
; ----------------------------------------
strlen:
    ret
