SECTION .text
%define LightGreenOnBlack 0x0A
%define LightRedOnBlack 0x0C
%define LightGrayOnBlack 0x07

%macro  PrintGreenString 1 
	push ax
	push bx
	mov bx, %1     		;load the pointer to our string
	mov ah, LightGreenOnBlack
	call print_string   ;print the string
	pop bx
	pop ax
%endmacro

%macro  PrintRedString 1 
	push ax
	push bx
	mov bx, %1     		;load the pointer to our string
	mov ah, LightRedOnBlack
	call print_string   ;print the string
	pop bx
	pop ax
%endmacro

%macro  WriteLine 1-2 0
	push ax
	push bx
	mov bx, %1
	mov ax, %2
	call _write
	call new_line
	pop bx
	pop ax
%endmacro

%macro  Write 1-2 0
	push ax
	push bx
	mov bx, %1
	mov ax, %2
	call _write
	pop bx
	pop ax
%endmacro

_write:
	push cx
	cmp ax, 0
	je .print 
	.getstring:
		add bx, [bx]
		add bx, 2	
		dec ax
		jnz .getstring
	.print:
		mov cx, [bx]
		add bx, 2
		mov ah, LightGrayOnBlack
		call print_string   ;print the string
	.return:
	pop cx
ret

%macro  ReadLine 0
	call get_user_input
%endmacro