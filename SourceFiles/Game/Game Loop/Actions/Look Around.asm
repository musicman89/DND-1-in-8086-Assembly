section .text
;********************************************************************************
;   look_around
;   Purpose:
;      To allow the player to look around
;           Prototype:
;               void look_around();
;           Algorithm:
;               void look_around(){
;					get_y_bounds(5);
;					get_x_bounds(5);
;					for(int y = yMin; y <  yMax; y++){
;						for(int x = xMin; x < xMax; x++){
;								int tile = CurrentDungeon[rows[y] + x];
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
	mov ch, 5
	call get_y_bounds

	mov dh, 5
	call get_x_bounds
	.loopy:
		push dx
		.loopx:
			push dx
			push cx
			mov ch, 0
			mov dh, 0

			call get_tile_number
			pop cx
			pop dx

			mov bl, [CurrentDungeon + bx]
			mov bh, 0
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
			Write Space
			inc dl
			cmp dl, dh
			jle .loopx
		call new_line
	pop dx
	inc cl
	cmp cl, ch
	jle .loopy
	call pass
ret
