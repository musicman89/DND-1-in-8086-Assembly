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
section .text
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
	add si, 2
	add bx, 2
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
        call string_length
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
;					if(*string_addressA.length != *string_addressB.length) return -1;
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
		.comparelength:
		mov bx, dx
		mov ax, [bx]
		mov bx, cx
		cmp ax, [bx]
		jne .donene
		add dx, 2
		add cx, 2
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

;********************************************************************************
;	string_compare_insensitive
;	Purpose:
;      To compare two strings case insensitively
;			Prototype:
;				word string_compare_insensitive(byte string_addressA, byte string_addressB);
;			Algorithm: 
;				word string_compare_insensitive(byte string_addressA, byte string_addressB){
;					string_copy(string_addressA, StringCompareBuffer1);
;					string_copy(string_addressA, StringCompareBuffer2);
;					to_upper(StringCompareBuffer1);
;					to_upper(StringCompareBuffer2);
;					string_compare(StringCompareBuffer1, StringCompareBuffer2);
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

string_compare_insensitive:
	StringCopy cx, StringCompareBuffer1
	StringCopy dx, StringCompareBuffer2
	StringToUpper StringCompareBuffer1
	StringToUpper StringCompareBuffer2
	StringCompare StringCompareBuffer1,StringCompareBuffer2	
ret

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
	add bx, 2
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
	add bx, 2
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


;********************************************************************************
;	string_copy
;	Purpose:
;      To copy a string from one address to another
;			Prototype:
;				word string_copy(byte string_addressA, byte string_addressB);
;			Algorithm: 
;				word string_copy(byte string_addressA, byte string_addressB){
;					while(*string_addressA != 0){
;						*string_addressB = *string_addressA;
;						string_addressA++;
;						string_addressB++;
;					}
;					*string_addressB = 0
;				}
;
;	Entry:
;       string_addressA in register CX, string_addressB in DX
;	Exit:
;       string_addressA in register CX, string_addressB in DX
;	Uses:
;		AX, BX, CX, DX
;	Exceptions:
;		None
;*******************************************************************************

string_copy:
	push ax
	push bx
	push cx
	push dx

	.set_length:
	mov bx, cx
	mov ax, [bx]

	mov bx, dx
	mov [bx], ax
	add cx, 2
	add dx, 2
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

;********************************************************************************
;	string_length
;	Purpose:
;      Make a string upper case
;			Prototype:
;				byte string_length(byte string_address);
;			Algorithm: 
;				byte string_length(byte string_address){
;					byte count = 0;
;					while(*string_address != 0){
;						count ++;
;					}
;					return count;
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX, count in register CX
;	Uses:
;		AX, BX, CX
;	Exceptions:
;		None
;*******************************************************************************

string_length:
	push ax
	push bx
	add bx, 2
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
	inc cx
	mov [bx], cx
	pop ax
ret

get_string:
	cmp ax, 0
	je .return 
	.getstring:
		add bx, [bx]
		add bx, 2	
		dec ax
		jnz .getstring

	.return:
ret

section .bss
	StringCompareBuffer1 resb 256 
	StringCompareBuffer2 resb 256 