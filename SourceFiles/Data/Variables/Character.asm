struc player
	.name resb 32
	.class resb 32
	.hp resw 1
	.str resw 1
	.dex resw 1
	.con resw 1
	.char resw 1
	.wis resw 1
	.int resw 1
	.gold resw 1
	.continues resw 1
endstruc

Character:
	istruc player
		at player.name, db 0
		at player.class, db 0
		at player.str, db 0
		at player.dex, db 0
		at player.con, db 0
		at player.char, db 0
		at player.wis, db 0
		at player.int, db 0
		at player.gold, db 0
		at player.continues, db 0
	iend