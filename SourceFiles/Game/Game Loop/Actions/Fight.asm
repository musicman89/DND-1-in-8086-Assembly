fight:
	PrintString FightStrings + 0 * string_size
	mov bh, 0
	mov bl, [Character.weapon]
	mov ax, item_size
	mul bx
	mov bx, ax
	PrintString [Items + bx + item.name]
	call new_line

	mov bh, 0
	mov bl, [CurrentMonster.type]
	cmp bx, 0
	je .return
	mov ax, monster_size
	mul bx
	PrintString [Monsters + bx + monster.name]
	call new_line

	PrintString FightStrings + 1 * string_size
	mov bx, [Character.hp]
	call print_dec
	call new_line

	mov bl, [Character.weapon]
	cmp bl, 0
	jg .not_fists
		call fist_fight
	.not_fists:
	cmp bl, 1
	jg .not_sword
		call attack_with_sword
	.not_sword:
	cmp bl, 2
	jg .no_2_hand
		call attack_with_2_handed_sword
	.no_2_hand:
	cmp bl, 3
	jg .no_dagger
		call attack_with_dagger
	.no_dagger:
	cmp bl, 4
	jg .other
		call food_fight
		jmp .return
	.other:
	cmp bl, 15
	jg .return
		call check_other_weapon
	.return:
		cmp byte [CurrentMonster.hit], 0
		jg .no_pass
		call pass
	.no_pass:
ret

move_monster:
	PrintString MoveMonsterString
	call new_line
	mov bl, [CurrentMonster.y]
	mov bh, 0
	mov ax, [rows + bx]
	mov bl, [CurrentMonster.x]
	add bx, ax

	mov byte [CurrentDungeon + bx], 0

	add [CurrentMonster.x], cl 
	add [CurrentMonster.y], dl

	mov bl, [CurrentMonster.y]
	mov bh, 0
	mov ax, [rows + bx]
	mov bl, [CurrentMonster.x]
	add bx, ax

	mov byte [CurrentDungeon + bx], 5
ret

push_monster:
	call get_user_input
	call to_upper
	mov al, [bx]
	cmp al, 'B'
	je .below

	cmp al, 'A'
	je .above

	cmp al, 'L'
	je .left
		mov dl, 0
		mov cl, 1
		jmp .check_tile

	.below:
		mov dl, -1
		mov cl, 0
		jmp .check_tile

	.above:
		mov dl, 1
		mov cl, 0
		jmp .check_tile

	.left:
		mov dl, 0
		mov cl, -1

	.check_tile:
		mov bl, [CurrentMonster.y]
		add bl, dl
		mov bh, 0
		mov ax, [rows + bx]
		mov bl, [CurrentMonster.x]
		add bl, cl
		add bx, ax
		mov ax, [CurrentDungeon + bx]
		cmp ax, 0
		jne .try_trap
			call move_monster
			jmp .return

		.try_trap:
		cmp ax, 2
		jne .did_not_work
			call monster_trapped_and_killed
			jmp .return

		.did_not_work:
			PrintString DidntWorkString
			call new_line
		.return:
ret

food_fight:
	PrintString FoodFightStrings + 0 * string_size
	call new_line

	PrintString FoodFightStrings + 1 * string_size
	call new_line

	call get_user_input
	StringCompareInsensitive bx, FoodFightStrings + 2 * string_size
	jne .distract
		call check_hit
		jmp .remove_food
	.distract:
		PrintString FoodFightStrings + 3 * string_size
		call new_line

		call push_monster

	.remove_food:
		mov ax, 15
		call check_inventory

		cmp ax, -1
		je .return
		call remove_from_inventory

		mov byte [Character.weapon], 0
	.return:
ret


monster_trapped_and_killed:
	PrintString MonsterTrappedKilledString
	call new_line

	mov byte[CurrentMonster.status], -1
	mov bh, 0
	mov bl, [CurrentMonster.type]
	mov ax, monster_size
	mul bx

	mov word[Monsters + bx + monster.gold], 0
ret

