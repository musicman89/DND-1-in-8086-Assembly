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
		jmp .return
	.continue:
	cmp bx, 11
	jl .noHP
		jmp .return
	.noHP:
	cmp bx, 10
	jl .goodBoy
		jmp .return
	.goodBoy:
	cmp bx, 9
	jl .noNewMagic
		jmp .return
	.noNewMagic:
	cmp bx, 8
	jl .noUseMagic
		jmp .return
	.noUseMagic:
	cmp bx, 7
	jl .noSave
		jmp .return
	.noSave:
	cmp bx, 6
	jl .noLooking
		jmp .return
	.noLooking:
	cmp bx, 5
	jl .noFighting
		jmp .return
	.noFighting:
	cmp bx, 4
	jl .noSwitch
		jmp .return
	.noSwitch:
	cmp bx, 3
	jl .noSearch
		jmp .return
	.noSearch:
	cmp bx, 2
	jl .noEntry
		jmp .return
	.noEntry:
	cmp bx, 1
	jl .stayPut
		call move
		jmp .return
	.stayPut:
	cmp bx, 0
	jl .fail
		jmp .return
	.fail:
		PrintString CommandStrings + 6 * string_size
		call wait_key
		jmp get_command_from_user
	.return:
ret
