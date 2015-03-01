section .text
;********************************************************************************
;   read_dungeon
;   Purpose:
;      To read in the selected dungeon and set it up
;           Prototype:
;               void read_dungeon();
;           Algorithm:
;               void read_dungeon(){
;					MemCopy(Dungeons[DungeonNumber],CurrentDungeon, 525);
;					for(int x = 0; x < 525; x++){
;						if(CurrentDungeon[x] == 0){
;							if(roll_d100 > 96){
;								CurrentDungeon[x] = 7
;							}
;							if(roll_d100 > 96){
;								CurrentDungeon[x] = 8
;							}
;						}
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       AX, BX, CX
;   Exceptions:
;       
;*******************************************************************************
read_dungeon:
	mov ax, 625
	mov bx, DungeonNumber
	mul bx
	add ax, Dungeons

	mov bx, CurrentDungeon
	mov cx, 625
	call mem_copy

	mov cx, 625
	.loop:
		cmp cx, 0
		jne .skip
		call roll_d100
		cmp bx, 97
		jl .no_str
			mov bx, cx
			mov byte [CurrentDungeon + bx], 7
		.no_str:
		call roll_d100
		cmp bx, 97
			mov bx, cx
			mov byte [CurrentDungeon + bx], 8
		jl .skip
	.skip:
	dec cx
	jnz .loop
ret

load_game:
	mov ax, SaveCharacter
	mov bx, Character
	mov cx, [SaveCharacterLength]
	call mem_copy

	mov ax, SaveCurrentMonster
	mov bx, CurrentMonster
	mov cx, [SaveCurrentMonsterLength]
	call mem_copy

	mov bl, [SaveDungeonNumber]
	mov [DungeonNumber], bl

	mov bl, [SaveDifficulty]
	mov [Difficulty], bl

	mov ax, SaveMonsters
	mov bx, Monsters
	mov cx, [SaveMonstersLength]
	call mem_copy

	mov ax, SaveCurrentDungeon
	mov bx, CurrentDungeon
	mov cx, 625
	call mem_copy

ret

save_game:
	mov ax, Character
	mov bx, SaveCharacter
	mov cx, [SaveCharacterLength]
	call mem_copy

	mov ax, CurrentMonster
	mov bx, SaveCurrentMonster
	mov cx, [SaveCurrentMonsterLength]
	call mem_copy

	mov bl, [DungeonNumber]
	mov [SaveDungeonNumber], bl

	mov bl, [Difficulty]
	mov [SaveDifficulty], bl

	mov ax, Monsters
	mov bx, SaveMonsters
	mov cx, [SaveMonstersLength]
	call mem_copy

	mov ax, CurrentDungeon
	mov bx, SaveCurrentDungeon
	mov cx, 625
	call mem_copy

	mov bx, game_save
	mov dh, 2
	mov dl, [boot_drive]
	call disk_save
ret
