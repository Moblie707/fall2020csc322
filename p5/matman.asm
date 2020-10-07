; Will Baglivio
; Matrix Management
; 10/6/20
; Sums the rows and columns of an arbitrary matrix
; Also takes the grand total

;;;;;;;;;;;;;;;;;;;; TEST CASE 2 ;;;;;;;;;;;;;;;;;;;;;;;

ROWS:	EQU 5
COLS:	EQU 7

SECTION .data
MyMatrix: dd	 1,  2,  3,  4,  5,  6,  7
	  dd	 8,  9, 10, 11, 12, 13, 14
	  dd	15, 16, 17, 18, 19, 20, 21
	  dd	22, 23, 24, 25, 26, 27, 28
	  dd	29, 30, 31, 32, 33, 34, 35

SECTION .bss
RowSums:	RESD ROWS
ColSums:	RESD COLS
Sum:		RESD 1
Save:		RESD 1
Save2:		RESD 1
ColDist:	RESD 1

SECTION .text
global _main
_main:

; Obtain distance for column traversal
mov ecx, COLS
mov eax, 0
myloop:
	add eax, 4
loop myloop
mov [ColDist], eax

; Calculate row sums first
mov ecx, ROWS
mov ebx, MyMatrix
mov edx, RowSums
outer:
	mov [Save], ecx
	mov ecx, COLS
	mov eax, 0
	inner:
		add eax, [ebx]
		add ebx, 4
	loop inner
	mov [edx], eax
	add edx, 4
	mov ecx, [Save]
loop outer

; Calculate column sums next
mov ecx, COLS
mov ebx, MyMatrix
mov edx, ColSums
outer2:
	mov [Save], ecx
	mov [Save2], ebx
	mov ecx, ROWS
	mov eax, 0
	inner2:
		add eax, [ebx]
		add ebx, [ColDist]
	loop inner2
	mov [edx], eax
	add edx, 4
	mov ecx, [Save]
	mov ebx, [Save2]
	add ebx, 4
loop outer2

; Finally, calculate grandTotal
mov ecx, ROWS
mov ebx, MyMatrix
mov eax, 0
outer3:
	mov [Save], ecx
	mov ecx, COLS
	inner3:
		add eax, [ebx]
		add ebx, 4
	loop inner3
	mov ecx, [Save]
loop outer3
mov [Sum], eax

lastBreak:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
