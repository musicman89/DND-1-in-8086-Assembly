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
;						for(int y = -1; y < 2; y++){
;							int row = (Character.y + y) * 25;
;							for(int x = -1; x < 2; x++){
;								int tile = CurrentDungeon[row + Character + player.x + x];
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
	PrintString SearchForTrapStrings + 0 * string_size
	call new_line
	call roll_d20
	mov ax, bx 
	call roll_d20
	add ax, bx
	mov bx, [Character + player.int]
	add bx, [Character + player.wis]
	cmp ax, bx
	jl .letsCheck
		PrintString SearchForTrapStrings + 1 * string_size
		call new_line
		jmp .return

	mov cx, 0
	.letsCheck:
		mov ax, [Character + player.y]
		dec ax
		add ax, cx
		mov bx, 25
		mul bx
		mov dx, 0
		.checkRow:
			mov bx, ax
			add bx, [Character + player.x]
			add bx, dx
			mov bx, [CurrentDungeon + bx]
			mov ax, bx
			cmp ax, 2
			jne .noTrap
				PrintString SearchForTrapStrings + 2 * string_size
				call new_line

				PrintString SearchForTrapStrings + 3 * string_size
				mov bx, dx
				call print_dec

				PrintString SearchForTrapStrings + 4 * string_size
				mov bx, cx
				call print_dec

				PrintString SearchForTrapStrings + 5 * string_size
				call new_line
			.noTrap:
			cmp ax, 3
			jne .noDoor
				PrintString SearchForTrapStrings + 6 * string_size
				call new_line

				PrintString SearchForTrapStrings + 7 * string_size
				mov bx, dx
				call print_dec

				PrintString SearchForTrapStrings + 8 * string_size
				mov bx, cx
				call print_dec

				PrintString SearchForTrapStrings + 9 * string_size
				call new_line
			.noDoor:
		inc dx
		cmp dx, 3
		jne .checkRow
	inc cx
	cmp cx, 3
	jne .letsCheck
	.return:
		call pass
ret