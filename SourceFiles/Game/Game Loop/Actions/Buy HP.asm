section .text
;********************************************************************************
;   buy_hp
;   Purpose:
;      To allow the player to buy some health points
;           Prototype:
;               void buy_hp();
;           Algorithm:
;               void buy_hp(){
;					while(true){
;						Console.WriteLine(BuyHPStrings[0]);
;						int input = int.Parse(Console.Read());
;						if(Character.gold > 200 * input){
;							add_hp(input);
;							remove_gold(200 * input);
;							Console.WriteLine(BuyHPStrings[1]);
;							show_hp();
;							print_attributes();
;							pass();
;							return;
;						}
;						else{
;							Console.WriteLine(BuyHPStrings[3]);
;						}
;					}
;               }
;               
;   Entry:
;       Int x in CX, Int y in DX
;   Exit:
;       None
;   Uses:
;       BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
buy_hp:
	WriteLine BuyHPStrings, 0
	ReadLine
	call parse_int
	mov ax, 200
	mul bx
	cmp bx, [Character.gold]
	jg .no
		call remove_gold
		mov ax, bx
		call add_hp
		WriteLine BuyHPStrings, 1
		call show_hp
		call print_attributes
		call pass
		jmp .return
	.no:
		WriteLine BuyHPStrings, 3
		jmp buy_hp
	.return:
ret