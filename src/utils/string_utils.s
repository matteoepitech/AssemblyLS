; String utils for Assembly LS
%include "include/ls.inc"

; ------------------- TEXT -------------------
section .text

    global strlen
    global strlen_char
    global strncpy

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
    xor rcx, rcx
    jmp .LOOP_STRLEN

.LOOP_STRLEN:
    movzx rax, byte [rdi]
    test rax, rax
    jz .LOOP_DONE
    inc rcx
    inc rdi
    jmp .LOOP_STRLEN

.LOOP_DONE:
    mov rax, rcx
    ret

; ----------------------------------------
; int strlen_char(const char *string, char c)
;
; Parameters:
;   rdi - const char *string
;   rsi - char c
;
; Returns:
;   rax - int
; ----------------------------------------
strlen_char:
    xor rcx, rcx
    jmp .LOOP_STRLEN

.LOOP_STRLEN:
    movzx rax, byte [rdi]
    test rax, rax
    jz .LOOP_DONE
    cmp rax, rsi
    je .LOOP_DONE
    inc rcx
    inc rdi
    jmp .LOOP_STRLEN

.LOOP_DONE:
    mov rax, rcx
    ret

; ----------------------------------------
; char *strncpy(char *dest, const char *src, size_t n)
;
; Parameters:
;   rdi - char *dest
;   rsi - const char *src
;   rdx - size_t n
;
; Returns:
;   rax - char *dest
; ----------------------------------------
strncpy:
    push rdi            ; Sauvegarde l'adresse de dest pour le retour
    xor rcx, rcx        ; rcx = 0 (compteur)
    jmp .LOOP_STRNCPY
.LOOP_STRNCPY:
    cmp rcx, rdx        ; Compare rcx avec n
    jge .LOOP_DONE      ; Si rcx >= n, on a fini
    movzx rax, byte [rsi] ; Charge le caractère source
    mov byte [rdi], al  ; Copie le caractère dans dest
    test rax, rax       ; Vérifie si c'est le caractère nul
    jz .PAD_ZEROS       ; Si oui, on doit remplir le reste avec des zéros
    inc rcx             ; Incrémente le compteur
    inc rdi             ; Passe au caractère suivant dans dest
    inc rsi             ; Passe au caractère suivant dans src
    jmp .LOOP_STRNCPY   ; Continue la boucle
.PAD_ZEROS:
    inc rcx             ; Incrémente le compteur
    inc rdi             ; Passe au caractère suivant dans dest
    cmp rcx, rdx        ; Compare rcx avec n
    jge .LOOP_DONE      ; Si rcx >= n, on a fini
    mov byte [rdi], 0   ; Remplit avec un zéro
    jmp .PAD_ZEROS      ; Continue le remplissage
.LOOP_DONE:
    pop rax             ; Restaure l'adresse de dest pour le retour
    ret
