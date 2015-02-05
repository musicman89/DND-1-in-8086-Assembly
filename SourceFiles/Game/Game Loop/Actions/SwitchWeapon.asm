;********************************************************************************
;   switch_weapon
;   Purpose:
;      To allow the player to switch weapons
;           Prototype:
;               void switch_weapon();
;           Algorithm:
;               void switch_weapon(){
;					while(true){
;						Console.WriteLine(SwitchWeaponStrings[0]);
;						string input = int.Parse(Console.Read());
;						if(input == 0 || check_inventory(input) > 0){
;							Console.WriteLine(SwitchWeaponStrings[2] + Items[0]);
;							Character.weapon = input;
;							Pass();
;							return;
;						}
;						Console.WriteLine(SwitchWeaponStrings[1]);
;					}
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
switch_weapon:
	PrintString SwitchWeaponStrings + 0 * string_size
	.loop:
		call get_user_input
		cmp bx, 0
		je .switch

		mov ax, bx
		call check_inventory
		cmp ax, 0
		jge .switch

		PrintString SwitchWeaponStrings + 1 * string_size
		jmp .loop
	.switch:
		PrintString SwitchWeaponStrings + 2 * string_size
		mov byte [Character.weapon], bl
ret