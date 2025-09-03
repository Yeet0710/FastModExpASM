; modexp.asm — Win64 (Microsoft x64 ABI), NASM
; Signatur (C):  unsigned long long modexp(unsigned long long base,
;                                          unsigned long long exp,
;                                          unsigned long long mod);
; Register beim Aufruf: RCX=base, RDX=exp, R8=mod
; Rückgabe: RAX
;
; r10 = base
; r11 = exp
; r9  = mod

default rel
section .text
global  modexp
extern  modmul        

modexp:

    ; Check ob modulo 1 oder 0 ist
    test r8, r8
    je exit_0
    cmp r8, 1
    je exit_0

    ; Check ob exponent 0 ist
    cmp rdx, 0
    je exit_1

    ; Basis, Exponent und Modulo speichern
    mov r10,    rcx 
    mov r11,    rdx
    mov r9,     r8
    push rbx
    mov rbx,    1

    ; Basis wird zu Basis.mod()
    xor rdx, rdx
    mov rax, rcx
    div r9
    mov r10, rdx

schleife:
    ; Beginn der Schleife
    test r11, r11
    je exit_result

    ; Falls das aktuelle Exponent-Bit ungerade ist
    test r11, 1
    jz skip_mul

    ; Aufruf von modmul
    sub rsp, 40
    mov rcx, rbx
    mov rdx, r10
    mov r8,  r9
    call modmul
    add rsp, 40
    mov rbx, rax

skip_mul:
    ; right shift
    shr r11, 1

    ; Basis quadrieren und modulo
    sub rsp, 40
    mov rcx, r10
    mov rdx, r10
    mov r8, r9
    call modmul
    add rsp, 40
    mov r10, rax

    jmp schleife

exit_result:
    mov rax, rbx
    pop rbx
    ret

exit_1:
    mov rax, 1
    pop rbx
    ret

exit_0:
    xor rax, rax
    pop rbx
    ret