check_hit:
	call roll_d20
	cmp bx, 20
	jne .no_crit
		PrintString CheckHitStrings + 1 * string_size
		call new_line
		mov ax, [Character.str]
		mov bx, 6
		div bx
		call get_current_monster
		sub [Monsters + bx + monster.hp], ax
		jmp .return

	.no_crit:
		mov cx, bx
		call get_current_monster

		mov ax, [Character.dex]
		mov dx, 3
		div dx

		mov dx, [Monsters + bx + monster.dex]
		
		sub dx, ax

	cmp bx, cx
	jle .no_damage

		PrintString CheckHitStrings + 2 * string_size	
		call new_line	
		mov ax, [Character.str]
		mov dx, 8
		div dx
		sub [Monsters + bx + monster.hp], ax
		jmp .return

	.no_damage:
		mov bx, 10
		sub bx, ax
	cmp bx, cx
	jle .total_miss

		PrintString CheckHitStrings + 3 * string_size
		call new_line
		jmp .return

	.total_miss:
		PrintString CheckHitStrings + 0 * string_size
		call new_line
	.return:
ret 

fist_fight:
	PrintString FistFightStrings + 0 * string_size
	call new_line

	PrintString FistFightStrings + 1 * string_size
	call new_line

	call get_user_input
	StringCompareInsensitive bx, NoString
	je .return

	PrintString FistFightStrings + 2 * string_size
	call new_line

	cmp word [CurrentMonster.range], 1
	jg .no_good
		call roll_d20
		mov cx, bx

		call get_current_monster
		cmp [Monsters + bx + monster.dex], cx
		jg .hit
			PrintString FistFightStrings + 4 * string_size
			call new_line
			jmp .return
		.hit:
			PrintString FistFightStrings + 5 * string_size
			mov ax, [Character.str]
			mov dx, 6
			div dx

			sub [Monsters + bx + monster.hp], ax
	.no_good:
		PrintString FistFightStrings + 3 * string_size
		call new_line
	.return:
ret

attack_with_sword:
	PrintString AttackWithSwordStrings + 0 * string_size
	call new_line

	call range_and_hit_check

	cmp word[CurrentMonster.range], 2
	jl .in_range
		PrintString AttackWithSwordStrings + 1 * string_size
		call new_line
		jmp .return
	.in_range:
		mov bx, [CurrentMonster.hit]
		cmp bx, 0
		je .total_miss

		cmp bx, 1
		je .not_good_enough

		cmp bx, 2
		je .hit
			PrintString AttackWithSwordStrings + 2 * string_size	
			call new_line		
			mov ax, [Character.str]
			mov bx, 2
			div bx
			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.hit:
			PrintString AttackWithSwordStrings + 3 * string_size
			call new_line
			mov ax, [Character.str]
			mov cl, 2
			shl ax, cl

			mov bx, 5
			div bx

			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.not_good_enough:
			PrintString AttackWithSwordStrings + 4 * string_size
			call new_line
		.total_miss:
			PrintString AttackWithSwordStrings + 5 * string_size
			call new_line
		.return:
ret 

attack_with_2_handed_sword:
	PrintString AttackWith2HandSwordStrings + 0 * string_size
	call new_line

	call range_and_hit_check

	cmp word[CurrentMonster.range], 2
	jl .in_range
		PrintString AttackWith2HandSwordStrings + 1 * string_size
		call new_line
		jmp .return
	.in_range:
		mov bx, [CurrentMonster.hit]
		cmp bx, 0
		je .total_miss

		cmp bx, 1
		je .not_good_enough

		cmp bx, 2
		je .hit
			PrintString AttackWith2HandSwordStrings + 2 * string_size	
			call new_line		
			mov ax, [Character.str]
			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.hit:
			PrintString AttackWith2HandSwordStrings + 3 * string_size
			call new_line
			mov ax, [Character.str]
			mov bx, 5
			mul bx

			mov bx, 7
			div bx

			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.not_good_enough:
			PrintString AttackWith2HandSwordStrings + 4 * string_size
			call new_line
		.total_miss:
			PrintString AttackWith2HandSwordStrings + 5 * string_size
			call new_line
		.return:
ret

