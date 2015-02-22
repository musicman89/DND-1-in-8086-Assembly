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

