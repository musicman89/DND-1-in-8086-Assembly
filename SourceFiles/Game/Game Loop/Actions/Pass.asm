pass:
	cmp byte[CurrentMonster.status], -1
	jne .it_lives
		call monster_killed
	.it_lives:
	cmp word [Character.hp], 2
	jge .good_hp
		call hp_check
	.good_hp:
	cmp byte [CurrentMonster.type], 0
	je .no_battle
		call monster_battle

	.no_battle:
	cmp byte [Character.x], 1
	jne .return
	cmp byte [Character.y], 12
	jne .return
		WriteLine PassStrings, 0
		cmp word [Character.gold], 100
		jl .return
		sub word [Character.gold], 100

		WriteLine PassStrings, 1
		call get_user_input
		StringCompareInsensitive bx, YesString
		jne .return
			call item_shop
	.return:
		call check_for_monsters
ret