; Will Baglivio
; 11/13/20
; CSC 323
; The Message Wanderer:
; This program lets a message wander like a snake in a confined screen.
; This code has been adapted from Dr. Allen's cycle.asm

;;; Define Structure for character on screen
STRUC mStruct
		RESB 2  ;;; space for <esc>[
	.row:	RESB 2  ;;; two digit number (characters)
		RESB 1  ;;; space for ;
	.col:	RESB 2  ;;; two digit number (characters)
		RESB 1  ;;; space for the H
	.char:	RESB 1  ;;; space for THE character
	.size:
ENDSTRUC

;;; Calls itoa function
;;; Params(al has integer to convert, ebx has address of empty string)
%macro callItoa 2
        pusha
        mov al, %1
        mov ebx, %2
%%ybreak:
        call _itoa
%%zbreak:
        popa
%endmacro

;;; Prints a character
;;; Params (address of char)
%macro printchar 1
	pusha
	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, 9	;;; A character has 9 bytes
	int 80h
	popa
%endmacro

SECTION .data
; clear screen string
cls:		db 1bh,'[2J'

; Set cursor position control characters
pos     db      1bh, '['
row     db      '00'
        db      ';'
col     db      '00'
        db      'H'

; Create an array of structs: formatted like the print interrupt uses.
message:	db 1bh,'[10;28H!'
		db 1bh,'[10;27H!'
		db 1bh,'[10;26Hs'
		db 1bh,'[10;25Hd'
		db 1bh,'[10;24Hl'
		db 1bh,'[10;23Hr'
		db 1bh,'[10;22Ho'
		db 1bh,'[10;21HW'
		db 1bh,'[10;20H '
		db 1bh,'[10;19Ho'
		db 1bh,'[10;18Hl'
		db 1bh,'[10;17Hl'
		db 1bh,'[10;16He'
		db 1bh,'[10;15HH'
LEN: EQU 135
messagelen: EQU 15

;;; Boundary character
community:	db 1bh,'[01;40H*'

;;; Boundary defined by community
MINROW: EQU 1
MAXROW: EQU 20
MINCOL: EQU 1
MAXCOL: EQU 40

SECTION .bss
emptystr:	RESB 2

SECTION .text
global _main, _clrscr, _itoa, _crcomm, _displayMessage, _setCursor
_main:
	call _clrscr	;;; Clears screen
	call _crcomm	;;; Creates community
break:
	call _displayMessage

	mov ah, 25
	mov al, 1
	call _setCursor

; Demonstrate an infinite loop calling  functions which uses an array of structs

;top1: 	call	_displayMessage
;	call	_pause
;	call	_adjustMessage
;	jmp	top1



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
;;; al has number (0 <= x < 100)
;;; ebx has address of string for storage
_itoa:
        pusha
	xor 	ah,ah
        mov     cl,10
        div     cl
        add     ah,'0'
        add     al,'0'
        mov     [ebx],ax
        popa
        ret

;;; Creates community
_crcomm:
	pusha
	
	;;; First prints top boundary
	mov ecx, MAXCOL
	
	top:
		push ecx
		dec ecx
		printchar community				;;; Prints boundary character
		callItoa cl, emptystr				;;; Convert current col to chars
		mov bx, [emptystr]
		mov BYTE [community + mStruct.col], bl		;;; Moves one column to the left
		mov BYTE [community + mStruct.col + 1], bh
		pop ecx
		loop top

	;;; Next, prints left boundary
	mov ecx, 1

	left:
		cmp ecx, MAXROW					;;; Iterate over rows 1 <= x <= 20
		jg endleft

		callItoa cl, emptystr				;;; Convert current row to chars
		mov bx, [emptystr]
		mov BYTE[community + mStruct.row], bl		;;; Moves one row down
		mov BYTE[community + mStruct.row + 1], bh
		printchar community				;;; Prints boundary character

		inc ecx
		jmp left
	endleft:

	;;; Next, prints bottom boundary
	mov ecx, 1

	bottom:
		cmp ecx, MAXCOL					;;; Iterate over cols 1 <= x <= 40
		jg endbottom

		callItoa cl, emptystr				;;; Convert current col to chars
		mov bx, [emptystr]
		mov BYTE[community + mStruct.col], bl		;;; Moves one col to the right
		mov BYTE[community + mStruct.col + 1], bh
		printchar community				;;; Prints boundary character
		
		inc ecx
		jmp bottom
	endbottom:

	;;; Finally, prints right boundary
	mov ecx, MAXROW

	right:
		push ecx
		dec ecx
		printchar community				;;; Prints boundary character
		callItoa cl, emptystr				;;; Convert current row to chars
		mov bx, [emptystr]
		mov BYTE[community + mStruct.row], bl		;;; Moves one row up
		mov BYTE[community + mStruct.row + 1], bh
		pop ecx
		loop right

	popa
	ret

;;;;;;;;;;;;  Function that rotates the characters through the array of structs 
_adjustMessage:	
	pusha

	mov	al, BYTE [message + mStruct.char] ;; get first char to put at bottom
	push	eax   ; save for bottom

	mov	ebx,message  ;; pointer into array, starting at top
	mov	ecx,LEN-1    ;; loop 

_amTop: mov	dl,[ebx + mStruct.size + mStruct.char] 	;; get char below
	mov	[ebx + mStruct.char],dl			;; put on current row

	add	ebx,mStruct.size
	loop	_amTop

	pop	eax	;; retreive the first char
	mov	BYTE [ebx + mStruct.char],al

	popa
	ret


;;;;;;;;;;;   Function to print the array of structs of message
_displayMessage:
	pusha
	mov	ebx,message
	mov	ecx,messagelen

_dmTop:	push	ecx
	push	ebx
	mov	eax,4  ; system print
	mov	ecx,ebx ; points to string to print
	mov	ebx,1   ; standard out
	mov	edx,9   ; num chars to print
	int	80h

	pop	ebx
	add	ebx,mStruct.size
	pop	ecx
	loop	_dmTop
	popa
	ret

;. _setcursor expects AH = row, AL = col
_setCursor:
        pusha
        ;;; save original to get col later
        push    eax
        ;;;;;; process row
        shr     ax,8    ;; shift row to right
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [row],al
        mov     BYTE [row+1],ah
        ;;;; process col
        pop     eax     ;; restore original parms
        and     ax,0FFh ;; erase row, leave col
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [col],al
        mov     BYTE [col+1],ah

        ;;;;; now print the set cursor codes
        mov     eax,4
        mov     ebx,1
        mov     ecx,pos
        mov     edx,8
        int     80h

        popa
        ret

;;;;;;;;;;;;;  Function to sleep 1/20 second ;;;;;;;;;;;;;;;;;;;;;
_pause: 
	pusha
	mov	eax,162
	mov	ebx,seconds
	mov	ecx,0
	int	80h
	popa
	ret

;;;;;;;;;;;;	Tricky use of ram.... put some data here for _pause to use
seconds: dd	0,50000000  ;;;  seconds, nanoseconds


