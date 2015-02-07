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

struc spell
	.name resw 32
	.cost resw 1
endstruc

struc item
	.name: resb 32
	.price: resw 1
endstruc

struc CharacterAttribute
	.name resb 8
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

%macro NewItem 2
	istruc item
		at item.name, db %1
		at item.price, db %2
	iend
%endmacro

%macro NewSpell 2
	istruc spell
		at spell.name, dw %1
		at spell.cost, dw %2
	iend
%endmacro

%macro NewAttribute 1
	istruc CharacterAttribute
		at CharacterAttribute.name, db %1
	iend
%endmacro