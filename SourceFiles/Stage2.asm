[BITS 16]
[ORG 0x9000]
;%define DEBUG

%include "Libraries/Graphics/Macros.asm"
%include "Libraries/Strings/Macros.asm"
boot:
	xor ax, ax	;clear ax
	mov ds, ax	;clear ds
	mov ss, ax	;start the stack at 0
	mov bp, 0x8000	;move the stack pointer to 0x2000 past the start
	mov sp, bp
	call get_seed

	%ifdef DEBUG
		call RunTests
	%else
		call clear_screen					;clear the screen
		call intro

		call clear_screen
		call game_loop
	%endif
	jmp boot
	cli								;Disable Interrupts
	hlt								;Halt the Processor

%ifdef DEBUG 
	%include "../Test/Tests.asm"
%endif

%include "Game/Setup.asm"
%include "Game/Intro.asm"
%include "Game/Roll Character.asm"
%include "Game/Shop.asm"
%include "Game/Load Game.asm"
%include "Game/Game Loop.asm"
%include "Game/Game Loop/Player.asm"
%include "Game/Game Loop/Instructions.asm"
%include "Game/Game Loop/Get Command.asm"
%include "Game/Game Loop/Actions/Buy HP.asm"
%include "Game/Game Loop/Actions/Buy Magic.asm"
%include "Game/Game Loop/Actions/Cheat.asm"
%include "Game/Game Loop/Actions/Fight.asm"
%include "Game/Game Loop/Actions/Look Around.asm"
%include "Game/Game Loop/Actions/Move.asm"
%include "Game/Game Loop/Actions/Open Door.asm"
%include "Game/Game Loop/Actions/Pass.asm"
%include "Game/Game Loop/Actions/Search.asm"
%include "Game/Game Loop/Actions/SwitchWeapon.asm"
%include "Game/Game Loop/Actions/Use Magic.asm"

%include "Libraries/Graphics/Print.asm"
%ifndef DEBUG
	%include "Libraries/IO/KeyboardIO.asm"
%endif
%include "Libraries/Strings/StringFunctions.asm"
%include "Libraries/Memory/MemoryFunctions.asm"
%include "Libraries/Math/Int.asm"
%include "Libraries/Math/Dice.asm"
%include "Data/Strings/ErrorStrings.asm"
%include "Data/Strings/Common.asm"
%include "Data/Constants/Attributes.asm"
%include "Data/Constants/Monsters.asm"
%include "Data/Constants/Items.asm"
%include "Data/Constants/Spells.asm"
%include "Data/Constants/Dungeons.asm"
%include "Data/Variables/Character.asm"
%include "Data/Variables/Dungeon.asm"
times 51688-($-$$) db 0