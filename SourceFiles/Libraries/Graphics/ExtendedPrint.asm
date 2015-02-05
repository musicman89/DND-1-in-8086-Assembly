;*******************************************************************************
;	Print.asm - x86 Assembly Print Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed to print an output to the screen
;
;*******************************************************************************

;********************************************************************************
;	print_string
;	Purpose:
;      To print a string to the screen using the print function.
;			Prototype:
;				void print_string(byte* string_address);
;			Algorithm:
;				void print_string(byte* string_address){
;					while(string_address != 0){
;						if(*string_address == 10){
;							yposition = 1;
;						}
;						else if(*string_address == 13){
;							xposition = 0;
;						}
;						else{
;							print(*string_address);
;						}
;						string_address++;
;					}
;				}
;				
;	Entry:
;       Byte String Address in Register BX
;	Exit:
;       None
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
print_string:
	push bx
	push ax
	test ah, ah
	jnz .loop
		mov ah, LightGrayOnBlack			;set the text color 
	.loop:
		mov al, [bx]					;Load the current byte of the string
		test al, al						;Test AL for the null terminator (0)
		jz .return             			;If it is, this is the end of the string

		inc bx							;Advance the address to the next character
		
		cmp al, 10	 					;Check for a Line Feed Character
		je .line_feed					;Perform a Line Feed if it is

		cmp al, 13						;Check for a Carriage Return Character
		je .carriage_return				;Perform a Carriage Return if it is

		call print						;Print the character
		jmp .loop
	.line_feed:
		cmp byte [ypos], 23 			;Check if the cursor has hit the bottom
		je .scroll
			add byte [ypos], 1 				;Progress the cursor down a line
			jmp .loop
		.scroll:
			call scroll
		jmp .loop
	.carriage_return:
		mov byte [xpos], 0     			;Restart at the left
		jmp .loop
	.return:
		pop ax
		pop bx
ret	

;********************************************************************************
;	print
;	Purpose:
;      To print a character to the screen
;			Prototype:
;				void print(byte character);
;			Algorithm:
;				void print(byte character){
;					push_character(character);
;					xposition++;
;					if(xposition > 80){
;						xposition = 0;
;						yposition++;
;						if(yposition > 25){
;							clear_screen();
;						}
;					}
;				}
;	Entry:
;       Constant Character in Register AL 
;	Exit:
;       None
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
print:
	call push_character
	add byte [xpos], 1      		;Move the cursor 1 to the right
	cmp byte [xpos], 80   			;check if the cursor has hit the right 

	jle .return
	mov byte [xpos], 0 				;Move the cursor back to the left
	cmp byte [ypos], 23 			;Check if the cursor has hit the bottom
	je .scroll
		add byte [ypos], 1 				;Progress the cursor down a line
	jmp .return
	.scroll:
		call scroll
	.return:
ret

;********************************************************************************
;	push_character
;	Purpose:
;      To push a character into video memory
;			Prototype:
;				void push_character(byte character);
;			Algorithm:
;				void push_character(byte character){
;					location = VideoMemory + (yposition * 160) + (xposition * 2)
;					*location = character;
;				}
;				
;	Entry:
;       Byte Character in Register AX
;	Exit:
;       None
;	Uses:
;		AX, BX, CX, DX, ES, DI
;	Exceptions:
;		None
;*******************************************************************************
push_character:						;Character Print
	push ax
	push bx
	push cx
	push dx
	mov cx, [VideoMemory]  			;text video memory
	mov es, cx 						;move es to the video memory
									;setting the cursor position
	mov bx, ax   					;store the character in ax in the register BX

									;get the row
	mov ax, word [ypos] 			;get the current yposition
									;we want to multiply the position by 160 
									;(2 bytes per character 80 characters per row)
									;a bitshift is faster than multiplication 
									;(ax * 128 + bx * 32 = ax * 160)
	mov dx, ax 						;we copy ax to dx
	mov cl, 7
	shl ax, cl 						;then shift ax by 7 (ax * 128) 
	mov cl, 5
	shl dx, cl 						;we shift bx by 5 (dx * 32)
	add ax, dx 						;then add ax and dx 

									;get the column
	mov di, word [xpos]				;get the current xposition
	shl di, 1

	add di, ax						;Set the offset location to di

	mov [es:di], bx					;push our character to memory
	pop dx
	pop cx
	pop bx
	pop ax
ret

;********************************************************************************
;	clear_screen
;	Purpose:
;      To push a character into video memory
;			Prototype:
;				void clear_screen();
;			Algorithm:
;				void clear_screen(){
;					character = ' '
;					xposition = 0;
;					yposition = 0;
;					while(yposition <= 25){
;						print(character);
;					}
;					xposition = 0;
;					yposition = 0;
;				}
;				
;	Entry:
;       None
;	Exit:
;       None
;	Uses:
;		AX
;	Exceptions:
;		None
;*******************************************************************************
clear_screen:						;Clear Screen
	push ax
	push bx
	push cx
	push dx
	mov di, 4000
    mov es, [VideoMemory]

    .loop:
        mov word[es:di], 0
        sub di, 2 					;advance to the next characters
        jnz .loop
	mov byte [xpos], 0 				;Move the cursor back to the left
	mov byte [ypos], 0 				;Move the cursor back to the top
	pop dx
	pop cx
	pop bx
	pop ax
