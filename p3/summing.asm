; Will Baglivio
; CSC 322 Fall 2020 (9/26/20)
; Program 3 - Summinging Integers
; This program sums the elements of multiple arrays

SECTION .data
bArray:		DB	-1,2,-3,4,-5,6
wArray:		DW	09h,0ah,0bh,0ch,0dh
dArray:		DD	-10,-20,-30,-40,-50
bArraySum:	DB	0
wArraySum:	DW	0
dArraySum:	DD	0
grandTotal:	DD	0

SECTION .bss

SECTION .text
global _main
_main:

; Array 1
mov ebx,bArray
mov al,[ebx]
add ebx,1
add al,[ebx]
add ebx,1
add al,[ebx]
add ebx,1
add al,[ebx]
add ebx,1
add al,[ebx]
add ebx,1
add al,[ebx]
mov [bArraySum],al

break0:

; Array 2
xor ax,ax
mov ebx,wArray
mov ax,[ebx]
add ebx,2
add ax,[ebx]
add ebx,2
add ax,[ebx]
add ebx,2
add ax,[ebx]
add ebx,2
add ax,[ebx]
mov [wArraySum],ax

break1:

; Array 3
xor ax,ax
mov ebx,dArray
mov eax,[ebx]
add ebx,4
add eax,[ebx]
add ebx,4
add eax,[ebx]
add ebx,4
add eax,[ebx]
add ebx,4
add eax,[ebx]
mov [dArraySum],eax

; Grand Total
xor eax,eax
mov eax,[bArraySum]
add eax,[wArraySum]
add eax,[dArraySum]
mov [grandTotal],eax

lastbreak:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
