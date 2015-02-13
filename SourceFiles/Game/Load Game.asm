
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
	mov cx, SaveCurrentMonster - SaveCharacter
	call mem_copy

	mov ax, SaveCurrentMonster
	mov bx, CurrentMonster
	mov cx, SaveDungeonNumber - SaveCurrentMonster
	call mem_copy

	mov bl, [SaveDungeonNumber]
	mov [DungeonNumber], bl

	mov bl, [SaveDifficulty]
	mov [Difficulty], bl

	mov ax, SaveMonsters
	mov bx, Monsters
	mov cx, SaveCurrentDungeon - SaveMonsters
	call mem_copy

	mov ax, SaveCurrentDungeon
	mov bx, CurrentDungeon
	mov cx, 625
	call mem_copy
ret

save_game:
	mov ax, Character
	mov bx, SaveCharacter
	mov cx, SaveCurrentMonster - SaveCharacter
	call mem_copy

	mov ax, CurrentMonster
	mov bx, SaveCurrentMonster
	mov cx, SaveDungeonNumber - SaveCurrentMonster
	call mem_copy

	mov bl, [DungeonNumber]
	mov [SaveDungeonNumber], bl

	mov bl, [Difficulty]
	mov [SaveDifficulty], bl

	mov ax, Monsters
	mov bx, SaveMonsters
	mov cx, SaveCurrentDungeon - SaveMonsters
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

align 512
game_save:
SaveCharacter:
	.name db "SHAVS", 0
	times 32 - 6 db 0
	.class db "FIGHTER", 0
	times 32-8 db 0
	.hp dw 5
	.str dw 17
	.dex dw 12
	.con dw 19
	.char dw 13
	.wis dw 16
	.int dw 18
	.gold dw 150
	.continues db 1
	.weapon db 1
	.itemCount db 3
	.inventory:
	db 1
	db 2 
	db 3
	times 97 db 0
	.clericSpellCount db 0
	.clericSpells times 100 db 0
	.wizardSpellCount db 0
	.wizardSpells times 100 db 0
	.x db 12
	.y db 6
SaveCurrentMonster:
	.status: db 0
	.type: db 0
	.x: db 0
	.y: db 0
	.distance_x:db 0
	.distance_y:db 0
	.range: dw 0
	.hit:db 0
SaveDungeonNumber db 5
SaveDifficulty db 0
SaveMonsters: 
NewMonster 'MAN',1,13,26,1,1,500
NewMonster 'GOBLIN',2,13,24,1,1,600
NewMonster 'TROLL',3,15,35,1,1,1000
NewMonster 'SKELETON',4,22,12,1,1,50
NewMonster 'BALROG',5,18,110,1,1,5000
NewMonster 'OCHRE JELLY',6,11,20,1,1,0
NewMonster 'GREY OOZE',7,11,13,1,1,0
NewMonster 'GNOME',8,13,30,1,1,100
NewMonster 'KOBOLD',9,15,16,1,1,500
NewMonster 'MUMMY',10,16,30,1,1,100
SaveCurrentDungeon:
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
end_save: