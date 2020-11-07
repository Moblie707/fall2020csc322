; Will Baglivio
; 11/6/20
; CSC 322
; Sort
; This program sorts in ascending order
; a list of unsigned byte integers and
; prints the results to the screen

;;; Calls itoa function
;;; Params(ax has integer to convert, ebx has address of empty string)
%macro callItoa 2
	pusha
	mov al, %1
	mov ebx, %2
%%ybreak:
	call _itoa
%%zbreak:
	popa
%endmacro

;;; Prints given string
;;; Params(address of string, and string length)
%macro print 2
	pusha
	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 80h
	popa
%endmacro

;;; Converts number, and prints it
;;; Params(number to print)
%macro numprint 1
%%mynubreak:
	callItoa %1, string
%%mybreak:
	print string, 3
	print space, 1
%endmacro


SECTION .data
cls:		db	1bh, '[2J'			;;; Clear screen control characters
space:		db	' '				;;; Space
crlf:		db	10				;;; Return character
nums:		db	100, 200, 5, 10, 0, 88, 22	;;; Array of unsorted numbers
numslen:	EQU	($-nums)			;;; Length of Array
header1:	db	'Original Array', 10		;;; Beginning header
h1len:		EQU	($-header1)			;;; Length of beginning header
header2:	db	'Sorted Array', 10		;;; Ending header
h2len:		EQU	($-header2)			;;; Length of ending header
i:	db 0
j:	db 0

SECTION .bss
string:	RESB	3	;;; String for printing

SECTION .text
global _main, _clrscr, _itoa, _prtarr, _sortarr
_main:
break8:
	call _clrscr
	print header1, h1len
break9:
	mov eax, nums
	mov bl, numslen
break7:
	call _prtarr
break0:
	call _sortarr
breakk:
	print header2, h2len
	mov eax, nums
	mov bl, numslen
	call _prtarr

	; Normal termination code
	mov eax, 1
	mov ebx, 0
	int 80h

;;; Clears screen
_clrscr:
	pusha

	mov eax, 4
	mov ebx, 1
	mov ecx, cls
	mov edx, 4
	int 80h

	popa
	ret

;;; Converts integer into string
;;; al has number (0 <= x < 1000)
;;; ebx has address of string for storage
_itoa:
	pusha
	xor ah, ah
	mov cl, 100
subreak:
	div cl
pbreak:
	add al, '0'
obreak:
	mov [ebx], al
nubreak:
	shr ax, 8
mubreak:	
	mov cl, 10
	div cl
	add al, '0'
	add ah, '0'
	mov [ebx+1], al
	mov [ebx+2], ah
	popa
	ret

;;; Prints an array of numbers
;;; eax has address of array of unsigned byte integers
;;; bl has length of array
_prtarr:
	pusha
	movzx ecx, bl
	array:
breaky:
		numprint [eax]
		inc eax
breaku:
		loop array
	print crlf, 1
	popa
	ret

;;; Sorts an array of unsigned byte integers in ascending order
;;; (Bubble sort)
;;; eax has address of array of unsigned byte integers
;;; bl has length of array
_sortarr:
	pusha
	dec bl		;;; Set n = n-1
	mov BYTE [i], 0	;;; i = 0

	outer:
break1:
		cmp [i], bl	;;; i < n-1
		jge endouter	;;; end loop if i >= n-1

		mov BYTE [j], 0	;;; j = 0
		push ebx	
		sub bl, [i]	;;; n-1-i
		inner:
break2:
			push eax
			cmp [j], bl	;;; j < n-1-i
			jge endinner	;;; end loop if j >= n-1-i
breaka:
			xor esi, esi
			movzx esi, BYTE [j]
			add eax, esi	;;; array position j
			mov ecx, eax	
			inc ecx		;;; array position j+1
breakb:			
			xor dx, dx
			mov dl, [ecx]
			cmp [eax], dl	;;; if arr[j] > arr[j+1]
			jle endif
breakx:
				mov dh, [eax]
				mov [ecx], dh
				mov [eax], dl
			endif:
breakc:			
			pop eax
breakd:
			inc BYTE [j]	;;; j++
breake:
			jmp inner	;;; loop
		endinner:
		pop ebx
break3:
		inc BYTE [i]	;;; i++
break4:
		jmp outer	;;; loop
	endouter:
		
	popa
	ret





























