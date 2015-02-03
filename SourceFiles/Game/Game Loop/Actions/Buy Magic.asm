
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
	StringCompare Character + player.class, Classes + 2 * string_size
	je .cleric
	
	StringCompare Character + player.class, Classes + 3 * string_size
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
;								RemoveGold(WizardSpells[choice].cost);
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

ret