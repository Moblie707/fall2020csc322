; Will Baglivio
; 10/15/20
; CSC 322
; Program 6 - Max DWORD Fib
; This program calculates the maximum unsigned
; fibonacci number that can fit into a double word.

SECTION .data

SECTION .bss
MaxFib: RESD 1

SECTION .text
global _main
_main:

mov eax, 0	; fib 1
mov ebx, 1	; fib 2

while:
	mov ecx, eax
	add ecx, ebx	; exc has fib n+1

	jc done		; max fib found if carry

	mov eax, ebx	; move to n+1 and n+2
	mov ebx, ecx

	jmp while

done:

mov [MaxFib], ebx

lastBreak:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
