WeaponShop:
	call WeaponShopWelcome
ret
WeaponShopWelcome:
	PrintString WeaponStoreStrings + 0 * string_size
	PrintString WeaponStoreStrings + 1 * string_size
	call get_user_input
	mov cx, 15
	mov dx, Weapons
	.loop:
	mov bx, 16
	sub bx, cx
	call print_dec
	PrintString Space

	mov bx, dx
	add bx, weapon.name
	PrintString bx

	PrintString Space
	mov bx, dx
	mov bx, [bx + weapon.price]
	call print_dec


	call new_line
	add dx, weapon_size
	dec cx
	jnz .loop
ret