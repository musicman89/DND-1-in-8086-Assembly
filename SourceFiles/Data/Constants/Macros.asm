SECTION .text
%macro NewMonster 7
	[section .data]
	istruc monster
		at monster.name, db %1
		at monster.str, dw %2
		at monster.dex, dw %3
		at monster.hp, dw %4
		at monster.initHP, dw %4
		at monster.initGold, dw %7
		at monster.gold, dw %7
	iend
	__SECT__
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