attack_with_dagger:
	mov ax, 3
	call check_inventory
	cmp ax, 0
	jg .has_dagger
		PrintString DaggerFightStrings + 0 * string_size
		call new_line
		jmp .return
	.has_dagger:
	call range_and_hit_check

	cmp word[CurrentMonster.range], 5
	jl .in_range
		PrintString DaggerFightStrings + 1 * string_size
		call new_line
		jmp .return
	.in_range:
		cmp word [CurrentMonster.range], 2
		jl .no_throw
			call remove_from_inventory
			mov byte[Character.weapon], 0
		.no_throw:
		mov bx, [CurrentMonster.hit]
		cmp bx, 0
		je .total_miss

		cmp bx, 1
		je .not_good_enough

		cmp bx, 2
		je .hit
			PrintString DaggerFightStrings + 2 * string_size	
			call new_line		
			mov ax, [Character.str]
			mov bx, 3
			mul bx

			mov bx, 10
			div bx
			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.hit:
			PrintString DaggerFightStrings + 3 * string_size
			call new_line
			mov ax, [Character.str]
			mov cl, 2
			shr bx, cl

			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.not_good_enough:
			PrintString DaggerFightStrings + 4 * string_size
			call new_line
		.total_miss:
			PrintString DaggerFightStrings + 5 * string_size
			call new_line
		.return:
ret

atack_with_mace:
	PrintString AttackWithMaceStrings + 0 * string_size
	call new_line

	call range_and_hit_check

	cmp word[CurrentMonster.range], 2
	jl .in_range
		PrintString AttackWithMaceStrings + 1 * string_size
		call new_line
		jmp .return
	.in_range:
		mov bx, [CurrentMonster.hit]
		cmp bx, 0
		je .total_miss

		cmp bx, 1
		je .not_good_enough

		cmp bx, 2
		je .hit
			PrintString AttackWithMaceStrings + 2 * string_size	
			call new_line	
			mov ax, [Character.str]
			mov cl, 4
			shl ax, cl

			mov bx, 9
			div bx
			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.hit:
			PrintString AttackWithMaceStrings + 3 * string_size
			call new_line
			mov ax, [Character.str]
			mov bx, 5
			mul bx

			mov bx, 11
			div bx

			call get_current_monster

			sub [Monsters + bx + monster.hp], ax

		.not_good_enough:
			PrintString AttackWithMaceStrings + 4 * string_size
			call new_line
		.total_miss:
			PrintString AttackWithMaceStrings + 5 * string_size
			call new_line
		.return:
ret

check_other_weapon:
	mov ah, 0
	mov al, [Character.weapon]
	call check_inventory

	cmp ax, 0
	jg .has_weapon
		PrintString NoWeaponString
		call new_line
		jmp .return
	.has_weapon:
		call user_other_weapon
		jmp .return
	.return:
ret

user_other_weapon:
	call range_and_hit_check
	mov ah, 0
	mov al, [Character.weapon]
	cmp al, 5
	jne .no_spear
		call throw_spear
		jmp .return

	.no_spear:
	cmp al, 6
	jne .no_bow
		call attack_with_bow
		jmp .return

	.no_bow:
	cmp al, 7
	jne .no_arrow
		call attack_with_arrows
		jmp .return

	.no_arrow:
	cmp al, 8
	jne .no_leather
		call attack_with_leather_armor
		jmp .return

	.no_leather:
	cmp al, 9
	jne .no_chain
		call attack_with_chain_armor
		jmp .return

	.no_chain:
	cmp al, 10
	jne .no_tlte
		call attack_with_tlte_mail
		jmp .return

	.no_tlte:
	cmp al, 11
	jne .no_rope
		call attack_with_rope
		jmp .return

	.no_rope:
	cmp al, 12
	jne .no_spikes
		call attack_with_spikes
		jmp .return

	.no_spikes:
	cmp al, 13
	jne .cross
		call attack_with_oil
		jmp .return

	.cross:
		call attack_with_cross
		jmp .return

	.return:
ret

