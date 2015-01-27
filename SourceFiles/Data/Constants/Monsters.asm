
struc monster
	.name resb 32
	.str resw 1
	.dex resw 1
	.hp resw 1
	.initHP resw 1
	.initGold resw 1
	.gold resw 1
	.int resw 1
endstruc

%macro NewMonster 7
	istruc monster
		at monster.name, db %1
		at monster.str, dw %2
		at monster.dex, dw %3
		at monster.hp, dw %4
		at monster.initHP, dw %4
		at monster.initGold, dw %7
		at monster.gold, dw %7
	iend
%endmacro

Monsters:
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