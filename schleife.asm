; nasm -f win64 schleife.asm -o schleife.o
; gcc .\schleife.o -o .\schleife.exe -nostdlib "-Wl,--entry=start" "-Wl,--subsystem,console" -lkernel32 -luser32

        default rel
        extern  GetStdHandle
        extern  WriteFile
        extern  ExitProcess
        extern  GetAsyncKeyState
        extern  Sleep

        global  start

STD_OUTPUT_HANDLE   equ -11
VK_ESCAPE           equ 0x1B
VK_UP               equ 0x26
VK_DOWN             equ 0x28

section .data
tick2            db "00", 13, 10
tick2Len         equ $ - tick2

section .bss
hOut            resq 1
bytesW          resd 1
counter         resd 1

section .text
start:
    sub rsp, 40

    mov ecx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [hOut], rax

.loop:
    ;ESC prüfen
    mov ecx, VK_ESCAPE
    call GetAsyncKeyState
    test ax, 0x8000
    jnz .quit

    ;Up prüfen
    mov ecx, VK_UP
    call GetAsyncKeyState
    test ax, 0x8000
    jz .checkDown
    inc dword [counter]

.checkDown:
    mov ecx, VK_DOWN
    call GetAsyncKeyState
    test ax, 0x8000
    jz .show
    dec dword [counter]

.show:
    ;Zahl in ASCII umwandeln
    mov eax, [counter]
    cmp eax, 0
    jge .nonneg
    xor eax, eax

.nonneg:
    cmp eax, 99
    jbe .inRange
    mov eax, 99

.inRange:
    xor edx, edx
    mov ecx, 10
    div ecx             ;EAX=Zehner, EDX=Einer
    
    ;Zehner nach ASCII
    mov bl, al          ;BL=Zehner
    add bl, '0'
    mov [tick2], bl

    ;Einer nach ASCII
    mov bl, dl 
    add bl, '0'
    mov [tick2+1], bl

    ;Zahl ausgeben
    mov rcx, [hOut]
    lea rdx, [rel tick2]
    mov r8d, tick2Len
    lea r9, [rel bytesW]
    mov qword [rsp+32], 0
    call WriteFile

    ;Kurze Pause
    mov ecx, 50
    call Sleep
    jmp .loop

.quit:
    xor ecx, ecx
    call ExitProcess