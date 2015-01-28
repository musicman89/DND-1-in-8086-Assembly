Intro:
	call clear_screen					;clear the screen
	PrintString TitleString	+ 0 * string_size		
	PrintString TitleString	+ 1 * string_size	
	PrintString TitleString	+ 2 * string_size	
	call new_line	

	call get_seed

	call Instructions
	call NewOrOld
	call GetDungeonNum
	call GetContinues
	call clear_screen

	call RollCharacter
	call clear_screen

	call ItemShop
	call clear_screen

	call PrintCharacteristicsAndEquipment
	call ReadDungeon
	call GameLoop
ret

Instructions:
	PrintString NeedInstructionsString	
	call get_user_input
	StringToUpper InputStringBuffer
	StringCompareInsensitive InputStringBuffer, YesString
	je .yes_instructions

	cmp byte [InputStringBuffer], 'Y'
	je .yes_instructions

	StringCompareInsensitive InputStringBuffer, NoString
	je .no_instructions
	
	cmp byte [InputStringBuffer], 'N'
	je .no_instructions

	call invalid_input
	jmp Instructions

	.yes_instructions:
		PrintString WhoSaidString
		call wait_key
		ret
	.no_instructions:  
ret

NewOrOld:
	PrintString NoInstructionsString
	call get_user_input
	StringCompareInsensitive InputStringBuffer, OldGameString
	je .old

	ret
	.old:
		call get_key
		ret
ret

GetDungeonNum:
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

GetContinues:
	PrintString ResetContinuesString
	call get_user_input
	call parse_int
	cmp bx, 1
	jl .fail

	cmp bx, 2
	jg .fail

	mov [Character + player.continues], bx
	jmp .return
	.fail:
		call invalid_input
		jmp GetContinues
	.return:
ret