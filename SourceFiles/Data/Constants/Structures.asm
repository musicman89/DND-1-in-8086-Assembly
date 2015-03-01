section .data
struc monster
	.name resb 16
	.str resw 1
	.dex resw 1
	.hp resw 1
	.initHP resw 1
	.initGold resw 1
	.gold resw 1
	.int resw 1
endstruc

struc spell
	.name resb 20
	.cost resw 1
endstruc

struc item
	.name: resb 16
	.price: resw 1
endstruc

struc CharacterAttribute
	.name resb 8
endstruc