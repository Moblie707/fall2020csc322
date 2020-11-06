; Will Baglivio
; 11/4/20
; CSC 322	
; Bounce: This program bounces a message horizontally
; back and forth across the screen.
; *Code additions and edits from Dr. Allen's printPlay.asm


;;; Passed two arguments: address to string, and length of string
;;; Prints given string to screen
%macro Print 2
	pusha

	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 80h

	popa
%endmacro

;;; Passed two arguments: row and column to set cursor
;;; Sets cursor to specified position
%macro setCursor 2
	pusha
	
	mov ah, %1
	mov al, [%2]
	call _cursor

	popa
%endmacro

SECTION .data
; Clear Screen control characters 
cls:	db	1bh, '[2J'

; Set cursor position control characters
pos:	db	1bh, '[' 
row:	db	'00'
	db	';'
col:	db	'00'
	db	'H'

; Message
message:	db	" "
		db	"]>--{[( 0 W 0 )]}--<["
		;db	"00000000000000000000000000000000000000000000000000000000000000000000000000000"	; Maximum message length
		db	" "
msglen:	EQU ($-message)

; Starting column
startCol:	db	0

; Column width
colWid: EQU 80

; Data structure for the sleep function - seconds, nanoseconds
sec:	dd	0, 30000000

SECTION .bss
; Stores max column for given message size
maxCol:	resb 1

SECTION .text
global _main, _clrscr, _sleep, _cursor
_main:

	;;; Clears screen
	call _clrscr

	;;; Sets maximum column
	mov eax, colWid
	sub eax, msglen
	mov [maxCol], eax
	xor eax, eax

	;;; Infinite loop for bouncing message
	infBounce:
		;;; Left to right		
		ltor:
			mov eax, [startCol]
			cmp eax, [maxCol]
			jg endltor

			setCursor 10, startCol	;;; Set cursor to row 10 and starting column
			Print message, msglen	;;; Print message
			call _sleep		;;; Pause briefly
			inc BYTE [startCol]	;;; Move 1 column to the right

			jmp ltor
		endltor:
		
		;;; Right to left
		rtol:
			mov eax, [startCol]
			cmp eax, 0
			jle endrtol			

			setCursor 10, startCol	;;; Set cursor to row 10 and starting column
			Print message, msglen	;;; Print message
			call _sleep		;;; Pause briefly
			dec BYTE [startCol]

			jmp rtol
		endrtol:		

		jmp infBounce

lastBreak:

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

;;; _cursor expects AH = row, AL = col
;;; Only works for 1 or 2 digit numbers.
_cursor:
	;;; save original to get col later
	push	eax

	;;; process row
	shr	ax,8	;;; shift row to right
	mov	bl,10
	div	bl	;;; puts ax/10 in al, remainder in ah
	add	ah,'0'
	add	al,'0'
	mov	BYTE [row],al
	mov	BYTE [row+1],ah

	;;; process col
	pop	eax	;;; restore original parms
	and	ax,0FFh	;;; erase row, leave col
	mov	bl,10
	div	bl	;;; puts ax/10 in al, remainder in ah
	add	ah,'0'
	add	al,'0'
	mov	BYTE [col],al
	mov	BYTE [col+1],ah

	;;; now print the set cursor codes
	mov	eax,4
	mov	ebx,1
	mov 	ecx,pos
	mov	edx,8
	int 	80h


	ret

;;;;; sleep requests sec,nanoseconds pause
_sleep:
	pusha
	mov	eax,162
	mov	ebx,sec
	mov	ecx,0
	int	80h
	popa
	ret