ret

;********************************************************************************
;	new_line
;	Purpose:
;      To push a character into video memory
;			Prototype:
;				void new_line();
;			Algorithm:
;				void new_line(){
;					xposition = 0;
;					yposition++;
;					if(yposition > 25)
;						scroll();
;					}
;				}
;				
;	Entry:
;       None
;	Exit:
;       None
;	Uses:
;		None
;	Exceptions:
;		None
;*******************************************************************************
new_line:
	mov byte [xpos], 0 				;Move the cursor back to the left
	cmp byte [ypos], 23 			;Check if the cursor has hit the bottom
	jge .scroll
		add byte [ypos], 1 				;Progress the cursor down a line
	jmp .return
	.scroll:
		call scroll
	.return:
ret

;********************************************************************************
;	scroll
;	Purpose:
;      Scroll the screen
;			Prototype:
;				void scroll();
;			Algorithm:
;				void scroll(){
;				}
;				
;	Entry:
;       None
;	Exit:
;       None
;	Uses:
;		None
;	Exceptions:
;		None
;*******************************************************************************
scroll:
	push ax
	push bx
	push cx
		mov cx, 3840
		mov ax, [VideoMemory] 
		add ax, 10
		mov bx, [VideoMemory]
		call extended_mem_copy
	pop cx
	pop bx
	pop ax
ret

;********************************************************************************
;	scroll
;	Purpose:
;      Scroll the screen
;			Prototype:
;				void scroll();
;			Algorithm:
;				void scroll(){
;				}
;				
;	Entry:
;       None
;	Exit:
;       None
;	Uses:
;		None
;	Exceptions:
;		None
;*******************************************************************************
print_hex:
	push bx
	push dx
	push ax
	mov di, hexOutput			;Store address of our output in the DI register
	mov ax, bx					;Push our Value to the AX register
	mov ch, 0x04   				;Set CH to 4 since we have 2 bytes in our register
	.hexloop: 		
		mov cl, 0x04			;We want to shift our register by 4
		rol ax, cl 				;Shift the BX register by the Value in CL to reverse the order
		mov bx, ax       		;Push the value back to BX
		and bx, 0x0f     		;Logical AND the value of BX with 0x0F to filter to one Value
		mov bl, [hexStr + bx]	;Push the character at the offset of the value of BX in the Hex String
		mov [di], bl			;Store this character in our output string buffer
		inc di					;Increment the address of the string buffer
		dec ch					;Decrement the value in CH
		jnz .hexloop			;As long as CX is greater than 0, repeat

	mov bx, hexOutput
	call print_string
	pop ax
	pop dx
	pop bx
ret

print_dec:
	push dx
	push cx
	push bx
	push ax

	mov di, decOutput			;Store address of our output in the DI register
	mov ax, bx					;Push our Value to the AX register

	mov bx, 10 					;Push 10 into our BX register for multiplication later
	mov cx, 0 					;Set CX to 0 we are going to store our length in it for flipping the string

	cmp ax, 0 					;Check if our number is positive
	jge .decloop
		xor dx, dx  			;Clear DX
		mov word[di], '-'	 	;Prepend our string with a -
		inc di 					;Increment our string
		xor ax, 0xFFFF 			;Make our number positive
		inc ax 					;Adjust for the twos compliment switch
	.decloop: 	
		xor dx, dx 				;Clear DX
		div bx 					;Divide our value by 10

		add dx, '0' 			;Adjust the remainder to be the character representation of our number
		push dx					;Push the character to the stack
		inc cx 					;Increment our counter
		
		cmp ax, 0 				
		jnz .decloop			;As long as AX is greater than 0, repeat

	.flipLoop:					;Our number is backwards lets flip it
		pop dx 					;Pull the first number from the stack
		mov [di], dx 			;Push it into the current position in our string
		inc di 					;Increment our string pointer 
		dec cx 					;Decrement the number of remaining characters
		jnz .flipLoop     		;If there are remaining characters repeat
		mov Word[di], 0 		;Append a 0 as the null terminator of the string
	mov bx, decOutput			;Move BX to point to our string
	call print_string			;Print our string
	pop ax
	pop bx
	pop cx
	pop dx
ret

ypos        dw 0
xpos        dw 0
hexStr      db '0123456789ABCDEF'
decOutput 	times 10 db 0
hexOutput   db '0000 ', 0  			;register value string
VideoMemory dw 0xb800

BlankMemory times 4000 dw 0