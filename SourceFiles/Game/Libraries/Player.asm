section .text

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
		push cx
		mov cl, 3
		shl bx, cl
		pop cx
		add bx, CharacterAttributeNames
		Write bx

		Write Space
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
;   lose_hp
;   Purpose:
;      To reduce a player's hp
;           Prototype:
;               void lose_hp(int amount);
;           Algorithm:
;               void lose_hp(int amount){
;					Chracter.hp -= amount;
;               }
;               
;   Entry:
;       Amount in AX
;   Exit:
;       None
;   Uses:
;       AX, BX
;   Exceptions:
;       
;*******************************************************************************
lose_hp:
	sub [Character.hp], ax
ret

;********************************************************************************
;   add_hp
;   Purpose:
;      To increase a player's hp
;           Prototype:
;               void add_hp(int amount);
;           Algorithm:
;               void add_hp(int amount){
;					Chracter.hp += amount;
;               }
;               
;   Entry:
;       Amount in AX
;   Exit:
;       None
;   Uses:
;       AX, BX
;   Exceptions:
;       
;*******************************************************************************
add_hp:
	add [Character.hp], ax
ret

;********************************************************************************
;   lose_one_hp
;   Purpose:
;      To reduce a player's hp by one
;           Prototype:
;               void lose_one_hp();
;           Algorithm:
;               void lose_one_hp(){
;					Chracter.hp--;
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       AX, BX
;   Exceptions:
;       
;*******************************************************************************
lose_one_hp:
	dec word [Character.hp]
ret

;********************************************************************************
;   add_gold
;   Purpose:
;      To increase a player's gold
;           Prototype:
;               void add_gold(int amount);
;           Algorithm:
;               void add_gold(int amount){
;					Chracter.gold += amount;
;               }
;               
;   Entry:
;       Amount in AX
;   Exit:
;       None
;   Uses:
;       AX, BX
;   Exceptions:
;       
;*******************************************************************************
add_gold:
	add [Character.gold], ax
ret

;********************************************************************************
;   remove_gold
;   Purpose:
;      To reduce a player's gold
;           Prototype:
;               void remove_gold(int amount);
;           Algorithm:
;               void remove_gold(int amount){
;					Chracter.gold -= amount;
;               }
;               
;   Entry:
;       Amount in AX
;   Exit:
;       None
;   Uses:
;       AX, BX
;   Exceptions:
;       
;*******************************************************************************
remove_gold:
	sub [Character.gold], ax
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
	Write GPString
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
	Write HPString
	mov bx, [Character.hp]
	call print_dec
	call new_line
ret

;********************************************************************************
;   die
;   Purpose:
;      To handle a player's death
;           Prototype:
;               void die();
;           Algorithm:
;               void die(){
;					dead();
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       None
;   Exceptions:
;       
;*******************************************************************************
die:
	call dead
ret