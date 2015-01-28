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
	je .return 		
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
		sub bx, 1
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
		sub bx, 1
		shl bx, 1
		mov bx, [Character + player.str + bx]
		call print_dec
		call new_line
		dec cx
		cmp cx, 0
		jne .loop
		call wait_key
ret

SetCharacterClass:
	call clear_screen
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
		mov [Character + player.hp], word ax
	jmp .return

	.fighter:
		StringCopy InputStringBuffer, Character + player.class
		call RollD8
		mov ax, bx
		mov [Character + player.hp], word ax
	jmp .return

	.wizard:
		StringCopy InputStringBuffer, Character + player.class
		call RollD4
		mov ax, bx
		mov [Character + player.hp], word ax
	jmp .return

	.reroll:
		mov byte[Character + player.class], 0
		ret
	.return:
		mov bx, word[Character + player.hp]
ret

PrintCharacteristicsAndEquipment:
	call ListEquipment
	call PrintCharacteristics
ret

ListEquipment:
	call clear_screen
	PrintString EQListString
	call get_user_input
	StringCompareInsensitive InputStringBuffer, NoString
	je .return
		mov cl, byte[Character + player.itemCount]
		mov ch, 0
		cmp cx, 0
		je .return
		.loop:
			mov bx, cx 
			mov al, byte[Character + player.inventory + bx]
			mov ah, 0

			mov bx, item_size
			mul bx
			add ax, Items + item.name
			PrintString ax
			call new_line
			dec cx
		jnz .loop
	.return:
	call wait_key
ret

PrintCharacteristics:
	call clear_screen
	PrintString YourCharacteristicsString
	PrintString Character + player.name
	call new_line
	mov bx, word[Character + player.hp]
	cmp bx, 1
	jg .healthy
		mov word[Character + player.hp], 2
		mov bx, 2
	.healthy:
	PrintString HitPointsString
	call print_dec
	call new_line
	call new_line
	call wait_key
ret

