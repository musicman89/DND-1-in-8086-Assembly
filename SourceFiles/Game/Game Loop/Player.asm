;********************************************************************************
;   check_inventory
;   Purpose:
;      To check a player's inventory for a given item
;           Prototype:
;               Byte check_inventory(Byte item);
;           Algorithm:
;               Byte check_inventory(Byte item){
;					for(int x = Character.itemCount; x > 0; x--){
;						if(Character.inventory[x] == item) return x
;					}
;					return -1;
;               }
;               
;   Entry:
;       Byte item number in AX
;   Exit:
;       Byte inventory number in AX
;   Uses:
;       AX, BX
;   Exceptions:
;       
;*******************************************************************************
check_inventory:
	push bx
	mov bh, 0
	mov bl, byte[Character + player.itemCount]
	.loop:
		cmp al, byte[Character + player.inventory + bx]
		je .yes
	dec bx
	jnz .loop
	.no:
		mov ax, -1
		jmp .return
	.yes:
		mov ax, bx
	.return:
		pop bx
ret

;********************************************************************************
;   remove_from_inventory
;   Purpose:
;      To remove an item from the player's inventory
;           Prototype:
;               void remove_from_inventory(Byte item);
;           Algorithm:
;               void remove_from_inventory(Byte item){
;					int temp = Character.inventory[Character.itemCount -1];
;					Character.inventory[item] = temp;
;					Character.itemCount--;
;               }
;               
;   Entry:
;       Byte inventory number in AX
;   Exit:
;       None
;   Uses:
;       AX, BX, CX
;   Exceptions:
;       
;*******************************************************************************
remove_from_inventory:
	push bx
	mov bh, 0
	push cx
		mov bl, [Character + player.itemCount]
		dec bl
		mov cl, [Character + player.inventory + bx]
		mov bl, al
		mov [Character + player.inventory + bx], cl
		mov [Character + player.itemCount], bl
	pop cx
	pop bx
ret

;********************************************************************************
;   add_to_inventory
;   Purpose:
;      To add an item to the player's inventory
;           Prototype:
;               void add_to_inventory(Byte item);
;           Algorithm:
;               void add_to_inventory(Byte item){
;					Character.itemCount++;
;					Character.inventory[Character.itemCount] = item;
;               }
;               
;   Entry:
;       Byte inventory number in AX
;   Exit:
;       None
;   Uses:
;       AX, BX, CX
;   Exceptions:
;       
;*******************************************************************************
add_to_inventory:
	push bx
	mov bh, 0
	push cx
		mov bl, [Character + player.itemCount]
		inc bl
		mov [Character + player.inventory + bx], al
		mov [Character + player.itemCount], bl
	pop cx
	pop bx
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

add_gold:
	mov bx, [Character + player.gold]
	add bx, ax
	mov [Character + player.gold], bx
ret

remove_gold:
	mov bx, [Character + player.gold]
	sub bx, ax
	mov [Character + player.gold], bx
ret

get_tile_number:
	mov ax, dx
	mov bx, 25
	mul bx
	add ax, cx
	mov bx, ax
ret


;********************************************************************************
;   show_gold
;   Purpose:
;      To show how much gold the player currently has
;           Prototype:
;               void show_gold();
;           Algorithm:
;               void show_gold(){
;					Console.WriteLine(GPString + Character.gold);
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
show_gold:
	PrintString GPString
	mov bx, [Character + player.gold]
	call print_dec
	call new_line
ret

;********************************************************************************
;   show_hp
;   Purpose:
;      To show how much hp the player currently has
;           Prototype:
;               void show_hp();
;           Algorithm:
;               void show_hp(){
;					Console.WriteLine(HPString + Character.hp);
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
show_hp:
	PrintString HPString
	mov bx, [Character + player.hp]
	call print_dec
	call new_line
ret