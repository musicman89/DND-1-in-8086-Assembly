get_command:
	PrintString CommandStrings + 0 * string_size
	call get_user_input
	StringCompareInsensitive YesString, bx
	jne .no
		PrintString CommandStrings + 1 * string_size
		call new_line

		PrintString CommandStrings + 2 * string_size
		call new_line

		PrintString CommandStrings + 3 * string_size
		call new_line

		PrintString CommandStrings + 4 * string_size
		call new_line
	.no:
ret

get_command_from_user:	
	PrintString CommandStrings + 5 * string_size
	call get_user_input
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
		PrintString CommandStrings + 6 * string_size
		call wait_key
		jmp get_command_from_user
	.return:
ret
