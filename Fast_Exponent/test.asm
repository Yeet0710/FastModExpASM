; test.asm — Win64 (Microsoft x64 ABI), NASM
; Build:
;   nasm -f win64 test.asm -o test.o
;   gcc test.o -o test.exe

default rel
global  main
extern  modexp
extern printf

section .data
    fmt db "%llu", 0

section .text
main:
    sub rsp, 40
    mov rcx, 2
    mov rdx, 23
    mov r8,  5
    call modexp
    add rsp, 40

    sub rsp, 40
    lea rcx, [rel fmt]
    mov rdx, rax
    xor rax, rax
    call printf
    add rsp, 40

    xor rax, rax
    ret