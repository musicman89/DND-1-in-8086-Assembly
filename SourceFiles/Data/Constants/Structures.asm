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