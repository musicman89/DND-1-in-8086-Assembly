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
	mov cl, 0
	mov dl, 0
	.loopy:
		push dx
		.loopx:
			mov bh, 0

			add bl, cl
			shl bx, 1
			mov bx, [rows + bx]

			mov al, cl
			mov ah, 0
			add bx, ax

			mov bx, [CurrentDungeon + bx]
			call print_dec
			inc dl
			cmp dl, 25
			jl .loopx
		pop dx
		call new_line
	inc cl
	cmp cl, 25
	jl .loopy
ret