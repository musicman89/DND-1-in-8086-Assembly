game_loop:
	call game_loop_welcome
	.loop:
		call get_command
	jmp .loop
ret

;********************************************************************************
;   game_loop_welcome
;   Purpose:
;      To welcome the player to the dungeon
;           Prototype:
;               void game_loop_welcome();
;           Algorithm:
;               void game_loop_welcome(){
;					Console.WriteLine(WelcomeStrings[0] + DungeonNumber);
;
;					Console.WriteLine(WelcomeStrings[1] + Character.x + WelcomeStrings[2] + Character.y + WelcomeStrings[3]);
;					Console.Read();
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
game_loop_welcome:
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



