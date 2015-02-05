
;********************************************************************************
;   buy_magic
;   Purpose:
;      To allow the player to buy magic
;           Prototype:
;               void buy_magic();
;           Algorithm:
;               void buy_magic(){
;   				if(Character.class == "CLERIC") {
;						buy_cleric_spells();
;						show_cleric_spells();
;					}
;					else if(Character.class = "WIZARD"){
;						buy_wizard_spells();
;						show_wizard_spells();
;					}
;					else{
;						Console.WriteLine(BuyMagicStrings[0]);
;					}
;					Console.Read();
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
buy_magic:
	StringCompare Character.class, Classes + 2 * string_size
	je .cleric
	
	StringCompare Character.class, Classes + 3 * string_size
	je .wizard

	PrintString BuyMagicStrings * 0 * string_size
	jmp .return
	.cleric:
		call buy_cleric_spells
		call show_cleric_spells
		jmp .return
	.wizard:
		call buy_wizard_spells
		call show_wizard_spells
	.return:
		call wait_key
ret


;********************************************************************************
;   buy_wizard_spells
;   Purpose:
;      To allow the player to buy wizard spells
;           Prototype:
;               void buy_wizard_spells();
;           Algorithm:
;               void buy_wizard_spells(){
;					Console.WriteLine(BuyWizardSpellsStrings[0]);
;					string input = Console.ReadLine().ToUpper();
;					if(input == "YES"){
;						Console.WriteLine(BuyWizardSpellsStrings[1]);	
;						Console.WriteLine(BuyWizardSpellsStrings[2]);	
;						Console.WriteLine(BuyWizardSpellsStrings[3]);	
;						Console.WriteLine(BuyWizardSpellsStrings[4]);	
;						Console.WriteLine(BuyWizardSpellsStrings[5]);	
;						Console.WriteLine(BuyWizardSpellsStrings[6]);			
;					}
;					while(true){
;						int choice = int.Parse(Console.ReadLine());
;						if(choice < 1){
;							return;
;						}
;						else if(choice <= 10){
;							if(WizardSpells[choice].cost <= Character.gold){
;								remove_gold(WizardSpells[choice].cost);
;								Character.wizardSpells[Character.wizardSpellCount] = choice;
;								Character.wizardSpellCount++;
;								Console.WriteLine(BuyWizardSpellsStrings[7]);
;								return
;							}
;							else{
;								Console.WriteLine(BuyWizardSpellsStrings[8]);	
;							}
;						}
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
buy_wizard_spells:
	PrintString BuyWizardSpellsStrings + 0 * string_size
	call new_line
	call get_user_input
	StringCompareInsensitive bx, YesString
	jne .loop
		PrintString BuyWizardSpellsStrings + 1 * string_size
		call new_line
		PrintString BuyWizardSpellsStrings + 2 * string_size
		call new_line
		PrintString BuyWizardSpellsStrings + 3 * string_size
		call new_line
		PrintString BuyWizardSpellsStrings + 4 * string_size	
		call new_line
		PrintString BuyWizardSpellsStrings + 5 * string_size	
		call new_line
		PrintString BuyWizardSpellsStrings + 6 * string_size	
		call new_line
	.loop:
	call get_user_input
	call parse_int
	test bx, bx
	jl .return
	cmp bx, 10
	jg .loop
		mov ax, spell_size
		mov dx, bx
		mul dx
		mov bx, ax
		mov ax, [WizardSpells + bx + spell.cost]
		cmp ax, [Character.gold]
		jg .nope
			call remove_gold

			mov bl, [Character.wizardSpellCount]
			mov [Character.wizardSpells + bx], dx
			inc byte [Character.wizardSpellCount]
			PrintString BuyWizardSpellsStrings + 7 * string_size

		.nope:
			PrintString BuyWizardSpellsStrings + 8 * string_size
	.return:
ret

;********************************************************************************
;   show_wizard_spells
;   Purpose:
;      To allow the player to buy wizard spells
;           Prototype:
;               void show_wizard_spells();
;           Algorithm:
;               void show_wizard_spells(){
;					Console.WriteLine(BuyWizardSpellsStrings[9]);
;					for(int x = 1; x < Character.wizardSpellCount; x++){
;						Console.WriteLine(BuyWizardSpellsStrings[10] + Character.wizardSpells[x]);
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
show_wizard_spells:
	PrintString BuyWizardSpellsStrings + 9 * string_size
	call new_line
	mov cl, [Character.wizardSpellCount]
	mov bh, 0
	.loop:
		PrintString BuyWizardSpellsStrings + 10 * string_size
		mov bl, cl
		mov bl, [Character.wizardSpells + bx]
		call print_dec
		call new_line
	dec cl
	jg .loop
ret

;********************************************************************************
;   buy_cleric_spells
;   Purpose:
;      To allow the player to buy cleric spells
;           Prototype:
;               void buy_cleric_spells();
;           Algorithm:
;               void buy_cleric_spells(){
;					Console.WriteLine(BuyClericSpellsStrings[0]);
;					string input = Console.ReadLine().ToUpper();
;					if(input == "YES"){
;						Console.WriteLine(BuyClericSpellsStrings[1]);	
;						Console.WriteLine(BuyClericSpellsStrings[2]);	
;						Console.WriteLine(BuyClericSpellsStrings[3]);	
;						Console.WriteLine(BuyClericSpellsStrings[4]);	
;						Console.WriteLine(BuyClericSpellsStrings[5]);		
;					}
;					while(true){
;						int choice = int.Parse(Console.ReadLine());
;						if(choice < 1){
;							return;
;						}
;						else if(choice <= 10){
;							if(ClericSpells[choice].cost <= Character.gold){
;								RemoveGold(ClericSpells[choice].cost);
;								Character.clericSpells[Character.clericSpellCount] = choice;
;								Character.clericSpellCount++;
;								Console.WriteLine(BuyClericSpellsStrings[6]);
;								return
;							}
;							else{
;								Console.WriteLine(BuyClericSpellsStrings[7]);	
;							}
;						}
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
buy_cleric_spells:
	PrintString BuyClericSpellsStrings + 0 * string_size
	call new_line
	call get_user_input
	StringCompareInsensitive bx, YesString
	jne .loop
		PrintString BuyClericSpellsStrings + 1 * string_size
		call new_line
		PrintString BuyClericSpellsStrings + 2 * string_size
		call new_line
		PrintString BuyClericSpellsStrings + 3 * string_size
		call new_line
		PrintString BuyClericSpellsStrings + 4 * string_size	
		call new_line
		PrintString BuyClericSpellsStrings + 5 * string_size	
		call new_line
	.loop:
	call get_user_input
	call parse_int
	test bx, bx
	jl .return
	cmp bx, 10
	jg .loop
		mov ax, spell_size
		mov dx, bx
		mul dx
		mov bx, ax
		mov ax, [ClericSpells + bx + spell.cost]
		cmp ax, [Character.gold]
		jg .nope
			call remove_gold

			mov bl, [Character.clericSpellCount]
			mov [Character.clericSpells + bx], dx
			inc byte [Character.clericSpellCount]
			PrintString BuyClericSpellsStrings + 6 * string_size
			call new_line
		.nope:
			PrintString BuyClericSpellsStrings + 7 * string_size
			call new_line
	.return:
ret


;********************************************************************************
;   show_cleric_spells
;   Purpose:
;      To allow the player to buy wizard spells
;           Prototype:
;               void show_cleric_spells();
;           Algorithm:
;               void show_cleric_spells(){
;					Console.WriteLine(BuyClericSpellsStrings[8]);
;					for(int x = 1; x < Character.clericSpellCount; x++){
;						Console.WriteLine(BuyClericSpellsStrings[9] + Character.clericSpells[x]);
;					}
;					Console.WriteLine(BuyClericSpellsStrings[10]);
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
show_cleric_spells:
	PrintString BuyClericSpellsStrings + 10 * string_size
	call new_line
	mov cl, [Character.clericSpells]
	mov bh, 0
	.loop:
		PrintString BuyClericSpellsStrings + 9 * string_size
		mov bl, cl
		mov bl, [Character.clericSpells + bx]
		call print_dec
		call new_line
	dec cl
	jg .loop
	PrintString BuyClericSpellsStrings + 10 * string_size
ret