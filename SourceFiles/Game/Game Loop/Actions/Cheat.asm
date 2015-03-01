section .text
;********************************************************************************
;   cheat
;   Purpose:
;      To show the map to the player
;           Prototype:
;               void cheat();
;           Algorithm:
;               void cheat(){
;					for(int y = 0; y < 525; y+=25){
;						for(int x = 0; x < 25; x++){
;							Console.Write(CurrentDungeon[y + x]);
;						}
;						Console.NewLine();
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
cheat:
	mov dh, 0
	mov ch, 0
	mov cl, 0
	.loopy:
		mov dl, 0
		.loopx:
			call get_tile_number
			mov bl, [CurrentDungeon + bx]
			mov bh, 0
			call print_dec
			Write Space
			inc dl
			cmp dl, 25
			jl .loopx
		call new_line
	inc cl
	cmp cl, 25
	jl .loopy
ret