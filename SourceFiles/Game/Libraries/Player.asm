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

die:
	call dead
ret