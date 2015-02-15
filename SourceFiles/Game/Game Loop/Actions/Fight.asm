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
; Check other Weapon
; 05440 REM
; 05450 FOR M=1 TO X
; 05460 IF W(M)=J THEN 05500 
; 05470 NEXT M
; 05480 PRINT "NO WEAPON FOUND"
; 05490 GO TO 01590
ret

user_other_weapon:
; 05500 GOSUB 08410 // Range and Hit Check
; 05510 IF J=5 THEN 05760 //Spear
; 05520 IF J=6 THEN 05800 //Bow
; 05530 IF J=7 THEN 05840 //Arrows
; 05540 IF J=8 THEN 05880 //Leather Mail
; 05550 IF J=9 THEN 05920 //Chain Mail
; 05560 IF J=10 THEN 05960 //TLTE Mail
; 05570 IF J=11 THEN 06000 //Rope
; 05580 IF J=12 THEN 06040 //Spikes
; 05590 IF J=13 THEN 06080 //Flask of Oil
ret

attack_with_cross:
; Silver Cross
; 05600 PRINT "AS A CLUB OR SIGHT";
; 05610 INPUT Q$
; 05620 IF Q$="SIGHT" THEN 05650
; 05630 IF J=14 THEN 06120
; 05640 GO TO 05480

; Sight of Cross
; 05650 IF R1<10 THEN 05680
; 05660 PRINT "FAILED"
; 05670 GO TO 07000

; 05680 PRINT "THE MONSTER IS HURT"
; 05690 LET R5=1/6
; 05700 IF K=2 THEN 06200
; 05710 IF K=10 THEN 06200
; 05720 IF K=4 THEN 06200
; 05730 GOTO 06260

; 05740 IF INT(RND(0)*0)>0 THEN 06260
; 05750 GO TO 06200
; Throw Spear
; 05760 LET R3=10
; 05770 LET R4=3/7
; 05780 LET R5=5/11
; 05790 GO TO 06160
ret

attack_with_bow:
; Shoot Bow
; 05800 LET R3=15
; 05810 LET R4=3/7
; 05820 LET R5=5/11
; 05821 FOR Z=1 TO 100
; 05822 IF W(Z)=7 THEN 5825
; 05823 NEXT Z
; 05824 GO TO 6280

; 05825 J=7
; 05826 W(Z)=0
; 05830 GO TO 06160

; Arrows
; 05840 LET R3=1.5
; 05850 LET R4=1/7
; 05860 LET R5=1/5
; 05870 GO TO 06160
ret

attack_with_leather_armor:
; Leather Mail
; 05880 LET R3=4
; 05890 LET R4=1/10
; 05900 LET R5=1/8
; 05910 GO TO 06160
ret

attack_with_chain_armor:
; Chain Mail
; 05920 LET R3=4
; 05930 LET R4=1/7
; 05940 LET R5=1/6
; 05950 GO TO 06160
ret

attack_with_tlte_mail:
; TLTE Mail
; 05960 LET R3=3
; 05970 LET R4=1/8
; 05980 LET R5=1/5
; 05990 GO TO 06160
ret

attack_with_rope:
; Rope
; 06000 LET R3=5
; 06010 LET R4=1/9
; 06020 LET R5=1/6
; 06030 GO TO 06160
ret

attack_with_spikes:
; Spikes
; 06040 LET R3=8
; 06050 LET R4=1/9
; 06060 LET R5=1/4
; 06070 GO TO 06160
ret 

attack_with_oil:
; Flask of Oil
; 06080 LET R3=6
; 06090 LET R4=1/3
; 06100 LET R5=2/3
; 06110 GO TO 06160
ret

club_with_cross:
; Club with Cross
; 06120 LET R3=1.5
; 06130 LET R4=1/3
; 06140 LET R5=1/2
; 06150 GO TO 06160
ret

attack:
; Attack
; 06160 IF R1>R3 THEN 04710 //Out of Range?
; 06170 IF R2=0 THEN 06280 //Miss
; 06180 IF R2=1 THEN 06260 //Hit No Damage
; 06190 IF R2=2 THEN 06230 //Hit
; 06200 PRINT "CRITICAL HIT"
; 06210 LET B(K,3)=B(K,3)-INT(C(1)*R5)
; 06220 GO TO 06300

; 06230 PRINT "HIT"
; 06240 LET B(K,3)=B(K,3)-INT(C(1)*R4)
; 06250 GO TO 06300

; 06260 PRINT "HIT BUT NO DAMAGE"
; 06270 GO TO 06300

; 06280 PRINT "MISS"
; 06290 GO TO 06300

; 06300 IF W(J)=14 THEN 07000 //If Cross go to the pass
; 06310 FOR M=1 TO X
; 06320 IF W(M)=J THEN 06340 //Remove Item
; 06330 NEXT M
; 06340 LET W(M)=0 
; 06350 IF J<>7 THEN 06360 //If bow don’t switch
; 06355 GO TO 06370

; 06360 LET J=0
; 06370 IF R2>0 THEN 01590  //Get Command 
; 06380 GO TO 07000
ret
