;********************************************************************************
;   search
;   Purpose:
;      To allow the player to attempt to open a door
;           Prototype:
;               void search();
;           Algorithm:
;               void search(){
;					Console.WriteLine(SearchForTrapStrings[0])
;					if(roll_d20() + roll_d20 > Character.int + Character.wis){
;						Console.WriteLine(SearchForTrapStrings[1]);
;						pass();
;					}
;					else{
;						get_y_bounds(1);
;						get_x_bounds(1);
;						for(int y = yMin; y <  yMax; y++){
;							for(int x = xMin; x < xMax; x++){
;								int tile = CurrentDungeon[y + x];
;								if(tile == 2){
;									Console.WriteLine(SearchForTrapStrings[2]);
;									Console.WriteLine(SearchForTrapStrings[3] + y + SearchForTrapStrings[4] + x + SearchForTrapStrings[5])
;								}
;								else if(tile == 3){
;									Console.WriteLine(SearchForTrapStrings[6]);
;									Console.WriteLine(SearchForTrapStrings[7] + y + SearchForTrapStrings[8] + x + SearchForTrapStrings[9])
;								}
;							}
;							pass();
;						}
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
search:
	WriteLine SearchForTrapStrings, 0
	call roll_d20
	mov ax, bx 
	call roll_d20
	add ax, bx
	mov bx, [Character.int]
	add bx, [Character.wis]
	cmp ax, bx
	jl .loopy
		WriteLine SearchForTrapStrings, 1
		jmp .return

	mov cx, 0
	.loopy:
		mov ch, 1
		call get_y_bounds

		mov dh, 1
		call get_x_bounds
		.loopx:
			mov bh, 0

			add bl, cl
			shl bx, 1
			mov bx, [rows + bx]

			mov al, cl
			mov ah, 0
			add bx, ax

			mov bx, [CurrentDungeon + bx]
			cmp bx, 2
			jne .noTrap
				WriteLine SearchForTrapStrings, 2

				Write SearchForTrapStrings, 3
				mov bx, dx
				call print_dec

				Write SearchForTrapStrings, 4
				mov bx, ax
				call print_dec

				WriteLine SearchForTrapStrings, 5
			.noTrap:
			cmp bx, 3
			jne .noDoor
				WriteLine SearchForTrapStrings, 6

				Write SearchForTrapStrings, 7
				mov bx, dx
				call print_dec

				Write SearchForTrapStrings, 8
				mov bx, ax
				call print_dec

				WriteLine SearchForTrapStrings, 9
			.noDoor:
			inc dl
			cmp dl, dh
			jl .loopx
		pop dx
	inc cl
	cmp cl, ch
	jl .loopy
	.return:
		call pass
ret