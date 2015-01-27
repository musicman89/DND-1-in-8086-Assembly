;*******************************************************************************
;	StringFunctions.asm - x86 Assembly String Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for string comparison and manipulation
;
;*******************************************************************************

;********************************************************************************
;	char_to_lower
;	Purpose:
;      To make sure a character is lower case
;			Prototype:
;				byte char_to_lower(byte character);
;			Algorithm: 
;				byte char_to_lower(byte character){
;					if(character > 'Z' || character < 'A'){
;						return character;
;					}
;					else{
;						return character + ('a' - 'A');	
;					}
;				}
;
;	Entry:
;       character in register AL
;	Exit:
;       character in register AL
;	Uses:
;		AL
;	Exceptions:
;		input not a character
;*******************************************************************************
char_to_lower:
    cmp al, 'Z'
    jg .IsLower
	
	cmp al, 'A'
	jl .IsLower
	
    add al, 'a'-'A'
    .IsLower:
ret

;********************************************************************************
;	char_to_upper
;	Purpose:
;      To make sure a character is lower case
;			Prototype:
;				byte char_to_upper(byte character);
;			Algorithm: 
;				byte char_to_upper(byte character){
;					if(character < 'a' || character > 'z'){
;						return character;
;					}
;					else{
;						return character - ('a' - 'A');	
;					}
;				}
;
;	Entry:
;       character in register AL
;	Exit:
;       character in register AL
;	Uses:
;		AL
;	Exceptions:
;		input not a character
;*******************************************************************************
char_to_upper:
    cmp al, 'a'
    jl .IsUpper

	cmp al, 'z'
	jg .IsUpper
	
    sub al, 'a'-'A'
    .IsUpper:
ret

;********************************************************************************
;	substr
;	Purpose:
;      To get a substring
;			Prototype:
;				word substr(byte string_address, int length);
;			Algorithm: 
;				word substr(byte* string_address, int length){
;					byte* buffer_address = StringBuffer;
;					while(length > 0 && *string_address !=0){
;						*buffer_address = *string_address;
;						length--;
;						string_address++;
;						buffer_address++
;					}
;					return StringBuffer;
;				}
;
;	Entry:
;       string_address in register BX, length in register CX
;	Exit:
;       The address of the sub-string in register BX
;	Uses:
;		AX, BX, CX, SI
;	Exceptions:
;		None
;*******************************************************************************
substr:
	push ax
	push cx
	mov si, StringBuffer
	test cx, cx
	jz .done
	.single:
		mov al, [bx]
		test al, al 
		jz .done
		
		mov byte[si], al

		inc si
		inc bx
		dec cx
		jnz .single

	.done:
		mov word [si], 0x0000
		mov bx, StringBuffer
        align   4
	pop cx
	pop ax
ret

;********************************************************************************
;	string_compare
;	Purpose:
;      To compare two strings
;			Prototype:
;				word string_compare(byte string_addressA, byte string_addressB);
;			Algorithm: 
;				word string_compare(byte string_addressA, byte string_addressB){
;					while(true){
;						key = get_key();
;						if(*string_addressA > *string_addressB){
;							return 1;
;						}
;						else if(*string_addressA < *string_addressB){
;							return -1;
;						}
;						if(*string_addressA == 0){
;							return 0;
;						}
;						string_addressA++;
;						string_addressB++
;					}
;				}
;
;	Entry:
;       string_addressA in register CX, string_addressB in register DX
;	Exit:
;       AX == 0 if stringA == stringB, AX == -1 if stringA < stringB, AX == 1 if stringA > stringB
;	Uses:
;		AX, BX, CX, DX
;	Exceptions:
;		None
;*******************************************************************************
string_compare:
	push bx
	push cx
	push dx
        .compareword:
            mov     bx, dx
            mov     ax,[bx]

            mov     bx, cx

            cmp     al,[bx]
            jne     .donene
            test    al,al
            jz      .doneeq

            cmp     ah,[bx + 1]
            jne     .donene
            test    ah,ah
            jz      .doneeq

            add     dx, 2
            add     cx, 2
            jmp     .compareword
        align   8

        .doneeq:
            xor     ax,ax	;clear ax
			pop dx
			pop cx
			pop bx
			ret

        align   8
        .donene:
            sbb     ax,ax	;clear all but the sign bit
            or      ax,1	;set the value to 1, ax will equal -1 if stringA < stringB and 1 if stringA > stringB
			pop dx
			pop cx
			pop bx
			ret

        align   16
	pop dx
	pop cx
	pop bx
