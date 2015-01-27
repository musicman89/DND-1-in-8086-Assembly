struc weapon
	.name: resb 32
	.price: resw 1
endstruc
%macro NewWeapon 2
	istruc weapon
		at weapon.name, db %1
		at weapon.price, db %2
	iend
%endmacro

Weapons: 
NewWeapon 'SWORD', 10
NewWeapon '2-H-SWORD', 15
NewWeapon 'DAGGER', 3
NewWeapon 'MACE', 5
NewWeapon 'SPEAR', 2
NewWeapon 'BOW', 25
NewWeapon 'ARROWS', 2
NewWeapon 'LEATHER MAIL', 15
NewWeapon 'CHAIN MAIL', 30
NewWeapon 'TLTE MAIL', 50
NewWeapon 'ROPE', 1
NewWeapon 'SPIKES', 1
NewWeapon 'FLASK OF OIL', 2
NewWeapon 'SILVER CROSS', 25
NewWeapon 'SPARE FOOD', 5