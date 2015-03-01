section .text
;********************************************************************************
;   range_and_hit_check
;   Purpose:
;      To check if the player is in range to attack the monster
;           Prototype:
;               void range_and_hit_check();
;           Algorithm:
;               void range_and_hit_check(){
;					if(CurrentMonster.type != 0){
;						CurrentMonster.distance_x = ABS(CurrentMonster.x - Character.x);
;						CurrentMonster.distance_y = ABS(CurrentMonster.y - Character.y);
;						CurrentMonster.range = get_root(CurrentMonster.distance_x^2 + CurrentMonster.distance_y^2);
;					}
;					else{
;						CurrentMonster.range = 1000;
;					}
;					int chance = roll_d20();
;					if(chance > 18){
;						CurrentMonster.hit = 3; //Critical hit
;					}
;					else if(chance > Monsters[CurrentMonster.type].dex - Character.dex/3){
;						CurrentMonster.hit = 2; //Hit
;					}
;					else if(chance > 17){
;						CurrentMonster.hit = 1; //Barely Missed
;					}
;					else{
;						CurrentMonster.hit = 0; //Completely Missed
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
range_and_hit_check:
	cmp byte [CurrentMonster.type], 0
	je .no_monster
	mov cl, [CurrentMonster.y]
	mov dl, [CurrentMonster.x]

	.monster:
		sub dl, [Character.x]
		mov [CurrentMonster.distance_x], dl

	.getY:
		sub cl, [Character.y]
		mov [CurrentMonster.distance_y], cl

	.getRange:
		mov ah, 0
		mov al, [CurrentMonster.distance_y]
		call abs_int_8
		mov cx, ax
		mul cx
		mov cx, ax

		mov ah, 0
		mov al, [CurrentMonster.distance_x]
		call abs_int_8
		mov dx, ax
		mul dx
		mov bx, ax
		add bx, cx

		call get_root

		mov [CurrentMonster.range], bx
		jmp .hit_check

	.no_monster:
	mov bx, 1000
	mov [CurrentMonster.range], bx

	.hit_check:
		call roll_d20
		cmp bx, 18
		jl .no_crit
			mov byte [CurrentMonster.hit], 3
			jmp .return

		.no_crit:
			push bx 									;We need to get the current monsters attributes
			call get_current_monster
			mov cx, [Monsters + bx + monster.dex]  		;Now we can get the dextarity of the monster

			mov ax, [Character.dex] 					;In ax we will load our character's dextarity

			mov bx, 3 									;Put 3 in dx 
			div bx 										;Divide our dextarity by 3

			sub cx, ax 									;Now subtract this from the monster's dextarity
			pop bx
		
		cmp bx, cx 										;Check if our chance roll was greater than the value we just calculated
		jl .no_hit
			mov byte [CurrentMonster.hit], 2
			jmp .return

		.no_hit:
		cmp bx, 17
		jl .complete_miss
			mov byte [CurrentMonster.hit], 1
			jmp .return

		.complete_miss:
			mov byte [CurrentMonster.hit], 0
	.return:
ret


monster_attack:
	call get_current_monster
	add bx, [Monsters + bx + monster.name]
	Write bx
	WriteLine WatchItString

	mov ax, 10
	call check_inventory
	cmp ax, 0
	jge .tlte

	mov ax, 9
	call check_inventory
	cmp ax, 0
	jge .chain

	mov ax, 8
	call check_inventory
	cmp ax, 0
	jge .leather

		mov dx, Character.dex
		add dx, 6
		jmp .hit
	.tlte:
		mov dx, Character.dex
		add dx, 20
		jmp .hit
	.chain:
		mov dx, Character.dex
		add dx, 16
		jmp .hit
	.leather:
		mov dx, Character.dex
		add dx, 12

	.hit:
		mov cx, 40
		call random_int
		cmp bx, dx
		jl .no_hit
			call monster_hit
			jmp .return
		.no_hit:
		mov cx, 2
		call random_int
		cmp bx, 1
		jg .miss
			call monster_hit_no_damage
			jmp .return
		.miss:
			call monster_miss
		.return:
ret

monster_killed:
	mov byte [CurrentMonster.status], 0
	call get_current_monster	
	add bx, Monsters
	
	push bx 													;We need to get the current monsters attributes

	mov dx, [bx + monster.gold]
	mov [Character.gold], dx
	Write MonsterKilledStrings, 0

	WriteLine bx + monster.name
	mov bx, dx
	Write MonsterKilledStrings, 1
	call print_dec
	WriteLine MonsterKilledStrings, 2

	mov bx, [CurrentMonster.y]
	mov bx, [rows + bx]
	add bx, [CurrentMonster.x]
	mov byte[CurrentDungeon + bx], 0
	mov byte[CurrentMonster.x], 0
	mov byte[CurrentMonster.y], 0
	mov bx, [Character.gold]

	Write MonsterKilledStrings, 3
	call print_dec
	WriteLine MonsterKilledStrings, 4
	pop bx

	cmp byte [Character.continues],1
	je .continue
		mov byte [bx + monster.initGold], 0

	.continue:
		mov byte [bx + monster.gold], 0

	cmp byte [Character.continues], 1
	jg .no_revive
		mov cx, [bx + monster.str]
		mov ax, [bx + monster.initHP]
		mul cx
		mov [bx + monster.hp], ax

		mov cx, [bx + monster.str]
		mov ax, [bx + monster.initGold]
		mul cx
		mov [bx + monster.gold], cx
	.no_revive:
		mov byte [CurrentMonster.type], 0
ret

survive_with_constitution:
	cmp word [Character.con], 9
	jge .live
		call dead
		jmp .return
	.live:
		sub word [Character.con], 2
		inc word [Character.hp]
		call hp_check
	.return:
ret

dead:
	WriteLine DeadString
	call wait_key
	jmp boot
ret

hp_check:
	cmp word[Character.hp], 0 
	jg .might_live
		call survive_with_constitution
	.might_live:
	cmp word[Character.con], 9
	jg .live
		call dead
	.live:
	WriteLine HPCheckString
ret

hp_low:
	cmp word[Character.hp], 1
	jge .watch_it
		call hp_check
		jmp .return

	.watch_it:
		Write HPLowString
		mov bx, [Character.hp]
		call print_dec
		call new_line
	.return:
ret

check_for_random_encounter:
	inc bx
	mov [CurrentMonster.type], bx
	mov cx, 7
	call random_int
	inc bx

	mov ch, bl
	call get_y_bounds

	mov dh, bl
	call get_x_bounds

	.y_loop:
		mov bh, 0
		mov bl, cl
		shl bx, 1
		mov ax, [rows + bx]

		mov bl, [Character.y]
		cmp bl, cl

		jg .py
			sub bl, cl
			cmp bl, 2 
			jle .return_x_loop
			jmp .continue_x
		.py:
			push ax
				mov al, bl
				mov bl, cl
				sub bl, al
			pop ax
			cmp bl, 2
			jle .return_y_loop

		.x_loop:
			mov bl, [Character.x]
			cmp bl, dl
			jg .px
				sub bl, dl
				cmp bl, 2 
				jle .return_x_loop
				jmp .continue_x
			.px:
				push ax
					mov al, bl
					mov bl, dl
					sub bl, al
				pop ax
				cmp bl, 2
				jle .return_x_loop
			.continue_x:
				push cx
					mov cx, 10
					call random_int
				pop cx
				cmp bx, 7
				jg .return_x_loop
			
			mov bh, 0
			mov bl, dl
			add bx, ax

			cmp byte[CurrentDungeon + bx], 0
			jne .return_x_loop
				mov byte[CurrentDungeon + bx], 5
				mov [CurrentMonster.x], dl
				mov [CurrentMonster.y], cl
				jmp .return
			.return_x_loop:
				inc dl
				cmp dl, dh
				jle .x_loop
		.return_y_loop:
		inc cl
		cmp cl, ch
	jle .y_loop
	.return:
ret

reset_monsters:
	inc byte[Difficulty]
	mov cl, 10
	.loop:
		mov bh, 0
		mov bl, cl
		dec bl

		mov ax, monster_size
		mul bx
		mov bx, ax

		mov dx, [Monsters + bx + monster.initHP]
		mov ax, [Difficulty]
		mul dx
		mov [Monsters + bx + monster.hp], ax

		mov dx, [Monsters + bx + monster.initGold]
		mov ax, [Difficulty]
		mul dx
		mov [Monsters + bx + monster.gold], ax
	dec cl
	jnz .loop
	add word[Character.hp], 5
ret

check_for_monsters:
	mov cl, 50
	.zloop:
		mov ch, 9
		.mloop:
			mov bh, 0
			mov bl, ch

			mov ax, monster_size
			mul bx
			mov bx, ax

			cmp word[Monsters + bx + monster.hp], 1
			jle .loopm
				push cx
				mov cx, 1000
				call random_int
				pop cx
				cmp bx, 925
				jle .loopm
					call check_for_random_encounter
					jmp .return
			.loopm:
			dec ch

			jge .mloop
	dec cl
	jnz .zloop
	WriteLine CheckForMonstersStrings, 0
	WriteLine CheckForMonstersStrings, 1
	ReadLine
	StringCompareInsensitive bx, YesString
	je .reset
		cli
		hlt
	.reset:
		call reset_monsters
	.return:
ret

monster_hit:
	WriteLine MonsterHitStrings, 0
	call get_current_monster
	mov cx, [Monsters + bx + monster.str]
	call random_int
	inc bx
	sub [Character.hp], bx
	Write MonsterHitStrings, 1
	mov bx, [Character.hp]
	call print_dec
ret

monster_hit_no_damage:
	WriteLine MonsterHitNoDamageString
ret

monster_miss:
	WriteLine MonsterMissedString
ret

monster_trapped:
	WriteLine MonsterTrappedString
	mov byte[CurrentMonster.status], -1
	call get_current_monster
	mov word[Monsters + bx + monster.gold], 0
ret

monster_battle:
	call range_and_hit_check
	call get_current_monster

	cmp word[Monsters + bx + monster.hp], 1
	jge .itLives
		call monster_killed
	.itLives:
	cmp word[CurrentMonster.range], 2
	jge .outOfRange
		call monster_attack
	.outOfRange:
		call monster_moves
ret

monster_moves:
	mov cl, [CurrentMonster.distance_x]
	mov ch, [CurrentMonster.distance_y]
	cmp cx, 0
	je .return

	cmp cl, ch
	jg .move_x
		mov ah, 0
		mov al, ch
		mov bx, ax
		call abs_int
		div bx
		mov dl, 0
		mov dh, al

	.move_x:
		mov ah, 0
		mov al, cl 
		mov bx, ax 
		call abs_int
		div bx
		mov dh, 0
		mov dl, al

	.check:
		mov cl, [CurrentMonster.x]
		mov ch, [CurrentMonster.y]
		add cl, dl
		add ch, dh

		mov bh, 0
		mov bl, ch 
		mov bx, [rows + bx]
		mov dh, 0
		mov dl, cl
		add bx, dx

		mov dl, [CurrentDungeon + bx]
		cmp dl, 0
		je .closer 

		cmp dl, 6
		jge .closer

		cmp dl, 3
		je .door

		cmp dl, 4
		je .door


		cmp dl, 2
		je .return
			call monster_trapped
		jmp .return
		.closer:
			mov byte [bx], 0
			mov bh, 0
			mov bl, [CurrentMonster.y]
			mov bx, [rows + bx]
			add bx, [CurrentMonster.x]

			mov byte [CurrentDungeon + bx], 0

			mov [CurrentMonster.x], cl
			mov [CurrentMonster.y], ch
			jmp .return

		.door:
			mov bx, 2
			mov ah, 0

			mov al, dl
			mul bx
			mov dl, al

			mov al, dh
			mul bx
			mov dh, al

			jmp .check
		.return:
ret