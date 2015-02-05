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
	mov bl, byte[Character.itemCount]
	.loop:
		cmp al, byte[Character.inventory + bx]
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
;   print_attributes
;   Purpose:
;      To display the player's attributes
;           Prototype:
;               void print_attributes();
;           Algorithm:
;               void print_attributes(){
;					for(int x = 0; x < 8; x++){
;						Console.Write(CharacterAttributeNames[x] + " " + Character.attributes[x]);
;						Console.NewLine();
;					}
;					Console.Read();
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       BX, CX
;   Exceptions:
;       
;*******************************************************************************
print_attributes:
	mov cx, 7
	.loop:

		mov bx, cx
		sub bx, 1
		shl bx, 3
		add bx, CharacterAttributeNames
		call print_string

		PrintString Space
		mov bx, cx
		sub bx, 1
		shl bx, 1
		mov bx, [Character.str + bx]
		call print_dec
		call new_line
		dec cx
		cmp cx, 0
		jne .loop
		call wait_key
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
		mov bl, [Character.itemCount]
		dec bl
		mov cl, [Character.inventory + bx]
		mov bl, al
		mov [Character.inventory + bx], cl
		mov [Character.itemCount], bl
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
		mov bl, [Character.itemCount]
		inc bl
		mov [Character.inventory + bx], al
		mov [Character.itemCount], bl
	pop cx
	pop bx
ret

die:

ret

lose_hp:
	mov bx, [Character.hp]
	sub bx, ax
	mov [Character.hp], bx
ret

add_hp:
	mov bx, [Character.hp]
	add bx, ax
	mov [Character.hp], bx
ret

lose_one_hp:
	mov bx, [Character.hp]
	dec bx
	mov [Character.hp], bx
ret

add_gold:
	mov bx, [Character.gold]
	add bx, ax
	mov [Character.gold], bx
ret

remove_gold:
	mov bx, [Character.gold]
	sub bx, ax
	mov [Character.gold], bx
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
	mov bx, [Character.gold]
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
	mov bx, [Character.hp]
	call print_dec
	call new_line
ret

;********************************************************************************
;   check_cleric_spell
;   Purpose:
;      To check if a player has a specific cleric spell
;           Prototype:
;               byte check_cleric_spell(byte spell);
;           Algorithm:
;               byte check_cleric_spell(byte spell){
;					for(int x = 1; x < Character.clericSpellCount; x++){
;						if(spell == Character.clericSpells[x]){
;							return x;
;						}
;					}
;					return -1
;				}
;               
;   Entry:
;       Byte spell in BX
;   Exit:
;       Byte location in AX
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
check_cleric_spell:

ret

;********************************************************************************
;   check_wizard_spell
;   Purpose:
;      To check if a player has a specific wizard spell
;           Prototype:
;               byte check_wizard_spell(byte spell);
;           Algorithm:
;               byte check_wizard_spell(byte spell){
;					for(int x = 1; x < Character.wizardSpellCount; x++){
;						if(spell == Character.wizardSpells[x]){
;							return x;
;						}
;					}
;					return -1
;               }
;               
;   Entry:
;       Byte spell in BX
;   Exit:
;       Byte location in AX
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
check_wizard_spell:

ret

remove_cleric_spell:

ret

remove_wizard_spell:

ret

;********************************************************************************
;   get_y_bounds
;   Purpose:
;      To limit the bounds to the vertical range of the map
;           Prototype:
;               Void get_y_bounds(byte range);
;           Algorithm:
;               Void get_y_bounds(byte range){
;					int starty = Character.y;
;					int endy = 0;
;					if(starty - range > 0){
;						if(starty + range < 25){
;							starty -= range;
;							endy = starty + range * 2;
;						}
;						else{
;							starty = (starty - range) ;
;							endy = 25;
;						}
;					}
;					else{
;						endy = (starty + range) ;
;						starty = 0;
;					}
;               }
;               
;   Entry:
;       Byte Range in CH
;   Exit:
;       starty in CL, endy in CH
;   Uses:
;       AX, BX, CX
;   Exceptions:
;       
;*******************************************************************************
get_y_bounds:
	mov cl, [Character.y]
	mov bl, cl
	sub bl, ch
	cmp bl, 0
	jl .lower_x
	mov bl, cl
	add bl, ch
	cmp bl, 25
	jg .upper_x
		sub ch, ch
		mov bl, ch
		mov ch, cl
		add ch, bl
		add ch, bl
		jmp .return
	.upper_x:
		sub cl, ch
		mov ch, 25
		jmp .return
	.lower_x:		
		add ch, cl
		mov cl, 0
		jmp .return
	.return:
ret

;********************************************************************************
;   get_x_bounds
;   Purpose:
;      To limit the bounds to the horizongal range of the map
;           Prototype:
;               Void get_x_bounds(byte range);
;           Algorithm:
;               Void get_x_bounds(byte range){
;					int startx = Character.x;
;					int endx = 0;
;					if(startx - range > 0){
;						if(startx + range < 25){
;							startx -= range;
;							endx = startx + range * 2;
;						}
;						else{
;							startx = startx - range;
;							endx = 25;
;						}
;					}
;					else{
;						endx = startx + range;
;						startx = 0;
;					}
;               }
;               
;   Entry:
;       Byte Range in DH
;   Exit:
;       startx in DL, endx in DH
;   Uses:
;       BX, DX
;   Exceptions:
;       
;*******************************************************************************
get_x_bounds:
	mov dl, [Character.x]
	mov bl, dl
	sub bl, dh
	cmp bl, 0
	jl .lower_x
	mov bl, dl
	add bl, dh
	cmp bl, 25
	jg .upper_x
		sub dl, dh
		mov bl, dh
		mov dh, dl
		add dh, bl
		add dh, bl
		jmp .return
	.upper_x:
		sub dl, dh
		mov dh, 25
		jmp .return
	.lower_x:		
		add dh, dl
		mov dl, 0
		jmp .return
	.return:
ret

rows:
dw 25 * 0
dw 25 * 1
dw 25 * 2
dw 25 * 3
dw 25 * 4
dw 25 * 5
dw 25 * 6
dw 25 * 7
dw 25 * 8
dw 25 * 9
dw 25 * 10
dw 25 * 11
dw 25 * 12
dw 25 * 13
dw 25 * 14
dw 25 * 15
dw 25 * 16
dw 25 * 17
dw 25 * 18
dw 25 * 19
dw 25 * 20
dw 25 * 21
dw 25 * 22
dw 25 * 23
dw 25 * 24