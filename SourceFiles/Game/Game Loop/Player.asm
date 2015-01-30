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
;       AX, BX, CX, DX
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