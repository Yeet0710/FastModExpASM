; modmul.asm — Win64 / NASM
; Signatur (C): unsigned long long modmul(unsigned long long a,
;                                         unsigned long long b,
;                                         unsigned long long mod);
; RCX=a, RDX=b, R8=mod → RAX= (a*b) % mod

default rel
section .text
global  modmul

modmul:
    test r8, r8
    jnz ok
    xor eax, eax
    jmp exit

ok:
    mov rax, rcx
    mul rdx

    div r8
    mov rax, rdx

exit:
    ret
