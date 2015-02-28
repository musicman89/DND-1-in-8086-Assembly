section .text
;********************************************************************************
;   use_magic
;   Purpose:
;      To allow the player to use magic
;           Prototype:
;               void use_magic();
;           Algorithm:
;               void use_magic(){
;					Console.WriteLine(useMagicStrings[0])
;					if(Character.weapon != 0){
;						Console.WriteLine(UseMagicStrings[1]);
;						pass();
;					}
;   				else if(Character.class == "CLERIC") {
;						use_cleric_spell();
;					}
;					else if(Character.class = "WIZARD"){
;						user_wizard_spell();
;					}
;					else{
;						Console.WriteLine(UseMagicStrings[2]);
;						pass();
;					}
;					Console.Read();
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
use_magic:
	WriteLine UseMagicStrings, 0
	cmp byte [Character.weapon], 0
	jne .hasWeapon
	StringCompareInsensitive Character.class, Classes, 2
	jne .wizard
		call use_cleric_spell
		jmp .return
	.wizard:
	StringCompareInsensitive Character.class, Classes, 3
	jne .none
		call user_wizard_spell
		jmp .return
	.none:
		WriteLine UseMagicStrings, 2
		call pass
		jmp .return
	.hasWeapon:
		WriteLine UseMagicStrings, 1
		call pass
	.return:
ret

;********************************************************************************
;   use_cleric_spell
;   Purpose:
;      To allow the player to cast a cleric spell
;           Prototype:
;               void use_cleric_spell();
;           Algorithm:
;               void use_cleric_spell(){
;					Console.WriteLine(UseMagicStrings[3]);
;					int input = int.Parse(Console.ReadLine());
;					int location = check_cleric_spell(input);
;					if(location < 0){
;						Console.WriteLine(UseMagicStrings[4]);
;						pass();
;					}
;					else {
;						remove_cleric_spell(location);
;						if(input == 1) {
;							cleric_kill();
;						}
;						else if(input == 2) {
;							cleric_magic_missile_2();
;						}
;						else if(input == 3) {
;							cleric_cure_light_1();
;						}
;						else if(input == 4) {
;							find_all_traps();
;						}
;						else if(input == 5) {
;							cleric_magic_missile_1();
;						}
;						else if(input == 6) {
;							cleric_magic_missile_3();
;						}
;						else if(input == 7) {
;							cleric_cure_light_2();
;						}
;						else if(input == 8) {
;							find_all_secret_doors();
;						}
;						else if(input == 9) {
;							cleric_repel_undead();
;						}
;						else{
;							Console.WriteLine(UseMagicStrings[4]);
;							pass();
;						}
;
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
use_cleric_spell:
	WriteLine UseMagicStrings, 3
	ReadLine
	call parse_int
	call check_cleric_spell
	cmp ax, 0
	jle .nope
	cmp bx, 1
	jne .no_kill
		call cleric_kill
	.no_kill:
	cmp bx, 2
	jne .no_mm2
		call cleric_magic_missile_2
	.no_mm2:
	cmp bx, 3
	jne .no_cl1
		call cleric_cure_light_1
	.no_cl1:
	cmp bx, 4
	jne .no_fat
		call find_all_traps
	.no_fat:
	cmp bx, 5
	jne .no_mm1
		call cleric_magic_missile_1
	.no_mm1:
	cmp bx, 6
	jne .no_mm3
		call cleric_magic_missile_3
	.no_mm3:
	cmp bx, 7
	jne .no_cl2
		call cleric_cure_light_2
	.no_cl2:
	cmp bx, 8
	jne .no_fasd
		call find_all_secret_doors
	.no_fasd:
	cmp bx, 9
	jne .nope
		call cleric_repel_undead
	.nope:
		WriteLine UseMagicStrings, 4
		call pass
	.return:
ret

;********************************************************************************
;   cleric_repel_undead
;   Purpose:
;      To allow the player to cas the cleric repel undead spell
;           Prototype:
;               void cleric_repel_undead();
;           Algorithm:
;               void cleric_repel_undead(){
;					if(CurrentMonster.type == 4 || CurrentMonster.type == 10){
;						Console.WriteLine(DoneString);
;						move_monster(0,(CurrentMonster.x - Character.x)/(CurrentMonster.x - Character.x);
;						pass();
;					}
;					else{
;						Console.WriteLine(FailedString);
;					}
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_repel_undead:
	cmp byte [CurrentMonster.type], 4
	je .undead
	cmp byte [CurrentMonster.type], 10
	jne .not
	.undead:
		WriteLine DoneString
		mov bl, [CurrentMonster.x]
		add bl, [Character.x]
		mov bh, 0
		mov ax, bx
		div bx
		mov bx, ax
		call move_monster
		call wait_key
		call pass
	.not:
		WriteLine FailedString
		call wait_key
	.return:
ret

;********************************************************************************
;   cleric_kill
;   Purpose:
;      To allow the player to cast the cleric kill spell
;           Prototype:
;               void cleric_kill();
;           Algorithm:
;               void cleric_kill(){
;					if(random_int(3) < 2){
;						Console.WriteLine(DoneString);
;						CurrentMonster.status = -1;
;						pass();
;					}
;					else{
;						Console.WriteLine(FailedString);
;						pass();
;					}
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_kill:
	mov cx, 3
	call random_int
	cmp bx, 2
	jg .fail
		WriteLine DoneString
		mov byte [CurrentMonster.status], -1
		call wait_key
		call pass
	.fail:
		WriteLine FailedString
		call wait_key
		call pass
ret

;********************************************************************************
;   cleric_magic_missile_1
;   Purpose:
;      To allow a player to cast the cleric magic missile #1
;           Prototype:
;               void cleric_magic_missile_1();
;           Algorithm:
;               void cleric_magic_missile_1(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= 2;
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_magic_missile_1:
	WriteLine DoneString
	mov ax, [CurrentMonster.type]
	mov bx, monster_size
	mul bx
	mov bx, ax
	sub word [Monsters + bx + monster.hp], 2
	call wait_key
	call pass
ret

;********************************************************************************
;   cleric_magic_missile_2
;   Purpose:
;      To allow a player to cast the cleric magic missile #2
;           Prototype:
;               void cleric_magic_missile_2();
;           Algorithm:
;               void cleric_magic_missile_2(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= 4;
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_magic_missile_2:
	WriteLine DoneString
	mov ax, [CurrentMonster.type]
	mov bx, monster_size
	mul bx
	mov bx, ax
	sub word [Monsters + bx + monster.hp], 4
	call wait_key
	call pass
ret

;********************************************************************************
;   cleric_magic_missile_3
;   Purpose:
;      To allow a player to cast the cleric magic missile #3
;           Prototype:
;               void cleric_magic_missile_3();
;           Algorithm:
;               void cleric_magic_missile_3(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= 6;
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_magic_missile_3:
	WriteLine DoneString
	mov ax, [CurrentMonster.type]
	mov bx, monster_size
	mul bx
	mov bx, ax
	sub word [Monsters + bx + monster.hp], 6
	call wait_key
	call pass
ret

;********************************************************************************
;   cleric_cure_light_1
;   Purpose:
;      To allow a player to cast the cleric magic missile #3
;           Prototype:
;               void cleric_cure_light_1();
;           Algorithm:
;               void cleric_cure_light_1(){
;					Console.WriteLine(DoneString);
;					Character.hp += 3;
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_cure_light_1:
	WriteLine DoneString
	add word [Character.hp], 3
	call wait_key
	call pass
ret

;********************************************************************************
;   cleric_cure_light_2
;   Purpose:
;      To allow a player to cast the cleric magic missile #3
;           Prototype:
;               void cleric_cure_light_2();
;           Algorithm:
;               void cleric_cure_light_2(){
;					Console.WriteLine(DoneString);
;					Character.hp += 3;
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
cleric_cure_light_2:
	WriteLine DoneString
	add word [Character.hp], 3
	call wait_key
	call pass
ret

;********************************************************************************
;   find_all_traps
;   Purpose:
;      To allow a player to cast the find all traps spell
;           Prototype:
;               void find_all_traps();
;           Algorithm:
;               void find_all_traps(){
;					find(2);
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
find_all_traps:
	mov ax, 2
	call find
ret

;********************************************************************************
;   find_all_secret_doors
;   Purpose:
;      To allow a player to cast the find all secret doors spell
;           Prototype:
;               void find_all_secret_doors();
;           Algorithm:
;               void find_all_secret_doors(){
;					find(3);
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
find_all_secret_doors:
	mov ax, 3
	call find
ret

;********************************************************************************
;   find
;   Purpose:
;      To allow a player to cast the find spell
;           Prototype:
;               void find(byte tile);
;           Algorithm:
;               void find(byte tile){
;					var y_bounds = get_y_bounds(3);
;					var x_bounds = get_x_bounds(3);
;					for(int y = y_bounds.lower; y < y_bounds.upper; y++){
;						int row = rows[y];
;						for(int x = x_bounds.lower; x < x_bounds.upper; x++){
;							if(CurrentDungeon[row + x] == tile){
;								Console.WriteLine(UseMagicStrings[6] + x + UseMagicStrings[7] + y + UseMagicStrings[8]);
;							}
;						}
;					}
;					Console.WriteLine(UseMagicStrings[5]);
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
find:
	mov ch, 3
	mov dh, 3
	call get_x_bounds
	call get_y_bounds
	.y_loop:
		mov bh, 0
		mov bl, cl
		shl bx, 1
		mov bx, [rows + bx]
		push dx
		.x_loop:
		push bx
		push dx
		mov dh, 0
		add bx, dx
		pop dx
		cmp [CurrentDungeon + bx], ax
		jne .no_match
			Write UseMagicStrings, 6
			mov bl, dl
			call print_dec

			Write UseMagicStrings, 7
			mov bl, cl
			call print_dec

			WriteLine UseMagicStrings, 8
		.no_match:
		inc dl
		cmp dl, dh
		jl .x_loop
		pop dx
	inc cl
	cmp cl, ch
	jl .y_loop
ret

;********************************************************************************
;   user_wizard_spell
;   Purpose:
;      To allow the player to cast a wizard spell
;           Prototype:
;               void user_wizard_spell();
;           Algorithm:
;               void user_wizard_spell(){
;					Console.WriteLine(UseMagicStrings[9]);
;					int input = int.Parse(Console.ReadLine());
;					int location = check_wizard_spell(input);
;					if(location < 0){
;						Console.WriteLine(UseMagicStrings[10]);
;						pass();
;					}
;					else {
;						remove_wizard_spell(location);
;						if(input == 1) {
;							wizard_push();
;						}
;						else if(input == 2) {
;							wizard_kill();
;						}
;						else if(input == 3) {
;							find_all_traps();
;						}
;						else if(input == 4) {
;							wizard_teleport();
;						}
;						else if(input == 5) {
;							wizard_change_1_0();
;						}
;						else if(input == 6) {
;							wizard_magic_missile_1();
;						}
;						else if(input == 7) {
;							wizard_magic_missile_2();
;						}
;						else if(input == 8) {
;							wizard_magic_missile_3();
;						}
;						else if(input == 9) {
;							find_secret_doors();
;						}
;						else if(input == 10) {
;							wizard_change_0_1();
;						}
;						else{
;							Console.WriteLine(UseMagicStrings[10]);
;							pass();
;						}
;
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
user_wizard_spell:
	WriteLine UseMagicStrings, 9
	ReadLine
	call parse_int
	call check_wizard_spell
	cmp ax, 0
	jle .nope
	cmp bx, 1
	jne .no_push
		call wizard_push
	.no_push:
	cmp bx, 2
	jne .no_kill
		call wizard_kill
	.no_kill:
	cmp bx, 3
	jne .no_fat
		call find_all_traps
	.no_fat:
	cmp bx, 4
	jne .no_teleport
		call wizard_teleport
	.no_teleport:
	cmp bx, 5
	jne .no_change_1
		call wizard_change_1_0
	.no_change_1:
	cmp bx, 6
	jne .no_mm1
		call wizard_magic_missile_1
	.no_mm1:
	cmp bx, 7
	jne .no_mm2
		call wizard_magic_missile_2
	.no_mm2:
	cmp bx, 8
	jne .no_mm3
		call wizard_magic_missile_3
	.no_mm3:
	cmp bx, 9
	jne .no_fasd
		call find_all_secret_doors
	.no_fasd:
	cmp bx, 10
	jne .nope
		call wizard_change_0_1
	.nope:
		WriteLine UseMagicStrings, 10
		call pass
	.return:
ret


;********************************************************************************
;   wizard_magic_missile_1
;   Purpose:
;      To allow a player to cast the wizard magic missile #1
;           Prototype:
;               void wizard_magic_missile_1();
;           Algorithm:
;               void wizard_magic_missile_1(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= (3 + random_int(11));
;					Console.WriteLine(UseMagicStrings[11]);
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_magic_missile_1:
	WriteLine DoneString
	mov cx, 11
	call random_int
	mov dx, bx
	add dx, 3

	mov ax, [CurrentMonster.type]
	mov bx, monster_size
	mul bx
	mov bx, ax
	sub word [Monsters + bx + monster.hp], dx
	WriteLine UseMagicStrings, 11
	call wait_key
	call pass
ret

;********************************************************************************
;   wizard_magic_missile_2
;   Purpose:
;      To allow a player to cast the wizard magic missile #2
;           Prototype:
;               void wizard_magic_missile_2();
;           Algorithm:
;               void wizard_magic_missile_2(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= (6 + random_int(11));
;					Console.WriteLine(UseMagicStrings[11]);
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_magic_missile_2:
	WriteLine DoneString
	mov cx, 11
	call random_int
	mov dx, bx
	add dx, 6

	mov ax, [CurrentMonster.type]
	mov bx, monster_size
	mul bx
	mov bx, ax
	sub word [Monsters + bx + monster.hp], dx
	WriteLine UseMagicStrings, 11
	call wait_key
	call pass
ret

;********************************************************************************
;   wizard_magic_missile_3
;   Purpose:
;      To allow a player to cast the wizard magic missile #3
;           Prototype:
;               void wizard_magic_missile_3();
;           Algorithm:
;               void wizard_magic_missile_3(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= (9 + random_int(11));
;					Console.WriteLine(UseMagicStrings[11]);
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_magic_missile_3:
	WriteLine DoneString
	mov cx, 11
	call random_int
	mov dx, bx
	add dx, 9

	mov ax, [CurrentMonster.type]
	mov bx, monster_size
	mul bx
	mov bx, ax
	sub word [Monsters + bx + monster.hp], dx
	WriteLine UseMagicStrings, 11
	call wait_key
	call pass
ret

;********************************************************************************
;   wizard_teleport
;   Purpose:
;      To allow a player to cast the wizard teleport spell
;           Prototype:
;               void wizard_teleport();
;           Algorithm:
;               void wizard_teleport(){
;					Console.WriteLine(UseMagicStrings[12]);
;					Console.WriteLine(UseMagicStrings[7]);
;					Character.x = int.Parse(Console.Read());
;					Console.WriteLine(UseMagicStrings[8]);
;					Character.y = int.Parse(Console.Read());
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_teleport:
	WriteLine UseMagicStrings, 12
	WriteLine UseMagicStrings, 7
	ReadLine
	call parse_int
	mov byte [Character.x], bl
	WriteLine UseMagicStrings, 8 
	ReadLine
	call parse_int
	mov byte [Character.x], bl
	call pass
ret

;********************************************************************************
;   wizard_change_0_1
;   Purpose:
;      To allow a player to cast the wizard change 1 0 spell
;           Prototype:
;               void wizard_change_1_0(byte tile);
;           Algorithm:
;               void wizard_change_1_0(byte tile){
;					wizard_change(1);
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_change_0_1:
	mov al, 1
	call wizard_change
ret

;********************************************************************************
;   wizard_change_1_0
;   Purpose:
;      To allow a player to cast the wizard change 1 0 spell
;           Prototype:
;               void wizard_change_1_0(byte tile);
;           Algorithm:
;               void wizard_change_1_0(byte tile){
;					wizard_change(0);
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_change_1_0:
	mov al, 0
	call wizard_change
ret

;********************************************************************************
;   wizard_change
;   Purpose:
;      To allow a player to cast the wizard change spell
;           Prototype:
;               void wizard_change(byte tile);
;           Algorithm:
;               void wizard_change(byte tile){
;					Console.WriteLine(UseMagicStrings[12]);
;					Console.WriteLine(UseMagicStrings[7]);
;					int x = int.Parse(Console.Read());
;					Console.WriteLine(UseMagicStrings[8]);
;					int y = int.Parse(Console.Read());
;					if(CurrentDungeon[rows[y] + x] == 0 || CurrentDungeon[rows[y] + x] ==1){
;						CurrentDungeon[rows[y] + x] = tile;
;						Console.WriteLine(DoneString);
;					}
;					else{
;						Console.WriteLine(FailedString)
;					}
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_change:
	WriteLine UseMagicStrings, 12
	WriteLine UseMagicStrings, 7
	ReadLine
	call parse_int
	mov cx, bx
	Write UseMagicStrings, 8
	ReadLine
	call parse_int
	shl bx, 1
	mov bx, [rows + bx]
	add bx, cx
	mov cx, [CurrentDungeon + bx]
	cmp cx, 1
	jg .fail
		WriteLine DoneString
		mov [CurrentDungeon + bx], al
		jmp .return
	.fail:
		WriteLine FailedString
	.return:
	call pass		
	call wait_key
ret

;********************************************************************************
;   wizard_kill
;   Purpose:
;      To allow a player to cast the wizard kill spell
;           Prototype:
;               void wizard_kill();
;           Algorithm:
;               void wizard_kill(){
;					if(random_int(3) > 1){
;						CurrentMonster.status = -1;
;						Console.WriteLine(DoneString);
;					}
;					else{
;						Console.WriteLine(FailedString)
;					}
;					pass();
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_kill:
	mov cx, 3
	call random_int
	cmp bx, 1
	jg .fail
		mov byte[CurrentMonster.status], -1
		WriteLine DoneString
		jmp .return;
	.fail:
		WriteLine FailedString
	.return:
	call wait_key
	call pass
ret

;********************************************************************************
;   wizard_push
;   Purpose:
;      To allow a player to cast the wizard push spell
;           Prototype:
;               void wizard_push();
;           Algorithm:
;               void wizard_push(){
;					bool force = false;
;					if(CurrentMonster.x == Character.x && CurrentMonster.y == Character.y){
;						force = true;
;					}
;					Console.WriteLine(UseMagicStrings[13]);
;					push_monster(force);
;				}
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
wizard_push:
	mov ax, 0
	mov dl, [Character.x]
	cmp dl, [CurrentMonster.x]
	jne .no_force
		mov dl, [Character.y]
		cmp dl, [CurrentMonster.y]
		jne .no_force
		mov ax, 1
	.no_force:
		WriteLine UseMagicStrings, 13
		call push_monster
ret