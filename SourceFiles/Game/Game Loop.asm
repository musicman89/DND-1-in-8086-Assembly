GameLoop:

	call GetCommand
ret

GameLoopWelcome:
	PrintString WelcomeStrings + 0 * string_size
	PrintString WelcomeStrings + 1 * string_size
	call new_line
ret



