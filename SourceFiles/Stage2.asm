[BITS 16]
[ORG 0x9000]
[CPU 8086]
;[map all]
jmp boot

%define DEBUG
%define Stage2
%include "Libraries/Graphics/Macros.asm"
%include "Libraries/Strings/Macros.asm"

SECTION .text
		boot:
			mov [boot_drive], dl
			xor ax, ax								;clear ax
			mov ds, ax								;clear ds
			mov ss, ax								;start the stack at 0
			mov bp, 0x8FFF							;move the stack pointer to 1 before the start
			mov sp, bp
			mov es, ax
			call get_seed 							;Initialize our random seed

			%ifdef DEBUG
				call RunTests 						;If we are compiling in debug run our tests
			%else
				call clear_screen					;clear the screen
				call intro 							;Go to the introduction

				call clear_screen
				call game_loop 						;Begin the game loop
			%endif
			jmp boot
			cli								;Disable Interrupts
			hlt								;Halt the Processor

			%ifdef DEBUG 
				%include "../Test/Tests.asm"
			%endif
			%include "Data/Constants/Macros.asm"
			%include "Data/Constants/Structures.asm"
			%include "Data/Constants/Monsters.asm"
			%include "Data/Variables/Dungeon.asm"
			%include "Data/Variables/Character.asm"
			%include "Data/Variables/GameSave.asm"
			%include "Game/Intro.asm"
			%include "Game/Roll Character.asm"
			%include "Game/Shop.asm"
			%include "Game/Load Game.asm"
			%include "Game/Game Loop.asm"
			%include "Game/Game Loop/Player.asm"
			%include "Game/Game Loop/Get Command.asm"
			%include "Game/Game Loop/Actions/Buy HP.asm"
			%include "Game/Game Loop/Actions/Buy Magic.asm"
			%include "Game/Game Loop/Actions/Cheat.asm"
			%include "Game/Game Loop/Actions/Fight.asm"
			%include "Game/Game Loop/Actions/Battle.asm"
			%include "Game/Game Loop/Actions/Look Around.asm"
			%include "Game/Game Loop/Actions/Move.asm"
			%include "Game/Game Loop/Actions/Open Door.asm"
			%include "Game/Game Loop/Actions/Pass.asm"
			%include "Game/Game Loop/Actions/Search.asm"
			%include "Game/Game Loop/Actions/SwitchWeapon.asm"
			%include "Game/Game Loop/Actions/Use Magic.asm"
			
			%include "Libraries/Graphics/ExtendedPrint.asm"
			%include "Libraries/IO/DiskIO.asm"
			%include "Libraries/Strings/StringFunctions.asm"
			%include "Libraries/Memory/MemoryFunctions.asm"
			%include "Libraries/Math/Int.asm"
			%include "Libraries/Math/Dice.asm"

			%include "Libraries/IO/KeyboardIO.asm"



SECTION .bss
	boot_drive resb 1


SECTION .data
	%include "Data/Strings/Common.asm"
	%include "Data/Constants/Attributes.asm"
	%include "Data/Constants/Items.asm"
	%include "Data/Constants/Spells.asm"
	%include "Data/Constants/Dungeons.asm"
	%include "Data/Strings/ErrorStrings.asm"



times 51688-($-$$) db 0