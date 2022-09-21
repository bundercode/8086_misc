; NAME:		Brandon Smith
; PROJECT:	Project 2
; COURSE:	CS 271
; DATE:		03/26/13

; Compile: nasm -f elf smitbl07_project2.asm
; Link: gcc -o smitbl07_project1 smitbl07_project2.o
; Run: ./smitbl07_project2

;%include "syscalls.h"

;BEGIN main
section .text
	global	main
	extern	printf
	
main:
	push	ebp
	mov	ebp, esp
	mov	edx, bLen
	mov	ecx, bSort
	mov	ebx, 1		;STDOUT
	mov	eax, 4		;_WRITE
	int	80h
	
	push	array
	call	readtbl
	mov	dword [arSize], eax
	push	dword [arSize]
	call	printtbl
	call	sorttbl

	mov	edx, aLen
	mov	ecx, aSort
	mov	ebx, 1		;STDOUT
	mov	eax, 4		;_WRITE
	int	80h
	call	printtbl
	add	esp, 8
	
	pop	ebp
	mov	ebx, 0
	mov	eax, 1		;_EXIT
	int	80h
section .data
bSort:	db	'A table contains the following integers:', 0AH ;before sort message
bLen:	equ	$-bSort		;length of bSort
aSort:	db	'After being sorted, the integers are as follows:', 0AH ;after sort message
aLen:	equ	$-aSort		;aSort length
arSize:	dd	0		;elements in array
section .bss
array	resd	250		;array
;END main


;BEGIN readtbl
section .text
	extern fopen
	
readtbl:
	push	ebp
	mov	ebp, esp
	push	mode
	push	file
	call	fopen
	add	esp, 4
	
	push	eax		;save file descriptor
	mov	esi, [ebp+12]
	call	readint
	mov	dword [esi+(eax*4)], eax
	mov	[size], eax
	imul	dword [four]
	mov	dword [count], eax
.loop:
	call	readint
	mov	dword [esi+count], eax
	sub	dword [count], 4
	cmp	dword [count], 0
	jne	readtbl.loop

	pop	ebx
	mov	eax, 6		;_CLOSE
	int	80h

	mov	eax, dword [size]
	pop	ebp
	ret
section .data
file:	db	"indata.txt", 0 ;input file name
mode:	db	"r", 0		;open in read mode
four:	dd	4		;had problems with imul...
size:	dd	0		;number of items in file
count:	dd	0		;iterator for loop
section .bss
;END readtbl


;BEGIN readint
section .text
	extern	fscanf
	
readint:
	push	ebp
	mov	ebp, esp
	mov	ebx, [ebp+8]
	push	buff
	push	form
	push	ebx
	call	fscanf
	add	esp, 12
	mov	eax, dword [buff]
	pop	ebp
	ret
section	.data
form:	db	"%d", 0	;input for scanner
section .bss
buff:	resd	1		;buffer to hold ints from file
;END readint


;BEGIN printtbl
section .text

printtbl:
	push	ebp
	mov	ebp, esp
	mov	esi, [ebp+8]
.loop:
	mov	edx, 4		;dword size
	mov	ecx, [esi+pos]
	mov	ebx, 1		;STDOUT
	mov	eax, 4		;_WRITE
	int	80h
	add	dword [pos], 4
	inc	dword [iter]
	mov	eax, dword [ebp+12]
	cmp	eax, dword [iter]
	jne	printtbl.loop
	
	pop	ebp
	ret
section	.data
iter:	dd	0		;loop iterator
pos:	dd	0		;array position
section	.bss
;END printtbl


;BEGIN sorttbl
section .text

sorttbl:
	push	ebp
	mov	ebp, esp
.wLoop:
	mov 	esi, dword [ebp+8]
        mov 	ecx, dword [ebp+12]
        dec 	ecx
.fLoop:
        push 	ecx
 	mov 	eax, [esi+4]
        mov 	ebx, [esi]
        cmp 	eax, ebx
	jg 	.end                             
	
	mov 	[esi+4], ebx
        mov 	[esi], eax
 	xor 	edx, edx
        inc 	edx
.end:
 	add 	esi, 4
        pop 	ecx
        dec 	ecx
        jnz 	.fLoop
 
        cmp 	edx, 0
        jnz 	.wLoop
	pop	ebp
	ret
section	.data
section	.bss
;END sorttbl