ret

string_compare_insensitive:
	StringCopy cx, StringCompareBuffer1
	StringCopy dx, StringCompareBuffer2
	StringToUpper StringCompareBuffer1
	StringToUpper StringCompareBuffer2
	StringCompare StringCompareBuffer1,StringCompareBuffer2	
ret

StringCompareBuffer1 times 255 db 0
StringCompareBuffer2 times 255 db 0
;********************************************************************************
;	to_lower
;	Purpose:
;      Make a string lower case
;			Prototype:
;				word to_lower(byte string_address);
;			Algorithm: 
;				word to_lower(byte string_address){
;					byte buffer = string_address;
;					while(true){
;						if(*buffer == 0){
;							return string_address;
;						}
;						char_to_lower(*buffer);
;						buffer++
;					}
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
to_lower:
	push ax
	push bx
    .loop:
        mov ax, [bx]				;load the current byte of the string
        test al, al 				;check for the end of the string
        jz .return
                 
	    call char_to_lower
        mov [bx], al
        
		mov al, ah					;shift the byte from AH to AL
		test al, al 				;check for the end of the string
        jz .return
        
		call char_to_lower
        mov [bx + 1], al
		
        add bx, 2 					;advance to the next characters
        jmp .loop
        .return:
		pop bx
		pop ax
ret

;********************************************************************************
;	to_upper
;	Purpose:
;      Make a string upper case
;			Prototype:
;				word to_upper(byte string_address);
;			Algorithm: 
;				word to_upper(byte string_address){
;					byte buffer = string_address;
;					while(true){
;						if(*buffer == 0){
;							return string_address;
;						}
;						char_to_upper(*buffer);
;						buffer++
;					}
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
to_upper:
	push ax
	push bx
    .loop:
        mov ax, [bx]				;load the current byte of the string
        test al, al 				;check for the end of the string
        jz .return
                 
	    call char_to_upper
        mov [bx], al
        
		mov al, ah					;shift the byte from AH to AL
		test al, al 				;check for the end of the string
        jz .return
        
		call char_to_upper
        mov [bx + 1], al

        add bx, 2 					;advance to the next characters
        jmp .loop
        .return:
		pop bx
		pop ax
ret
string_copy:
	push ax
	push bx
	push cx
	push dx
    .loop:
		mov bx, cx
        mov ax, [bx]				;load the current byte of the string

        mov bx, dx
        mov [bx], al
		test al, al 				;check for the end of the string
        jz .return
		
		mov al, ah					;shift the byte from AH to AL

        mov [bx + 1], al
		test al, al 				;check for the end of the string
        jz .return
        
        add cx, 2 					;advance to the next characters
		add dx, 2
        jmp .loop
        .return:
	pop dx
	pop cx
	pop bx
	pop ax
ret
get_string_array:
    mov dx, 1

    cmp cx, dx
    je .return

    sub bx, 1
    .loop:
        inc bx
        mov al, [bx]
        test al, al
        jnz .loop
    .inc:
        cmp al, [bx+3]
        je .return

        inc dx
        cmp dx, cx
        jl .loop
        inc bx
    .return:
ret

string_length:
	push ax
	push bx
	mov cx, 0
    .loop:
        mov ax, [bx]				;load the current byte of the string
        test al, al 				;check for the end of the string
        jz .return
                 
	    inc cx
        
		mov al, ah					;shift the byte from AH to AL
		test al, al 				;check for the end of the string
        jz .return
        
		inc cx
		
        add bx, 2 					;advance to the next characters
        jmp .loop
	.return:
	pop bx
	pop ax
ret