attack_with_cross:
	PrintString AttackWithCrossStrings + 0 * string_size
	call new_line

	call get_user_input
	StringCompareInsensitive bx, AttackWithCrossStrings + 1 * string_size
	je .sight
		call club_with_cross
		jmp .return

	.sight:
		cmp byte [Character.weapon], 14
		je .has_weapon			
			PrintString NoWeaponString
			call new_line
			jmp .return
		.has_weapon:
			cmp word [CurrentMonster.range], 10
			jg .monster_hurt
				PrintString AttackWithCrossStrings + 2 * string_size
				call new_line
				jmp .return
			.monster_hurt:
				mov word [Statistics.weapon_range], 10
				PrintString AttackWithCrossStrings + 3 * string_size
				call new_line

				mov word [Statistics.crit_damage], 16

				mov bx, [CurrentMonster.type]
				cmp bx, 2
				je .crit

				cmp bx, 4
				je .crit

				cmp bx, 10
				jne .no_crit
				.crit:
					mov byte [CurrentMonster.hit], 3

				.no_crit:
					mov byte [CurrentMonster.hit], 1
	.return:
		call attack
ret

throw_spear:
	mov word [Statistics.damage], 42

	mov word [Statistics.crit_damage], 45

	mov word [Statistics.weapon_range], 10

	call attack
ret

attack_with_bow:
	mov word [Statistics.damage], 42

	mov word [Statistics.crit_damage], 45

	mov word [Statistics.weapon_range], 15
	mov ax, 7
	call check_inventory
	cmp ax, 0
	jl .no_arrows
		call remove_from_inventory
		call attack
	.no_arrows:
ret

attack_with_arrows:
	mov word [Statistics.damage], 14

	mov word [Statistics.crit_damage], 20

	mov word [Statistics.weapon_range], 2

	call attack
ret

attack_with_leather_armor:
	mov word [Statistics.damage], 10

	mov word [Statistics.crit_damage], 13

	mov word [Statistics.weapon_range], 4

	call attack
ret

attack_with_chain_armor:
	mov word [Statistics.damage], 14

	mov word [Statistics.crit_damage], 17

	mov word [Statistics.weapon_range], 4

	call attack
ret

attack_with_tlte_mail:
	mov word [Statistics.damage], 13

	mov word [Statistics.crit_damage], 20

	mov word [Statistics.weapon_range], 3

	call attack
ret

attack_with_rope:
	mov word [Statistics.damage], 11

	mov word [Statistics.crit_damage], 17

	mov word [Statistics.weapon_range], 5

	call attack
ret

attack_with_spikes:
	mov word [Statistics.damage], 11

	mov word [Statistics.crit_damage], 25

	mov word [Statistics.weapon_range], 8

	call attack
ret 

attack_with_oil:
	mov word [Statistics.damage], 33

	mov word [Statistics.crit_damage], 66

	mov word [Statistics.weapon_range], 6

	call attack
ret

club_with_cross:
	mov word [Statistics.damage], 33

	mov word [Statistics.crit_damage], 50

	mov word [Statistics.weapon_range], 2

	call attack
ret

attack:
	mov bx, [CurrentMonster.range]
	cmp bx, [Statistics.weapon_range]
	jl .in_range

	.in_range:
		mov bx, [CurrentMonster.hit]
		cmp bx, 0
		je .miss

		cmp bx, 1
		je .hit_no_damage

		cmp bx, 2
		je .hit
			PrintString AttackWithOtherWeaponStrings + 0 * string_size
			call new_line
			mov ax, [Statistics.crit_damage]
			jmp .do_damage

		.hit:
			PrintString AttackWithOtherWeaponStrings + 1 * string_size
			call new_line
			mov ax, [Statistics.damage]

		.do_damage:
			mov bx, [Character.str]
			mul bx
			mov bx, 100
			div bx
			call get_current_monster

			sub [Monsters + bx + monster.hp], ax
			jmp .check_and_remove
		.hit_no_damage:
			PrintString AttackWithOtherWeaponStrings + 2 * string_size
			call new_line
			jmp .check_and_remove
			
		.miss:
			PrintString AttackWithOtherWeaponStrings + 3 * string_size
			call new_line
			jmp .check_and_remove

		.check_and_remove:
			cmp byte [Character.weapon], 14
			je .return

			mov ah, 0
			mov al, [Character.weapon]
			cmp ax, 7
			je .no_switch
				mov byte [Character.weapon], 0
			.no_switch:
				call check_inventory
				cmp ax, 0
				jl .return
				call remove_from_inventory

			.return:
ret
