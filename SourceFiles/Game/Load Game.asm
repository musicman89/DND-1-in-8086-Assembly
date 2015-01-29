read_dungeon:
	mov ax, 525
	mov bx, DungeonNumber
	mul bx
	mov bx, CurrentDungeon
	mov cx, 525
	call mem_copy

	mov cx, 525
	.loop:
		cmp cx, 0
		jne .skip
		call RollD100
		cmp bx, 97
		jl .no_str
			mov bx, cx
			mov byte [CurrentDungeon + bx], 7
		.no_str:
		call RollD100
		cmp bx, 97
			mov bx, cx
			mov byte [CurrentDungeon + bx], 8
		jl .skip
	.skip:
	dec cx
	jnz .loop
ret
load_game:

ret
save_game:

ret