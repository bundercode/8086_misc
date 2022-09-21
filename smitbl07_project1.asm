; NAME:		Brandon Smith
; PROJECT:	Project 1
; COURSE:	CS 271
; DATE:		02/28/13

; Compile: nasm -f elf smitbl07_project1.asm
; Link: gcc -o smitbl07_project1 smitbl07_project1.o
; Run: ./smitbl07_project1
	
section .text
	global	main
	extern	printf
	
main:
	push	ebp		;setup stack frame
	mov	ebp, esp
	mov	edx, askLen
	mov	ecx, askIn
	mov	ebx, 1
	mov	eax, 4
	int	80h		; Print intro message
	
	mov	edx, len1
	mov	ecx, str1
	mov	ebx, 1
	mov	eax, 4
	int	80h		;Print 1st num message
	call	getnum		;Scan in number
	mov	[fir], eax	;Move scanned number to fir

	mov	edx, len2
	mov	ecx, str2
	mov	ebx, 1
	mov	eax, 4
	int	80h		;Print 2nd num message
	call	getnum		;Scan in number
	mov	ebx, eax	;Move scanned number to ebx
	mov	[sec], ebx	;Copy new num to sec
	mov	eax, [fir]	;Copy first to eax

	cmp	ebx, eax	;if 2nd num bigger than 1st
	jg	main.switch	;switch places
.gcdCall:
	call	gcd		;find gcd
	push	eax		;the gcd
	push	dword [sec]	;second integer
	push	dword [fir]	;first integer
	push	prGCD		;message
	call	printf
	
	pop	ebp		;clear stack
	mov	ebx, 0
	mov	eax, 1
	int	80h		;exit

.switch:
	mov	eax, [sec]
	mov	ebx, [fir]
	jmp	main.gcdCall	;move back to find GCD
	
section .data

askIn:	db	'Enter two positive integers.', 0AH ;intro message
askLen:	equ	$-askIn				    ;intro length
str1:	db	'First integer> ', 0		    ;1st int message
len1:	equ	$-str1				    ;1st length
str2:	db	'Second integer> ', 0		    ;2nd int message
len2:	equ	$-str2				    ;2nd length
prGCD:	db	'The GCD of %d and %d is %d.', 0AH  ;final message
	
section .bss

fir:	resd	1		;first user integer
sec:	resd	1		;second user integer
	

	
section .text
	extern scanf
	
getnum:
	push	ebp		;setup stack frame
	mov	ebp, esp
	push	dword num	;user integer
	push	dword input	;formatting
	call	scanf
	add	esp, 8
	mov	eax, dword [num] ;move integer to eax
	pop	ebp		;clear stack
	ret
	
section .data

input:	db	'%d', 0		;input format for scanf
	
section .bss

num:	resd	1		;user entered integer
	

	
section .text

gcd:
	mov	edx, 0		;set edx to zero
	mov	ecx, eax	;copy eax to ecx
	idiv	ebx		;divide first int by second
	mov	[temp], edx	;save remainder in temp
	mov	ecx, ebx	;move ebx to ecx
	mov	eax, ecx	;copy ecx to eax
	mov	ebx, [temp]	;move temp to ebx
	cmp	ebx, 0		;check if ebx == 0
	jne	gcd		;if ebx != 0, run gcd again
	ret			;else return		

section .bss

temp:	resd	1		;temp variable to store remainder
