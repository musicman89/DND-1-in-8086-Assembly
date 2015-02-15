;*******************************************************************************
;	KeyboardIO.asm - x86 Assembly Keyboard IO Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for keyboard input
;
;*******************************************************************************


;********************************************************************************
;	get_key
;	Purpose:
;      To get a single key press event
;			Prototype:
;				word get_key();
;				
;	Entry:
;       None
;	Exit:
;       byte character in AL and byte key in AH
;	Uses:
;		AX
;	Exceptions:
;		Disk Read Error
;*******************************************************************************
get_key:
    mov ax, 0x01
    int 0x16 
ret

wait_key:
    mov ax, 0x01
    int 0x16 
ret

;********************************************************************************
;	get_user_input
;	Purpose:
;      To get a string input from the user
;			Prototype:
;				word get_user_input();
;			Algorithm: 
;				word get_user_input(){
;					byte buffer = InputStringBuffer;
;					byte key;
;					while(true){
;						key = get_key();
;						if(key == 0x1c){
;							print_string(newline);
;							return buffer;
;						}
;						if(key != 0x0e){
;							*buffer = key;
;							buffer++
;						}
;						print(key);
;					}
;				}
;
;	Entry:
;       None
;	Exit:
;       byte character in AL and byte key in AH
;	Uses:
;		AX
;	Exceptions:
;		Disk Read Error
;*******************************************************************************
get_user_input:
    mov bx, 0 			
    .loop:
        call get_key 					;Get input from the user
        cmp ah, 0x1c 					;Check if key is the enter key
        je .return  					;If it is return

		cmp ah, 0x0e 					;Check if key is the backspace key
        je .back	  					;If it is return
		
        mov [InputStringBuffer + bx], al;Set the current location in the sting buffer to the character in al
        inc bx 							;Increment the position in the string buffer 
		
		mov ah, 0x07
		call print
		cmp bx, 250
		jge .back
		jmp .loop
		.back:
			cmp bx, 0
			je .loop
			sub byte [xpos], 1      	;Move the cursor 1 to the left
			dec bx
			mov ax, 0x00
			call push_character			;Print the character
		
		jmp .loop
    .return:
    mov byte [InputStringBuffer + bx], 0 ;Null terminate the string	
    call new_line
    mov bx, InputStringBuffer 			;Point BX back to the start of the string buffer

ret

invalid_input:
	WriteLine InvalidInputString
    call wait_key
ret

InputStringBuffer times 255 db 0
InvalidInputString db 'The selection you have entered is invalid press any key to continue',13,10,0