;********************************************************************************
;   look_around
;   Purpose:
;      To allow the player to look around
;           Prototype:
;               void look_around();
;           Algorithm:
;               void look_around(){
;					int yMin = 5;
;					if(Character.y < yMin){
;						yMin = Character.y;
;					}
;					int yMax = 5;
;					else if(Character.y + yMax > 25){
;						yMax = 25 - Character.y;
;					}
;					
;					for(int y = Character.y - yMin; y <  Character.y + yMax; y++){
;						int xMin = 5;
;						if(Character.y < xMin){
;							xMin = Character.y;
;						}
;						int xMax = 5;
;						else if(Character.y + xMax > 25){
;							xMax = 25 - Character.y;
;						}
;						int row = y * 25
;						for(int x = Character.x - xMin; x < Character.x + xMax; x++){
;								int tile = CurrentDungeon[row + x];
;								if(tile == 7 || tile == 8) tile = 9;
;								if(tile == 2) tile = 0;
;								if(tile == 3) tile = 1;
;								Console.Write(tile);
;						}
;						Console.NewLine();
;					}
;					pass();
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       AX, BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
look_around:
	mov cl, [Character + player.y]
	mov ch, 10
	cmp cl, 5
	jl .lower_y
	cmp cl, 20
	jg .upper_y
		sub cl, 5
		jmp .starty
	.upper_y:
		mov ah, 25
		sub ah, cl
		sub ch, ah
		sub cl, 5
		jmp .starty
	.lower_y:		
		mov ah, 5
		sub ah, cl
		sub ch, ah
		mov cl, 0
		jmp .starty
	.starty:
		mov dl, [Character + player.x]
		mov dh, 10
		cmp dl, 5
		jl .lower_x
		cmp dl, 20
		jg .upper_x
			sub dl, 5
			jmp .loopy
		.upper_x:
			mov ah, 25
			sub ah, dl
			sub dh, ah
			sub dl, 5
			jmp .loopy
		.lower_x:		
			mov ah, 5
			sub ah, dl
			sub dh, ah
			mov dl, 0
			jmp .loopy
		.loopy:
			push dx
			mov ah, 0
			mov al, cl
			mov bx, 25
			mul bx
			.loopx:
				add bh, 0
				add bl, dl
				add bx, ax
				mov bx, [CurrentDungeon + bx]
				cmp bx, 7
				jne .not7
					mov bx, 9
				.not7:
				cmp bx, 8
				jne .not8
					mov bx, 9
				.not8:
				cmp bx, 2
				jne .not2
					mov bx, 0
				.not2:
				cmp bx, 3
				jne .not3
					mov bx, 1
				.not3:
				call print_dec
				inc dl
				dec dh
				jnz .loopx
			call new_line
			inc cl
			dec ch
			jnz .loopy
	call pass
ret