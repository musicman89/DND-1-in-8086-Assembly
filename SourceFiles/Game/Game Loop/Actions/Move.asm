
;********************************************************************************
;   move
;   Purpose:
;      To allow the player to move their character
;           Prototype:
;               void move();
;           Algorithm:
;               void move(){
;					Console.WriteLine(MoveStrings[0] + Character.x + MoveStrings[1] + Character.y);
;					while(true){
;						Console.WriteLine(MoveStrings[2]);
;						var input = Console.Read().ToUpper();
;						int x = Character.x;
;						int y = Character.y;
;						if(input[0] == "R" || input == "RIGHT"){
;							x = 1;
;							check_tile(x,y);
;							return;
;						}
;						else if(input[0] == "L" || input == "LEFT"){
;							x = -1;
;							check_tile(x,y);
;							return;
;						}
;						else if(input[0] == "U" || input == "UP"){
;							y = 1;
;							check_tile(x,y);
;							return;
;						}
;						else if(input[0] == "D" || input == "DOWN"){
;							y = -1;
;							check_tile(x,y);
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
move:
	PrintString MoveStrings + 0 * string_size
	mov bx, [Character + player.x]
	call print_dec

	PrintString MoveStrings + 1 * string_size
	mov bx, [Character + player.y]
	call print_dec

	PrintString MoveStrings + 2 * string_size
	call new_line

	mov cl, [Character + player.x]
	mov dl, [Character + player.y]
	.loop:
		PrintString MoveStrings + 3 * string_size
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

	call check_tile
ret

;********************************************************************************
;   check_tile
;   Purpose:
;      To check a tile and attempt to move the player there
;           Prototype:
;               void check_tile(int x, int y);
;           Algorithm:
;               void check_tile(int x, int y){
;					var tile = CurrentDungeon[get_tile_number(x,y)];
;					if(tile == 0){
;						advance_position(x,y);
;					}
;					else if(tile == 2){
;						fall_in_trap(x,y);
;					}
;					else if(tile == 3){
;						find_secret_door(x,y);
;					}
;					else if(tile == 5){
;						run_into_monster(x,y);
;					}
;					else if(tile == 6){
;						find_gold(x,y);
;					}
;					else if(tile == 7){
;						increase_strength(x,y);
;					}
;					else if(tile == 8){
;						increase_con(x,y);
;					}
;					else {
;						hit_wall();
;					}
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       AX, BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
check_tile:
	call get_tile_number
	mov bx, [CurrentDungeon + bx]
	cmp al, 8
	jne .noCon
		call increase_con
		jmp .return

	.noCon:
	cmp al, 7
	jne .noStr
		call increase_strength
		jmp .return

	.noStr:
	cmp al, 6
	jne .noGold
		call find_gold
		jmp .return

	.noGold:
	cmp al, 5
	jne .noMonster
		call run_into_monster
		jmp .return

	.noMonster:
	cmp al, 3
	jne .noSecret
		call find_secret_door
		jmp .return

	.noSecret:
	cmp al, 2
	jne .noTrap
		call fall_in_trap
		jmp .return

	.noTrap:
	cmp al, 0
	jne .oops
		call advance_position

	.oops:
		call hit_wall
	.return:
ret


;********************************************************************************
;   advance_position
;   Purpose:
;      To advance the player's position to the new coordinates
;           Prototype:
;               void advance_position(int x, int y);
;           Algorithm:
;               void advance_position(int x, int y){
;					Character.x = x;
;					Character.y = y;
;					Console.WriteLine(DoneString);
;					pass();
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
advance_position:
	mov [Character + player.x], cl
	mov [Character + player.y], dl
	PrintString DoneString
	call pass
ret

;********************************************************************************
;   hit_wall
;   Purpose:
;      To handle a player running into the wall
;           Prototype:
;               void hit_wall(int x, int y);
;           Algorithm:
;               void hit_wall(int x, int y){
;					Console.WriteLine(HitWallStrings[0]);
;					if(roll_d12 > 9){
;						Console.WriteLine(HitWallStrings[2]);
;						lose_one_hp();
;					}
;					else{
;						Console.WriteLine(HitWallStrings[1]);
;					}
;					pass();
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
hit_wall:
	PrintString HitWallStrings + 0 * string_size
	call roll_d12
	cmp bx, 9
	jg .noDamage
		PrintString HitWallStrings + 2 * string_size
		call lose_one_hp
		jmp .return

	.noDamage:
		PrintString HitWallStrings + 1 * string_size

	.return:
	call pass
ret

;********************************************************************************
;   fall_in_trap
;   Purpose:
;      To handle the player falling into a trap
;           Prototype:
;               void fall_in_trap(int x, int y);
;           Algorithm:
;               void fall_in_trap(int x, int y){
;					Console.WriteLine(TrapStrings[0]);
;					if(roll_d3 <= 2){
;						Console.WriteLine(TrapStrings[1]);
;						lose_one_hp();
;					}
;					Console.WriteLine(TrapStrings[2]);
;					Console.WriteLine(TrapStrings[3]);
;					int spikes = check_inventory(12);
;					if(spikes < 0){
;						Console.WriteLine(TrapStrings[4]);
;						die();
;					}
;					remove_from_inventory(spikes);
;
;					int rope = check_inventory(11);
;					if(rope > 0){
;						Console.WriteLine(TrapStrings[5]);
;						Console.WriteLine(TrapStrings[6]);
;						remove_from_inventory(spikes);
;						remove_from_inventory(rope);
;					}
;					else{
;						Console.WriteLine(TrapStrings[8]);
;						if(roll_d3 == 2){
;							Console.WriteLine(TrapStrings[10]);
;							Console.WriteLine(TrapStrings[11]);
;							lose_one_hp();
;							spikes = check_inventory(12);
;							if(spikes < 0){
;								die();
;							}
;						}
;					}
;					Console.WriteLine(TrapStrings[7]);
;					move();
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
fall_in_trap:
	PrintString TrapStrings + 0 * string_size
	call new_line
	call roll_d3
	cmp bx, 2
	jg .noInitDamage
		PrintString TrapStrings + 1 * string_size
		call new_line
		call lose_one_hp
	.noInitDamage:
	PrintString TrapStrings + 2 * string_size
	call new_line
	PrintString TrapStrings + 3 * string_size
	call new_line

	mov ax, 12
	call check_inventory
	cmp ax, 0

	jge .live
		PrintString TrapStrings + 4 * string_size
		call new_line
		call die

	.live:
	call remove_from_inventory

	mov ax, 11
	call check_inventory
	cmp ax, 0
	jl .iCouldHaveBeenWrong
		PrintString TrapStrings + 5 * string_size
		call new_line
		PrintString TrapStrings + 6 * string_size
		call new_line
		call remove_from_inventory
		jmp .return

	.iCouldHaveBeenWrong:
		PrintString TrapStrings + 8 * string_size
		call roll_d3
		cmp bx, 2
		jne .return
			PrintString TrapStrings + 10 * string_size
			PrintString TrapStrings + 11 * string_size
			call lose_one_hp
			mov ax, 12
			call check_inventory
			cmp ax, 0
			jge .return
				call die
	.return:
		PrintString TrapStrings + 7 * string_size
ret

;********************************************************************************
;   find_secret_door
;   Purpose:
;      To handle the player running into a secret door
;           Prototype:
;               void find_secret_door(int x, int y);
;           Algorithm:
;               void find_secret_door(int x, int y){
;					if(roll_d6 > 4){
;						Console.WriteLine(SecretDoorStrings[0]);
;						Console.WriteLine(SecretDoorStrings[1]);
;						advance_position(x,y);
;					}
;					else{
;						hit_wall();
;					}
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
find_secret_door:
	call roll_d6
	cmp bx, 4
	jg .wall
		PrintString SecretDoorStrings + 0 * string_size
		PrintString SecretDoorStrings + 1 * string_size
		call advance_position
		jmp .return
	.wall:
		call hit_wall
	.return:
ret

;********************************************************************************
;   run_into_monster
;   Purpose:
;      To handle the player running into a monster
;           Prototype:
;               void run_into_monster(int x, int y);
;           Algorithm:
;               void run_into_monster(int x, int y){
;					Console.WriteLine(RunIntoMonsterStrings[0]);
;					Console.WriteLine(RunIntoMonsterStrings[1]);
;					if(flip_coin = 0){
;						Console.WriteLine(RunIntoMonsterStrings[2])
;						lose_hp(6);
;					}
;					pass();
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
run_into_monster:
	PrintString RunIntoMonsterStrings + 0 * string_size
	PrintString RunIntoMonsterStrings + 1 * string_size
	call flip_coin
	cmp bx, 0
	jne .return
		PrintString RunIntoMonsterStrings + 2 * string_size
		mov ax, 6
		call lose_hp

	.return:
		call pass
ret

;********************************************************************************
;   find_gold
;   Purpose:
;      To handle the player finding gold
;           Prototype:
;               void find_gold(int x, int y);
;           Algorithm:
;               void find_gold(int x, int y){
;					Console.WriteLine(FoundGoldStrings[0]);
;					var gp = random_int(500) + 10;
;					Console.WriteLine(gp + FoundGoldStrings[1])
;					add_gold(gp);
;					hit_wall();
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
find_gold:
	PrintString FoundGoldStrings + 0 * string_size

	mov cx, 500
	call random_int
	add bx, 10
	call print_dec

	mov ax, bx
	call add_gold
	PrintString FoundGoldStrings + 1 * string_size

	call hit_wall
ret

;********************************************************************************
;   increase_strength
;   Purpose:
;      To give the player bonus strength
;           Prototype:
;               void increase_strength(int x, int y);
;           Algorithm:
;               void increase_strength(int x, int y){
;					Character.strength++;
;					clear_tile(x,y);
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
increase_strength:
	mov bx, [Character + player.str]
	inc bx
	mov [Character + player.str], bx
	call clear_tile
ret

;********************************************************************************
;   increase_con
;   Purpose:
;      To give the player bonus constitution
;           Prototype:
;               void increase_con(int x, int y);
;           Algorithm:
;               void increase_con(int x, int y){
;					Character.con++;
;					clear_tile(x,y);
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
increase_con:
	mov bx, [Character + player.con]
	inc bx
	mov [Character + player.con], bx
	call clear_tile
ret

;********************************************************************************
;   clear_tile
;   Purpose:
;      To remove anything from the given tile
;           Prototype:
;               void clear_tile(int x, int y);
;           Algorithm:
;               void clear_tile(int x, int y){
;					CurrentDungeon[get_tile_number(x,y)] = 0;
;					if(roll_d100() <= 20){
;						Console.WriteLine(PoisonString);
;						lose_hp(roll_d4());
;						show_hp();
;					}
;					advance_position(x,y);
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       CX, DX
;   Exceptions:
;       
;*******************************************************************************
clear_tile:
	call get_tile_number
	mov byte [CurrentDungeon + bx], 0
	call roll_d100
	cmp bx, 20
	jl .return
		PrintString PoisonString
		call roll_d4
		mov ax, bx
		call lose_hp
		call show_hp
	.return:
	call advance_position
ret