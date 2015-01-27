RollCharacter:
	call GetCharacterName
	.reroll:
	call RollAttributes
	call PrintAttributes
	call SetCharacterClass
	cmp byte[Character + player.class], 0
	je .reroll
ret
GetCharacterName:
	PrintString PlayerNameInputString 
	call get_user_input
	call string_length
	test cx, cx
	je GetCharacterName 
	call to_upper

	StringCompare InputStringBuffer, PlayerNameShavs
	jne .return 		
		PrintString WhoSaidString
		call get_key
		jmp GetCharacterName
	.return:
		StringCopy InputStringBuffer, Character + player.name
ret
RollAttribute:
		call RollD6
		mov ax, bx

		call RollD6
		add ax, bx

		call RollD6
		add ax, bx

ret
RollAttributes:
	mov cx, 7
	.loop:
		call RollAttribute

		mov bx, ax
		cmp cx, 7
		jne .not_gold
			mov bx, 15
			mul bx
		.not_gold:

		mov bx, cx
		shl bx, 1
		mov [Character + player.str + bx], word ax
		dec cx
		cmp cx, 0
		jne .loop
ret

PrintAttributes:
	mov cx, 7
	.loop:

		mov bx, cx
		sub bx, 1
		shl bx, 3
		add bx, CharacterAttributeNames
		call print_string

		PrintString Space
		mov bx, cx
		shl bx, 1
		mov bx, [Character + player.str + bx]
		call print_dec
		call new_line
		dec cx
		cmp cx, 0
		jne .loop
ret

SetCharacterClass:
	PrintString ClassStrings + 0 * string_size
	PrintString ClassStrings + 1 * string_size
	PrintString ClassStrings + 2 * string_size
	call get_user_input
	StringToUpper InputStringBuffer
	StringCompareInsensitive InputStringBuffer, Classes + 0 * string_size
	je .reroll
	StringCompareInsensitive InputStringBuffer, Classes + 2 * string_size
	je .cleric
	StringCompareInsensitive InputStringBuffer, Classes + 1 * string_size
	je .fighter
	StringCompareInsensitive InputStringBuffer, Classes + 3 * string_size
	je .wizard
	jmp SetCharacterClass
	.cleric:
		StringCopy InputStringBuffer, Character + player.class
		call RollD4
		mov ax, bx
		mov [Character + player.hp + bx], word ax
	jmp .return

	.fighter:
		StringCopy InputStringBuffer, Character + player.class
		call RollD8
		mov ax, bx
		mov [Character + player.hp + bx], word ax
	jmp .return

	.wizard:
		StringCopy InputStringBuffer, Character + player.class
		call RollD4
		mov ax, bx
		mov [Character + player.hp + bx], word ax
	jmp .return

	.reroll:
		mov byte[Character + player.class], 0
		ret
	.return:
ret

PrintCharacteristics:

ret
