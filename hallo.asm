; hallo.asm - Win64, NASM
; Aufruf: nasm -f win64 hallo.asm -o hallo.o
; Linken: gcc .\hallo.o -o .\hallo.exe -nostdlib "-Wl,--entry=start" "-Wl,--subsystem,console" -lkernel32

default rel
extern GetStdHandle
extern WriteFile
extern ExitProcess

global start

STD_OUTPUT_HANDLE equ -11

section .data
msg     db "Das hier ist ein neuer Text", 0Dh, 0Ah, 0Dh, 0Ah, 13, 10
msgLen equ $ - msg

section .bss
hOut resq 1
bytesWritten resd 1

section .text
start:
; RCX = STD_OUTPUT_HANDLE
sub rsp, 40                     ; 32 Bytes shadow Space + 8 für Byte allignment
mov ecx, STD_OUTPUT_HANDLE
call GetStdHandle               ; RAX = Handle
mov [hOut], rax

; WriteFile(hStdOut, msg, msgLen, &bytesWritten, NULL)
mov rbx, 5

loop_start:
mov rcx, [hOut]                    ;hFile
lea rdx, [rel msg]
mov r8d, msgLen
lea r9, [rel bytesWritten]
mov qword [rsp+32], 0
call WriteFile

dec rbx
jnz loop_start

; ExitProcess
xor ecx, ecx
call ExitProcess