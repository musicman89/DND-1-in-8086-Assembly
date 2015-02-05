item_shop:
	call shop_welcome
	call make_item_selection
ret

;********************************************************************************
;   shop_welcome
;   Purpose:
;      To welcome the player to the shop
;           Prototype:
;               void shop_welcome();
;           Algorithm:
;               void shop_welcome(){
;					Console.WriteLine(ItemShopString[0]);
;					Console.WriteLine(ItemShopString[1]);
;					var input = Console.Read().ToUpper();
;					if(input != "FAST"){
;						print_shop_wares();
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
shop_welcome:
	PrintString ItemShopString + 0 * string_size
	PrintString ItemShopString + 1 * string_size
	call get_user_input
	StringCompareInsensitive InputStringBuffer, FastString
	je .return
		call print_shop_wares
	.return:
ret

;********************************************************************************
;   print_shop_wares
;   Purpose:
;      To display the shops wares
;           Prototype:
;               void print_shop_wares();
;           Algorithm:
;               void print_shop_wares(){
;					for(int x = 0; x < Items.count; x++){
;						Console.WriteLine((x+1) + " " + Items[x].name + " " + Items[x].price);
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
print_shop_wares:
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

;********************************************************************************
;   make_item_selection
;   Purpose:
;      To take the user's selection, validate it, then process the transaction
;           Prototype:
;               void make_item_selection();
;           Algorithm:
;               void make_item_selection(){
;					string input = int.Parse(Console.Read());
;					while(input < 0 || input > Items.count) 
;						if(!check_item_cost(input)){
;							Console.WriteLine(CostsTooMuchString[0]);
;							Console.WriteLine(CostsTooMuchString[1]);
;						}
;						else if(Character.class == "WIZARD" && !check_wizard_item(input))
;						{
;							Console.WriteLine(WizardCannotUseString);
;						}
;						else if(Character.class == "CLERIC" && !check_cleric_item(input))
;						{
;							Console.WriteLine(ClericCannotUseString);
;						}
;						else
;						{
;							Character.itemCount++;
;							Character.inventory[Character.itemCount] = input;
;							remove_gold(Items[input].price)
;							show_gold();
;						}
;						input = int.Parse(Console.Read());	
;					}
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       AX, BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
make_item_selection:
	call get_user_input
	call parse_int
	dec bl
	mov dl, bl

	cmp bl, 0
	jl .return
	cmp bl, 14
	jg .return

	call check_item_cost
	jg .insufficientFunds
	mov cx, ax

	StringCompareInsensitive Character.class, Classes + 2 * string_size
	je .cleric

	StringCompareInsensitive Character.class, Classes + 3 * string_size
	je .wizard

	jmp .purchase

	.cleric:
		call check_cleric_item
		test ax, ax
		jz .purchase
		PrintString ClericCannotUseString
	jmp make_item_selection

	.wizard:
		call check_wizard_item
		test ax, ax
		jz .purchase
		PrintString WizardCannotUseString
	jmp make_item_selection

	.insufficientFunds:
		PrintString CostsTooMuchString + 0 * string_size
		PrintString CostsTooMuchString + 1 * string_size
	jmp make_item_selection

	.purchase:
		push ax
		mov al, dl
		call add_to_inventory
		pop ax
		mov ax, cx
		call remove_gold
		call show_gold

	jmp make_item_selection
	.return:
ret

;********************************************************************************
;   check_cleric_item
;   Purpose:
;      To check if a cleric can use the item
;           Prototype:
;               bool check_cleric_item(byte input);
;           Algorithm:
;               bool check_cleric_item(byte input){
;					return input == 3 || input == 7 || input == 8 || input >= 9;
;               }
;               
;   Entry:
;       Byte DL as the Item Number
;   Exit:
;       Word AX as the Boolean Response
;   Uses:
;       AX, DL
;   Exceptions:
;       
;*******************************************************************************
check_cleric_item:
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

;********************************************************************************
;   check_wizard_item
;   Purpose:
;      To check if a wizard can use the item
;           Prototype:
;               bool check_wizard_item(byte input);
;           Algorithm:
;               bool check_wizard_item(byte input){
;					return input == 2 || input == 7 || input >= 9;
;               }
;               
;   Entry:
;       Byte DL as the Item Number
;   Exit:
;       Word AX as the Boolean Response
;   Uses:
;       AX, DL
;   Exceptions:
;       
;*******************************************************************************
check_wizard_item:
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

;********************************************************************************
;   check_item_cost
;   Purpose:
;      To check if the player can afford the item
;           Prototype:
;               bool check_item_cost(byte input);
;           Algorithm:
;               bool check_item_cost(byte input){
;					return Character.gold > Item[input].price;
;               }
;               
;   Entry:
;       Byte DL as the Item Number
;   Exit:
;       Word AX as the Boolean Response
;   Uses:
;       AX, DL
;   Exceptions:
;       
;*******************************************************************************
check_item_cost:
	push bx
	push cx
	push dx
	mov ax, bx
	mov bx, item_size
	mul bx
	mov bx, ax

	mov ax, [bx + Items + item.price]
	cmp ax, word [Character.gold]
	pop dx
	pop cx
	pop bx
ret