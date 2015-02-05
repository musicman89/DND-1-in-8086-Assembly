
;********************************************************************************
;   open_door
;   Purpose:
;      To allow the player to attempt to open a door
;           Prototype:
;               void open_door();
;           Algorithm:
;               void open_door(){
;					while(true){
;						Console.WriteLine(OpenDoorStrings[0]);
;						var input = Console.Read().ToUpper();
;						int x = Character.x;
;						int y = Character.y;
;						if(input[0] == "R" || input == "RIGHT"){
;							x = 1;
;							check_door(x,y);
;							return;
;						}
;						else if(input[0] == "L" || input == "LEFT"){
;							x = -1;
;							check_door(x,y);
;							return;
;						}
;						else if(input[0] == "U" || input == "UP"){
;							y = 1;
;							check_door(x,y);
;							return;
;						}
;						else if(input[0] == "D" || input == "DOWN"){
;							y = -1;
;							check_door(x,y);
;							return;
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
open_door:
	mov cl, [Character.x]
	mov dl, [Character.y]
	.loop:
		PrintString OpenDoorStrings + 0 * string_size
		call to_upper
		call get_user_input
		cmp byte [bx], 'R'
		je .right

		StringCompare bx, DirectionStrings + 1 * string_size
		je .right

		cmp byte [bx], 'L'
		je .left

		StringCompare bx, DirectionStrings + 0 * string_size
		je .left
		
		cmp byte [bx], 'U'
		je .up

		StringCompare bx, DirectionStrings + 2 * string_size
		je .up
		
		cmp byte [bx], 'D'
		je .down

		StringCompare bx, DirectionStrings + 3 * string_size
		je .down


	jmp .loop
	.right:
		inc cl
	.left:
		dec cl
	.up:
		inc dl
	.down:
		dec dl

	call check_door
ret

;********************************************************************************
;   check_door
;   Purpose:
;      To allow the player to attempt to open a door
;           Prototype:
;               void check_door(int x, int y);
;           Algorithm:
;               void check_door(int x, int y){
;					int tile = CurrentDungeon[get_tile_number(x,y)];
;					if(tile == 3 || tile == 4){
;						Console.WriteLine(OpenDoorStrings[2]);
;						if(roll_d20() > Character.str){
;							Console.WriteLine(OpenDoorStrings[3]);
;							pass();
;						}
;						else{
;							Console.WriteLine(OpenDoorStrings[4]);
;							advance_position(x,y);
;						}
;					}
;					else{
;						Console.WriteLine(OpenDoorStrings[1])
;					}
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
check_door:
	call get_tile_number
	mov bx, [CurrentDungeon + bx]
	cmp al, 3
	je .door
	cmp al, 4
	je .door
		PrintString OpenDoorStrings + 1 * string_size
		jmp .return
	.door:
		PrintString OpenDoorStrings + 2 * string_size
		call roll_d20
		cmp bx, [Character.str]
		jl .advance
			PrintString OpenDoorStrings + 3 * string_size
			call pass
			jmp .return
		.advance:
			PrintString OpenDoorStrings + 4 * string_size
			call advance_position
			jmp .return
	.return:
ret