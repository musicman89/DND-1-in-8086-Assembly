get_command:
	WriteLine CommandStrings, 0
	ReadLine
	StringCompareInsensitive YesString, bx
	jne .no
		WriteLine CommandStrings, 1

		WriteLine CommandStrings, 2

		WriteLine CommandStrings, 3

		WriteLine CommandStrings, 4
	.no:
ret

get_command_from_user:	
	Write CommandStrings, 5
	ReadLine
	cmp bx, 12
	jg .fail
	jl .continue
		call quit
		jmp .return
	.continue:
	cmp bx, 11
	jl .noHP
		call buy_hp
		jmp .return
	.noHP:
	cmp bx, 10
	jl .goodBoy
		call cheat
		jmp .return
	.goodBoy:
	cmp bx, 9
	jl .noNewMagic
		call buy_magic
		jmp .return
	.noNewMagic:
	cmp bx, 8
	jl .noUseMagic
		call use_magic
		jmp .return
	.noUseMagic:
	cmp bx, 7
	jl .noSave
		call save_game
		jmp .return
	.noSave:
	cmp bx, 6
	jl .noLooking
		call look_around
		jmp .return
	.noLooking:
	cmp bx, 5
	jl .noFighting
		call fight
		jmp .return
	.noFighting:
	cmp bx, 4
	jl .noSwitch
		call switch_weapon
		jmp .return
	.noSwitch:
	cmp bx, 3
	jl .noSearch
		call search
		jmp .return
	.noSearch:
	cmp bx, 2
	jl .noEntry
		call open_door
		jmp .return
	.noEntry:
	cmp bx, 1
	jl .stayPut
		call move
		jmp .return
	.stayPut:
	cmp bx, 0
	jl .fail
		call pass
		jmp .return
	.fail:
		WriteLine CommandStrings, 6
		call wait_key
		jmp get_command_from_user
	.return:
ret
