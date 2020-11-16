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
message:	db 1bh,'[10;29H '
		db 1bh,'[10;28H!'
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

firstrow: db 10
firstcol: db 15

;;; Boundary character
community:	db 1bh,'[01;40H*'

;;; Boundary defined by community
MINROW: EQU 1
MAXROW: EQU 20
MINCOL: EQU 1
MAXCOL: EQU 40

SECTION .bss
emptystr:	RESB 2
deltarow:	RESB 1
deltacol:	RESB 1

SECTION .text
global _main, _clrscr, _itoa, _crcomm, _displayMessage, _adjustMessage, _pause, _setCursor
_main:
	call _clrscr	;;; Clears screen
	call _crcomm	;;; Creates community

	infty:
loopBreak:
		call _displayMessage
		call _pause
		call _adjustMessage
		jmp infty

	mov ah, 25
	mov al, 1
	call _setCursor

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

;;; Function that shifts the rows/cols of the characters through the array of structs, and randomly
;;; chooses new position for first character (+- 1 to row and/or col)
_adjustMessage:	
	pusha

	mov ebx, message	;;; Pointer into array, starting at last character
	mov ecx, messagelen	;;; Iterate over n-1 characters
	dec ecx

	amTop:
		mov ax, [ebx + mStruct.size + mStruct.row]	;;; Get row of next character
		mov dx, [ebx + mStruct.size + mStruct.col]	;;; get col of next character

		mov [ebx + mStruct.row], ax			;;; Move next row to current row
		mov [ebx + mStruct.col], dx			;;; Move next col to current col

		add ebx, mStruct.size				;;; Move to next character
		loop amTop
mybreak:
	rdtsc
        and eax, 111b	;;; Choose a random number between 0 and 7, inclusive

	;;; Decide where to move first character based on al register
	cmp eax, 0		;;; Rng == 0
	jne next1
	mov BYTE [deltarow], -1
	mov BYTE [deltacol], 0
	jmp endrng

	next1:
	cmp eax, 1		;;; Rng == 1
	jne next2
	mov BYTE [deltarow], -1
	mov BYTE [deltacol], 1
	jmp endrng
	
	next2:
	cmp eax, 2		;;; Rng == 2
	jne next3
	mov BYTE [deltarow], 0
	mov BYTE [deltacol], 1
	jmp endrng

	next3:
	cmp eax, 3		;;; Rng == 3
	jne next4
	mov BYTE [deltarow], 1
	mov BYTE [deltacol], 1
	jmp endrng

	next4:
	cmp eax, 4		;;; Rng == 4
	jne next5
	mov BYTE [deltarow], 1
	mov BYTE [deltacol], 0
	jmp endrng

	next5:
	cmp eax, 5		;;; Rng == 5
	jne next6
	mov BYTE [deltarow], 1
	mov BYTE [deltacol], -1
	jmp endrng

	next6:
	cmp eax, 6		;;; Rng == 6
	jne next7
	mov BYTE [deltarow], 0
	mov BYTE [deltacol], -1
	jmp endrng

	next7:
	cmp eax, 7		;;; Rng == 7
	jne endrng
	mov BYTE [deltarow], -1
	mov BYTE [deltacol], -1

	endrng:
	
	;;;;;mov BYTE [deltarow], -1
	;;;;;mov BYTE [deltacol], -1

	;;; Adjust row/col by appropriate amount
	mov al, [deltarow]
	mov dl, [deltacol]
	add [firstrow], al	;;; Change 1st char row by deltarow
	add [firstcol], dl	;;; Change 1st char col by deltacol

	;;; Final check to make sure no boundaries are crossed
	mov al, [firstrow]
	mov dl, [firstcol]

	;;; Top boundary check
	cmp al, 1
	jg botbound
	mov BYTE [firstrow], 19

	;;; Bottom boundary check
	botbound:
	cmp al, MAXROW
	jl leftbound
	mov BYTE [firstrow], 2

	;;; Left boundary check
	leftbound:
	cmp dl, 1
	jg rightbound
	mov BYTE [firstcol], 39

	;;; Right boundary check
	rightbound:
	cmp dl, MAXCOL
	jl endbound
	mov BYTE [firstcol], 2

	endbound:

	;;; Now adjust first character row/col
nubreak1:
	callItoa [firstrow], emptystr
	mov cx, [emptystr]
	mov [ebx + mStruct.row], cl
	mov [ebx + mStruct.row + 1], ch
nubreak2:
	callItoa [firstcol], emptystr
	mov cx, [emptystr]
	mov [ebx + mStruct.col], cl
	mov [ebx + mStruct.col + 1], ch

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
seconds: dd	0,300000000  ;;;  seconds, nanoseconds


