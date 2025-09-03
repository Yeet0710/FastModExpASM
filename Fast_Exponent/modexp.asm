; modexp.asm — Win64 (Microsoft x64 ABI), NASM
; Signatur (C):  unsigned long long modexp(unsigned long long base,
;                                          unsigned long long exp,
;                                          unsigned long long mod);
; Register beim Aufruf: RCX=base, RDX=exp, R8=mod
; Rückgabe: RAX

default rel
section .text
global  modexp
extern  modmul        

modexp:
    

.done:
    xor eax, eax
    ret
