
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
		WriteLine OpenDoorStrings, 0
		call to_upper
		call get_user_input
		cmp byte [bx], 'R'
		je .right

		StringCompare bx, DirectionStrings,  1
		je .right

		cmp byte [bx], 'L'
		je .left

		StringCompare bx, DirectionStrings,  0
		je .left
		
		cmp byte [bx], 'U'
		je .up

		StringCompare bx, DirectionStrings, 2
		je .up
		
		cmp byte [bx], 'D'
		je .down

		StringCompare bx, DirectionStrings, 3
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
		WriteLine OpenDoorStrings, 1
		jmp .return
	.door:
		WriteLine OpenDoorStrings, 2
		call roll_d20
		cmp bx, [Character.str]
		jl .advance
			WriteLine OpenDoorStrings, 3
			call pass
			jmp .return
		.advance:
			WriteLine OpenDoorStrings, 4
			call advance_position
			jmp .return
	.return:
ret