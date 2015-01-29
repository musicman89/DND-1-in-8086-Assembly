GetCommand:
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
	call GetCommandFromUser
ret

GetCommandFromUser:	
	PrintString CommandStrings + 5 * string_size
	call get_user_input
	cmp bx, 12
	jg .fail
	jl .continue

	.continue:
	cmp bx, 11
	jl .noHP

	.noHP:
	cmp bx, 10
	jl .goodBoy

	.goodBoy:
	cmp bx, 9
	jl .noNewMagic

	.noNewMagic:
	cmp bx, 8
	jl .noUseMagic

	.noUseMagic:
	cmp bx, 7
	jl .noSave

	.noSave:
	cmp bx, 6
	jl .noLooking

	.noLooking:
	cmp bx, 5
	jl .noFighting

	.noFighting:
	cmp bx, 4
	jl .noSwitch

	.noSwitch:
	cmp bx, 3
	jl .noSearch

	.noSearch:
	cmp bx, 2
	jl .noEntry

	.noEntry:
	cmp bx, 1
	jl .stayPut

	.stayPut:
	cmp bx, 0
	jl .fail

	.fail:
		PrintString CommandStrings + 6 * string_size
		call wait_key
		jmp GetCommandFromUser
ret
