ItemShop:
	call ShopWelcome
	call MakeItemSelection
ret

ShopWelcome:
	call clear_screen
	PrintString ItemShopString + 0 * string_size
	PrintString ItemShopString + 1 * string_size
	call get_user_input
	StringCompareInsensitive InputStringBuffer, FastString
	je .return
		call PrintShopWares
	.return:
ret

PrintShopWares:
	mov cx, 15
	mov dx, Items
	.loop:
	mov bx, 16
	sub bx, cx
	call print_dec
	PrintString Space

	mov bx, dx
	add bx, item.name
	PrintString bx

	PrintString Space
	mov bx, dx
	mov bx, [bx + item.price]
	call print_dec


	call new_line
	add dx, item_size
	dec cx
	jnz .loop
ret

MakeItemSelection:
	call get_user_input
	call parse_int
	dec bl
	mov dl, bl
	cmp bl, 0
	jl .return
	cmp bl, 14
	jg .return



	call CheckItemCost
	mov cx, ax
	jg .insufficientFunds

	StringCompareInsensitive Character + player.class, Classes + 2 * string_size
	je .cleric

	StringCompareInsensitive Character + player.class, Classes + 3 * string_size
	je .wizard


	jmp .purchase

	.cleric:
	call CheckClericItem
	jge .purchase
		PrintString ClericCannotUseString
	jmp MakeItemSelection

	.wizard:
	call CheckWizardItem
	jge .purchase
		PrintString ClericCannotUseString
	jmp MakeItemSelection

	.insufficientFunds:
		PrintString CostsTooMuchString + 0 * string_size
		PrintString CostsTooMuchString + 1 * string_size
	jmp MakeItemSelection

	.purchase:
		add byte[Character + player.itemCount], 1
		mov bl, byte [Character + player.itemCount]
		mov bh, 0
		mov byte[Character + player.inventory + bx], dl
		mov bl, byte[Character + player.inventory + bx]
		call print_dec
		call new_line
		sub word [Character + player.gold], cx

		call ShowGold

	jmp MakeItemSelection
	.return:
ret

ShowGold:
	PrintString GPString
	mov bx, [Character + player.gold]
	call print_dec
	call new_line
ret

CheckClericItem:
	cmp bx, 4
	je .return
	cmp bx, 8
	je .return
	cmp bx, 9
	je .return
	cmp bx, 10
	jg .return
	.return:
ret

CheckWizardItem:
	cmp bx, 3
	je .return
	cmp bx, 8
	je .return
	cmp bx, 10
	jg .return
	.return:
ret

CheckItemCost:
	push bx
	push cx
	push dx
	mov ax, bx
	mov bx, item_size
	mul bx
	mov bx, ax

	mov ax, [bx + Items + item.price]
	cmp ax, word [Character + player.gold]
	pop dx
	pop cx
	pop bx
ret