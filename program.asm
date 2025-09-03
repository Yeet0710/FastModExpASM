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
versuch     db  "Versuch: %d", 10, 0
fmtIn       db  "%d", 0
fmtOutH     db  "%d ist zu hoch.", 10, 0
fmtOutL     db  "%d ist zu niedrig.", 10, 0
fmtOutK     db  "%d ist korrekt. %d Versuche benoetigt.", 10, 0

rnd         dd  0
input       dd  0
counter     dd  0

section .text
main:
    ; --- Zufallszahl 1..100 aus TSC ---
    rdtsc
    mov     ecx, 100
    xor     edx, edx
    div     ecx
    inc     edx
    mov     [rel rnd], edx

    ; printf(prompt)
    sub     rsp, 40
    lea     rcx, [rel prompt]
    xor     eax, eax
    call    printf
    add     rsp, 40

eingabe:
    ; scanf("%d", &input)
    sub     rsp, 40
    lea     rcx, [rel fmtIn]
    lea     rdx, [rel input]
    xor     eax, eax
    call    scanf
    add     rsp, 40

    ; counter++
    inc     dword [rel counter]

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
    jmp     versuch_ausgabe

ist_niedriger:
    ; printf("%d ist zu niedrig.", input)
    sub     rsp, 40
    lea     rcx, [rel fmtOutL]
    mov     edx, eax
    xor     eax, eax
    call    printf
    add     rsp, 40
    jmp     versuch_ausgabe

ist_gleich:
    ; printf("%d ist korrekt. %d Versuche benoetigt.", input, counter)
    sub     rsp, 40
    lea     rcx, [rel fmtOutK]
    mov     edx, eax                 ; %d -> eingegebene Zahl
    mov     r8d, [rel counter]       ; %d -> Versuche
    xor     eax, eax
    call    printf
    add     rsp, 40
    jmp     exit

versuch_ausgabe:
    ; printf("Versuch: %d", counter)
    sub     rsp, 40
    lea     rcx, [rel versuch]
    mov     edx, [rel counter]
    xor     eax, eax
    call    printf
    add     rsp, 40
    jmp     eingabe

exit:
    xor     eax, eax
    ret
