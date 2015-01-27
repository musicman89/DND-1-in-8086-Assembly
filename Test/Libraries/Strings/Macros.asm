%macro  StringToLower 1 

	mov bx, %1 
	call to_lower

%endmacro

%macro  StringToUpper 1 

	mov bx, %1
	call to_upper

%endmacro

%macro  StringCompare 2 

	mov cx, %1 
	mov dx, %2
	call string_compare
	test ax, ax
	
%endmacro