SECTION .bss
Statistics:
	.crit_damage 		resw 1
	.damage 			resw 1
	.armor 				resw 1
	.weapon_range 		resw 1

Character:
	.name 				resb 32
	.class 				resb 32
	.hp 				resw 1
	.str 				resw 1
	.dex 				resw 1
	.con 				resw 1
	.char 				resw 1
	.wis 				resw 1
	.int 				resw 1
	.gold 				resw 1
	.continues 			resb 1
	.weapon 			resb 1
	.itemCount 			resb 1
	.inventory 			resb 100
	.clericSpellCount 	resb 1
	.clericSpells 		resb 100
	.wizardSpellCount 	resb 1
	.wizardSpells 		resb 100
	.x 					resb 1
	.y 					resb 1

