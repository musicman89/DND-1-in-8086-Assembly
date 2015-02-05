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
		add byte [ypos], 1 				;Move down a row on the screen
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
	add byte [ypos], 1 				;Progress the cursor down a line
	cmp byte [ypos], 25 			;Check if the cursor has hit the bottom
	jle .return
		call clear_screen
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
;		AX, BX, CX, DX, ES
;	Exceptions:
;		None
;*******************************************************************************
push_character:						;Character Print
	push ax
	push bx
	push cx
	push dx
	mov bx, [VideoMemory]  			;text video memory
	mov es, bx 						;move es to the video memory
									;setting the cursor position
	push ax   						;store the character in ax

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
	mov bx, word [xpos]				;get the current xposition
	shl bx, 1

	add bx, ax						;Set the offset location to bx



	pop ax							;restore the character in ax
	mov [es:bx], ax					;push our character to memory
	pop dx
	pop cx
	pop bx
	pop ax
ret


;********************************************************************************
;	clear_screen
;	Purpose:
;      To clear the screen
;			Prototype:
;				void clear_screen();
;			Algorithm:
;				void clear_screen(){
;					int* memory = VideoMemory
;					for(int x = 0; x < 4000; x++){
;						memory = 0;
;						*memory++;
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
;		ES, DI
;	Exceptions:
;		None
;*******************************************************************************
clear_screen:						;Clear Screen
	mov di, 4000
    mov es, [VideoMemory]

    .loop:
        mov word[es:di], 0
        sub di, 2 					;advance to the next characters
        jnz .loop
	mov byte [xpos], 0 				;Move the cursor back to the left
	mov byte [ypos], 0 				;Move the cursor back to the top
ret

;********************************************************************************
;	new_line
;	Purpose:
;      To advance the cursor to a new line
;			Prototype:
;				void new_line();
;			Algorithm:
;				void new_line(){
;					xposition = 0;
;					yposition++;
;					if(yposition > 25)
;						clear_screen();
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
	add byte [ypos], 1 				;Progress the cursor down a line
	cmp byte [ypos], 24 			;Check if the cursor has hit the bottom
	jle .return
		call clear_screen
	.return:
ret

ypos        dw 0
xpos        dw 0
hexStr      db '0123456789ABCDEF'
decOutput 	times 10 db 0
hexOutput   db '0000 ', 0  			;register value string
VideoMemory dw 0xb800