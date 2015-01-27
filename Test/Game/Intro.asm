intro_test:
	call instructions_test
ret

instructions_test:
	mov word[InputTestStringAddress], InstructionsTestString
	mov word[InputTestStringPosition], 0
	call Instructions
	call wait_key

	call Instructions
	call wait_key

	call Instructions
	call wait_key
	
	call Instructions
	call wait_key
ret
InstructionsTestString db 0,"M",0,"Yes",0,"No",0,"N",0,"Y",0,-1

new_or_old_test:
	PrintString NoInstructionsString
	call get_user_input
	StringCompareInsensitive InputStringBuffer, OldString
	je .old

	ret
	.old:
		call get_key
		ret
ret

get_dungeon_num_test:
	PrintString DungeonNumberString
	call get_user_input
	call parse_int
	test bx, bx
	jnz .return
	.fail:
		call invalid_input
		jmp GetDungeonNum
	.return:
	mov [DungeonNumber], bx
ret

get_continues_test:
	PrintString ResetContinuesString
	call get_user_input
	call parse_int
	cmp bx, 1
	jl .fail

	cmp bx, 2
	jg .fail

	mov [Continues], bx
	jmp .return
	.fail:
		call invalid_input
		jmp GetContinues
	.return:
ret