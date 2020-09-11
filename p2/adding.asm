; Will Baglivio
; Program 2 - Adding Integers
; 9/11/20

SECTION .data

SECTION .bss

SECTION .text
global _main
_main:

; Problem 1
mov ax, 0CDBAh
mov bx, 0CDABh
add ax, bx

; Problem 2
mov ax, 0ABCDh
mov bx, 0ABCDh
add ax, bx

; Problem 3
mov ax, 0FAFAh
mov bx, 0505h
add ax, bx

; Problem 4
mov ax, 0F0F0h
mov bx, 0FF00h
add ax, bx

; Problem 5
mov ax, 0D468h
mov bx, 2B98h
add ax, bx

; Problem 6
mov ax, 700Fh
mov bx, 0FF1h
add ax, bx

; Problem 7
mov ax, 1234h
mov bx, 7654h
add ax, bx

; Problem 8
mov ax, 0B0Bh
mov bx, 0A11Eh
add ax, bx

; Problem 9
mov ax, 7654h
mov bx, 789Ah
add ax, bx

; Problem 10
mov ax, 8000h
mov bx, 8000h
add ax, bx

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
