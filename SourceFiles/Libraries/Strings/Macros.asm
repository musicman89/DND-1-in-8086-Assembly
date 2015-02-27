SECTION .text
struc string
	.value resb 68
	.length resw 1
endstruc

%macro NewString 1+
	%strlen len %1
	;Define each string
	%rep %0
		dw len
		db %1
	%endrep
%endmacro

; %macro NewString 1+
; 	%strlen len %1
; 	istruc string
; 		at string.value, db %1
; 		at string.length, db len
; 	iend
; %endmacro

%macro StringToLower 1 
	mov bx, %1 
	call to_lower
%endmacro

%macro StringToUpper 1 
	mov bx, %1
	call to_upper
%endmacro

%macro StringCompare 2-3 0 
	push cx
	push dx
	mov cx, %1 
	mov dx, %2 + %3 * string_size
	call string_compare
	test ax, ax
	pop dx
	pop cx
%endmacro

%macro StringCompareInsensitive 2-3 0 
	push cx
	push dx
	mov cx, %1 
	mov dx, %2 + %3 * string_size
	call string_compare_insensitive
	test ax, ax
	pop dx
	pop cx
%endmacro

%macro StringCopy 2-3 0
	push cx
	push dx
	mov cx, %1 
	mov dx, %2 + %3 * string_size
	call string_copy
	pop dx
	pop cx
%endmacro

