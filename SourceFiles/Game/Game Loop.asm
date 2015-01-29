GameLoop:
	call GameLoopWelcome
	.loop:
		call GetCommand
	jmp .loop
ret

GameLoopWelcome:
	call new_line
	call new_line
	call new_line

	PrintString WelcomeStrings + 0 * string_size
	mov bx, [DungeonNumber]
	call print_dec

	call new_line
	PrintString WelcomeStrings + 1 * string_size
	mov bh, 0
	mov bl, [Character + player.x]
	call print_dec
	PrintString WelcomeStrings + 2 * string_size
	mov bl, [Character + player.y]
	call print_dec
	PrintString WelcomeStrings + 3 * string_size
	call new_line
	call wait_key
ret



