%define LightGreenOnBlack 0x0A
%define LightRedOnBlack 0x0C
%define LightGrayOnBlack 0x07

%macro  PrintString 1 
	push ax
	push bx
	mov ah, LightGrayOnBlack
	mov bx, %1     		;load the pointer to our string
	call print_string   ;print the string
	pop bx
	pop ax
%endmacro
%macro  PrintGreenString 1 
	push ax
	push bx
	mov ah, LightGreenOnBlack
	mov bx, %1     		;load the pointer to our string
	call print_string   ;print the string
	pop bx
	pop ax
%endmacro
%macro  PrintRedString 1 
	push ax
	push bx
	mov ah, LightRedOnBlack
	mov bx, %1     		;load the pointer to our string
	call print_string   ;print the string
	pop bx
	pop ax
%endmacro