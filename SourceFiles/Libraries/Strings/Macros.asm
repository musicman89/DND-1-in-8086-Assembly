section .text
%macro NewString 1+
	%strlen len %1
	%rep %0
		dw len + 1
		db %1, 0
	%endrep
%endmacro

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
	push bx
	GetString %2, %3
	mov cx, %1 
	mov dx, bx
	call string_compare
	test ax, ax
	pop bx
	pop dx
	pop cx
%endmacro

%macro StringCompareInsensitive 2-3 0 
	push cx
	push dx
	push bx
	GetString %2, %3
	mov cx, %1 
	mov dx, bx
	call string_compare_insensitive
	test ax, ax
	pop bx
	pop dx
	pop cx
%endmacro

%macro GetString 1-2 0
	mov bx, %1

	%if %2 <> 0
		mov ax, %2
		call get_string
	%endif
%endmacro

%macro StringCopy 2-3 0
	push cx
	push dx
	push bx
	push ax
	GetString %2, %3
	mov cx, %1 
	mov dx, bx
	call string_copy
	pop ax
	pop bx
	pop dx
	pop cx
%endmacro

