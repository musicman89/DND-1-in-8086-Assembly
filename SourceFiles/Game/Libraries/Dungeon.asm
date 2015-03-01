section .text

get_current_monster:
	push ax
	push cx
	push dx
		mov bh, 0
		mov bl, [CurrentMonster.type]
		dec bl
		mov ax, monster_size
		mul bx

		mov bx, ax
	pop dx
	pop cx
	pop ax
ret


;********************************************************************************
;   get_y_bounds
;   Purpose:
;      To limit the bounds to the vertical range of the map
;           Prototype:
;               Void get_y_bounds(byte range);
;           Algorithm:
;               Void get_y_bounds(byte range){
;					int starty = Character.y;
;					int endy = 0;
;					if(starty - range > 0){
;						if(starty + range < 25){
;							starty -= range;
;							endy = starty + range * 2;
;						}
;						else{
;							starty = (starty - range) ;
;							endy = 25;
;						}
;					}
;					else{
;						endy = (starty + range) ;
;						starty = 0;
;					}
;               }
;               
;   Entry:
;       Byte Range in CH
;   Exit:
;       starty in CL, endy in CH
;   Uses:
;       AX, BX, CX
;   Exceptions:
;       
;*******************************************************************************
get_y_bounds:
	mov cl, [Character.y]
	mov bl, cl
	sub bl, ch
	cmp bl, 0
	jl .lower_x
		mov bl, cl
		add bl, ch
		cmp bl, 25
	jg .upper_x
		mov bl, cl
		sub cl, ch
		add ch, bl
		jmp .return
	.upper_x:
		sub cl, ch
		mov ch, 25
		jmp .return
	.lower_x:		
		add ch, cl
		mov cl, 0
		jmp .return
	.return:
ret

;********************************************************************************
;   get_x_bounds
;   Purpose:
;      To limit the bounds to the horizongal range of the map
;           Prototype:
;               Void get_x_bounds(byte range);
;           Algorithm:
;               Void get_x_bounds(byte range){
;					int startx = Character.x;
;					int endx = 0;
;					if(startx - range > 0){
;						if(startx + range < 25){
;							startx -= range;
;							endx = startx + range * 2;
;						}
;						else{
;							startx = startx - range;
;							endx = 25;
;						}
;					}
;					else{
;						endx = startx + range;
;						startx = 0;
;					}
;               }
;               
;   Entry:
;       Byte Range in DH
;   Exit:
;       startx in DL, endx in DH
;   Uses:
;       BX, DX
;   Exceptions:
;       
;*******************************************************************************
get_x_bounds:
	mov dl, [Character.x]
	mov bl, dl
	sub bl, dh
	cmp bl, 0
	jl .lower_x
		mov bl, dl
		add bl, dh
		cmp bl, 25
	jg .upper_x
		mov bl, dl
		sub dl, dh
		add dh, bl
		jmp .return
	.upper_x:
		sub dl, dh
		mov dh, 25
		jmp .return
	.lower_x:		
		add dh, dl
		mov dl, 0
		jmp .return
	.return:
ret

get_tile_number:
	mov bx, dx
	shl bx, 1
	mov bx, [rows + bx]
	add bx, cx
ret
