section .text
%define LightGreenOnBlack 0x0A
%define LightRedOnBlack 0x0C
%define LightGrayOnBlack 0x07

%macro  PrintGreenString 1-2 0
	push ax
	push bx
	push cx
	GetString %1, %2
	mov cx, [bx]
	add bx, 2
	mov ah, LightGreenOnBlack
	call print_string   ;print the string
	pop cx
	pop bx
	pop ax
%endmacro

%macro  PrintRedString 1-2 0
	push ax
	push bx
	push cx
	GetString %1, %2
	mov cx, [bx]
	add bx, 2
	mov ah, LightRedOnBlack
	call print_string   ;print the string
	pop cx
	pop bx
	pop ax
%endmacro

%macro  WriteLine 1-2 0
	push ax
	push bx
	push cx
	GetString %1, %2
	mov cx, [bx]
	add bx, 2
	mov ah, LightGrayOnBlack
	call print_string   ;print the string
	call new_line
	pop cx
	pop bx
	pop ax
%endmacro

%macro  Write 1-2 0
	push ax
	push bx
	push cx
	GetString %1, %2
	mov cx, [bx]
	add bx, 2
	mov ah, LightGrayOnBlack
	call print_string   ;print the string
	pop cx
	pop bx
	pop ax
%endmacro

%macro  ReadLine 0
	call get_user_input
%endmacro