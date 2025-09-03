; program.asm - Win64, NASM
; Build:
;   nasm -f win64 program.asm -o program.o
;   gcc program.o -o program.exe

default rel
global  main
extern  printf
extern  scanf

section .data
prompt      db  "Bitte Zahl (1-100) eingeben: ", 0
fmtIn       db  "%d", 0
fmtOutH     db  "%d ist zu hoch.", 10, 0
fmtOutL     db  "%d ist zu niedrig.", 10, 0
fmtOutK     db  "%d Korrekt.", 10, 0

rnd         dd  0          ; Zufallszahl (1..100)
input       dd  0

section .text
main:
    ; --- einfache "Random"-Zahl 1..100 aus TSC generieren ---
    rdtsc                  ; EDX:EAX = TSC
    mov     ecx, 100
    xor     edx, edx
    div     ecx            ; EAX/100 -> Quotient in EAX, Rest in EDX
    inc     edx            ; Rest 0..99 => 1..100
    mov     [rel rnd], edx

    ; printf(prompt)
    sub     rsp, 40
    lea     rcx, [rel prompt]
    xor     eax, eax       ; variadische Funktion → AL = 0
    call    printf
    add     rsp, 40

eingabe:
    ; scanf("%d", &input)
    sub     rsp, 40
    lea     rcx, [rel fmtIn]
    lea     rdx, [rel input]
    xor     eax, eax       ; variadische Funktion → AL = 0
    call    scanf
    add     rsp, 40

    ; Vergleich input vs rnd
    mov     eax, [rel input]
    mov     r8d, [rel rnd]
    cmp     eax, r8d
    je      ist_gleich
    jl      ist_niedriger

ist_hoeher:
    ; printf("%d ist zu hoch.", input)
    sub     rsp, 40
    lea     rcx, [rel fmtOutH]
    mov     edx, eax
    xor     eax, eax
    call    printf
    add     rsp, 40
    jmp     eingabe

ist_niedriger:
    ; printf("%d ist zu niedrig.", input)
    sub     rsp, 40
    lea     rcx, [rel fmtOutL]
    mov     edx, eax
    xor     eax, eax
    call    printf
    add     rsp, 40
    jmp     eingabe

ist_gleich:
    ; printf("%d Korrekt.", input)
    sub     rsp, 40
    lea     rcx, [rel fmtOutK]
    mov     edx, eax
    xor     eax, eax
    call    printf
    add     rsp, 40

    xor     eax, eax
    ret
