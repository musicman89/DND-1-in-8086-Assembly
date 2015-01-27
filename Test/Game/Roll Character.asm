RollCharacter:
	call GetCharacterName
	call RollAttributes
	call PrintAttributes
	call SetCharacterClass
ret
GetCharacterName:
	PrintString PlayerNameInputString 
	call get_user_input
	call to_upper

	StringCompare InputStringBuffer, PlayerNameShavs
	jne .return 		
	PrintString YesInstructionsString
	call get_key
	jmp GetCharacterName
	.return:
	mov [CharacterName], bx
ret

RollD6:
	push ax
	push cx
	push dx

	mov cx, 6
	call random_int
	inc bx

	pop dx
	pop cx
	pop ax
ret

RollAttributes:
	mov cx, 7
	.loop:
		call RollD6
		mov ax, bx

		call RollD6
		add ax, bx

		call RollD6
		add ax, bx


		mov bx, ax

		cmp cx, 7
		jne .not_gold
			mov bx, 15
			mul bx
		.not_gold:

		mov bx, cx
		sub bx, 1
		shl bx, 1
		mov [CharacterAttributes + bx], word ax
		dec cx
		jnz .loop
ret
PrintAttributes:
	mov cx, 7
	.loop:
		mov bx, CharacterAttributeNames

		call get_string_array
		push cx
		call print_string
		PrintString Space
		pop cx
		mov bx, cx
		sub bx, 1
		shl bx, 1
		mov bx, [CharacterAttributes + bx]
		push cx
		call print_dec
		call new_line
		pop cx
		dec cx
	jnz .loop
ret

SetCharacterClass:
	PrintString ClassString
	call get_user_input
ret

PrintCharacteristics:

ret