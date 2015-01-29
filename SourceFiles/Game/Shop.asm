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
		test ax, ax
		jz .purchase
		PrintString ClericCannotUseString
	jmp MakeItemSelection

	.wizard:
		call CheckWizardItem
		test ax, ax
		jz .purchase
		PrintString WizardCannotUseString
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
	mov ax, 0
	cmp dl, 3
	je .return

	cmp dl, 7
	je .return

	cmp dl, 8
	je .return

	cmp dl, 9
	jge .return

	mov ax, -1
	.return:
ret

CheckWizardItem:
	mov ax, 0
	cmp dl, 2
	je .return

	cmp dl, 7
	je .return

	cmp dl, 9
	jge .return

	mov ax, -1
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