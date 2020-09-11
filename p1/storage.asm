; Will Baglivio
; Data Storage Program
; Date: 9/11/20

SECTION .data
a1:	DB	11
b1:	DW	11b
c1:	DD	11h
d1:	DQ	11q
e1:	DW	-5
f1:	DB	'CSC322'

a2:	DB	5,4,3,2,1
b2:	DW	1,2,3,4,5
c2:	DD	10,11,12,13
d2:	DQ	10h,11h,12h,13h

a3:	DB	-5
b3:	DW	-10
c3:	DB	-15
d3:	DW	-20
e3:	DB	-25

a4:	DB	'Mercer'
b4:	DB	10
c4:	DB	0
d4:	DB	'Go '
e4:	DB	'Bears!'

a5:	DW	100
b5:	DD	100h
c5:	DB	100b
d5:	DW	100q
e5:	DD	100d

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:


; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
