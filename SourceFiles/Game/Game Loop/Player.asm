check_inventory:

ret

remove_from_inventory:

ret

add_to_inventory:

ret

die:

ret

lose_hp:
	mov bx, [Character + player.hp]
	sub bx, ax
	mov [Character + player.hp], bx
ret

lose_one_hp:
	mov bx, [Character + player.hp]
	dec bx
	mov [Character + player.hp], bx
ret