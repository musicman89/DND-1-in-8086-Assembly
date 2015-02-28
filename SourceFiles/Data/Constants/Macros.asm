section .text
%macro NewMonster 7
	%strlen len %1
	istruc monster
		at monster.name, dw len, %1, 0
		at monster.str, dw %2
		at monster.dex, dw %3
		at monster.hp, dw %4
		at monster.initHP, dw %4
		at monster.initGold, dw %7
		at monster.gold, dw %7
	iend
%endmacro

%macro NewItem 2
	%strlen len %1
	istruc item
		at item.name, dw len, %1, 0
		at item.price, db %2
	iend
%endmacro

%macro NewSpell 2
	%strlen len %1
	istruc spell
		at spell.name, dw len, %1, 0
		at spell.cost, dw %2
	iend
%endmacro

%macro NewAttribute 1
	%strlen len %1
	istruc CharacterAttribute
		at CharacterAttribute.name, dw len, %1, 0
	iend
%endmacro