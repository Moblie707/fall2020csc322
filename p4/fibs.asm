; Will Baglivio
; CSC 322 Fall 2020 (9/29/20)
; Program 4 - Fibonacci Sequence
; This program calculates and stores
; the first 16 numbers in the Fibonacci Sequence.

SECTION .data

SECTION .bss
Fibs:	RESD 16

SECTION .text
global _main
_main:

; First 2 Fibonacci numbers
mov ebx, 0
mov [Fibs],ebx
mov ebx,1
mov [Fibs+4],ebx

; Calculate last 14
mov ebx, Fibs
mov eax, [Fibs]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

sub ebx, 4
mov eax, [ebx]
add ebx, 4
add eax, [ebx]
add ebx, 4
mov [ebx], eax

done:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
