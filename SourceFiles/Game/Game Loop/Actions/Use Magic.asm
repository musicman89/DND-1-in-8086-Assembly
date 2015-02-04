
;********************************************************************************
;   use_magic
;   Purpose:
;      To allow the player to use magic
;           Prototype:
;               void use_magic();
;           Algorithm:
;               void use_magic(){
;					Console.WriteLine(useMagicStrings[0])
;					if(Character.weapon != 0){
;						Console.WriteLine(UseMagicStrings[1]);
;						pass();
;					}
;   				else if(Character.class == "CLERIC") {
;						use_cleric_spell();
;					}
;					else if(Character.class = "WIZARD"){
;						user_wizard_spell();
;					}
;					else{
;						Console.WriteLine(UseMagicStrings[2]);
;						pass();
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
use_magic:
	PrintString UseMagicStrings + 0 * string_size
	cmp [Character + player.weapon], 0
	jne .hasWeapon
	StringCompareInsensitive Character + player.class, Classes + 2 * string_size
	jne .wizard
		call use_cleric_spell
		jmp .return
	.wizard:
	StringCompareInsensitive Character + player.class, Classes + 3 * string_size
	jne .none
		call user_wizard_spell
		jmp .return
	.none:
		PrintString + 2 * string_size
		call pass
		jmp .return
	.hasWeapon:
		PrintString UseMagicStrings + 1 * string_size
		call pass
	.return:
ret

;********************************************************************************
;   use_cleric_spell
;   Purpose:
;      To allow the player to cast a cleric spell
;           Prototype:
;               void use_cleric_spell();
;           Algorithm:
;               void use_cleric_spell(){
;					Console.WriteLine(UseMagicStrings[3]);
;					int input = int.Parse(Console.ReadLine());
;					int location = check_cleric_spell(input);
;					if(location < 0){
;						Console.WriteLine(UseMagicStrings[4]);
;						pass();
;					}
;					else {
;						remove_cleric_spell(location);
;						if(input == 1) {
;							cleric_kill();
;						}
;						else if(input == 2) {
;							cleric_magic_missile_2();
;						}
;						else if(input == 3) {
;							cleric_cure_light_1();
;						}
;						else if(input == 4) {
;							find_all_traps();
;						}
;						else if(input == 5) {
;							cleric_magic_missile_1();
;						}
;						else if(input == 6) {
;							cleric_magic_missile_3();
;						}
;						else if(input == 7) {
;							cleric_cure_light_2();
;						}
;						else if(input == 8) {
;							find_all_secret_doors();
;						}
;						else if(input == 9) {
;							cleric_repel_undead();
;						}
;						else{
;							Console.WriteLine(UseMagicStrings[4]);
;							pass();
;						}
;
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
use_cleric_spell:

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
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
check_cleric_spell:

ret

;********************************************************************************
;   cleric_repel_undead
;   Purpose:
;      To allow the player to cas the cleric repel undead spell
;           Prototype:
;               void cleric_repel_undead();
;           Algorithm:
;               void cleric_repel_undead(){
;					if(CurrentMonster.type == 4 || CurrentMonster.type == 10){
;						Console.WriteLine(DoneString);
;						move_monster(0,(CurrentMonster.x - Character.x)/(CurrentMonster.x - Character.x);
;						pass();
;					}
;					else{
;						Console.WriteLine(FailedString);
;					}
;				}
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
cleric_repel_undead:

ret

;********************************************************************************
;   cleric_kill
;   Purpose:
;      To allow the player to cast the cleric kill spell
;           Prototype:
;               void cleric_kill();
;           Algorithm:
;               void cleric_kill(){
;					if(random_int(3) < 2){
;						Console.WriteLine(DoneString);
;						CurrentMonster.status = -1;
;						pass();
;					}
;					else{
;						Console.WriteLine(FailedString);
;						pass();
;					}
;				}
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
cleric_kill:

ret

;********************************************************************************
;   cleric_magic_missile_1
;   Purpose:
;      To allow a player to cast the cleric magic missile #1
;           Prototype:
;               void cleric_magic_missile_1();
;           Algorithm:
;               void cleric_magic_missile_1(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= 2;
;					pass();
;				}
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
cleric_magic_missile_1:

ret

;********************************************************************************
;   cleric_magic_missile_2
;   Purpose:
;      To allow a player to cast the cleric magic missile #2
;           Prototype:
;               void cleric_magic_missile_2();
;           Algorithm:
;               void cleric_magic_missile_2(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= 4;
;					pass();
;				}
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
cleric_magic_missile_2:

ret

;********************************************************************************
;   cleric_magic_missile_3
;   Purpose:
;      To allow a player to cast the cleric magic missile #3
;           Prototype:
;               void cleric_magic_missile_3();
;           Algorithm:
;               void cleric_magic_missile_3(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= 6;
;					pass();
;				}
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
cleric_magic_missile_3:

ret

;********************************************************************************
;   cleric_cure_light_1
;   Purpose:
;      To allow a player to cast the cleric magic missile #3
;           Prototype:
;               void cleric_cure_light_1();
;           Algorithm:
;               void cleric_cure_light_1(){
;					Console.WriteLine(DoneString);
;					Character.hp += 3;
;					pass();
;				}
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
cleric_cure_light_1:

ret

;********************************************************************************
;   cleric_cure_light_2
;   Purpose:
;      To allow a player to cast the cleric magic missile #3
;           Prototype:
;               void cleric_cure_light_2();
;           Algorithm:
;               void cleric_cure_light_2(){
;					Console.WriteLine(DoneString);
;					Character.hp += 3;
;					pass();
;				}
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
cleric_cure_light_2:

ret

;********************************************************************************
;   find_all_traps
;   Purpose:
;      To allow a player to cast the find all traps spell
;           Prototype:
;               void find_all_traps();
;           Algorithm:
;               void find_all_traps(){
;					find(2);
;				}
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
find_all_traps:

ret

;********************************************************************************
;   find_all_secret_doors
;   Purpose:
;      To allow a player to cast the find all secret doors spell
;           Prototype:
;               void find_all_secret_doors();
;           Algorithm:
;               void find_all_secret_doors(){
;					find(3);
;				}
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
find_all_secret_doors:

ret

;********************************************************************************
;   find
;   Purpose:
;      To allow a player to cast the find spell
;           Prototype:
;               void find(byte tile);
;           Algorithm:
;               void find(byte tile){
;					var y_bounds = get_y_bounds(3);
;					var x_bounds = get_x_bounds(3);
;					for(int y = y_bounds.lower; y < y_bounds.upper; y++){
;						int row = rows[y];
;						for(int x = x_bounds.lower; x < x_bounds.upper; x++){
;							if(CurrentDungeon[row + x] == tile){
;								Console.WriteLine(UseMagicStrings[6] + x + UseMagicStrings[7] + y + UseMagicStrings[8]);
;							}
;						}
;					}
;					Console.WriteLine(UseMagicStrings[5]);
;					pass();
;				}
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
find:

ret

;********************************************************************************
;   user_wizard_spell
;   Purpose:
;      To allow the player to cast a wizard spell
;           Prototype:
;               void user_wizard_spell();
;           Algorithm:
;               void user_wizard_spell(){
;					Console.WriteLine(UseMagicStrings[9]);
;					int input = int.Parse(Console.ReadLine());
;					int location = check_wizard_spell(input);
;					if(location < 0){
;						Console.WriteLine(UseMagicStrings[10]);
;						pass();
;					}
;					else {
;						remove_wizard_spell(location);
;						if(input == 1) {
;							wizard_push();
;						}
;						else if(input == 2) {
;							wizard_kill();
;						}
;						else if(input == 3) {
;							find_traps();
;						}
;						else if(input == 4) {
;							wizard_teleport();
;						}
;						else if(input == 5) {
;							wizard_change_1_0();
;						}
;						else if(input == 6) {
;							wizard_magic_missile_1();
;						}
;						else if(input == 7) {
;							wizard_magic_missile_2();
;						}
;						else if(input == 8) {
;							wizard_magic_missile_3();
;						}
;						else if(input == 9) {
;							find_secret_doors();
;						}
;						else if(input == 10) {
;							wizard_change_0_1();
;						}
;						else{
;							Console.WriteLine(UseMagicStrings[10]);
;							pass();
;						}
;
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
user_wizard_spell:

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
;       None
;   Exit:
;       None
;   Uses:
;       BX
;   Exceptions:
;       
;*******************************************************************************
check_wizard_spell:

ret

;********************************************************************************
;   wizard_magic_missile_1
;   Purpose:
;      To allow a player to cast the wizard magic missile #1
;           Prototype:
;               void wizard_magic_missile_1();
;           Algorithm:
;               void wizard_magic_missile_1(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= (3 + random_int(11));
;					Console.WriteLine(UseMagicStrings[11]);
;					pass();
;				}
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
wizard_magic_missile_1:

ret

;********************************************************************************
;   wizard_magic_missile_2
;   Purpose:
;      To allow a player to cast the wizard magic missile #2
;           Prototype:
;               void wizard_magic_missile_2();
;           Algorithm:
;               void wizard_magic_missile_2(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= (6 + random_int(11));
;					Console.WriteLine(UseMagicStrings[11]);
;					pass();
;				}
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
wizard_magic_missile_2:

ret

;********************************************************************************
;   wizard_magic_missile_3
;   Purpose:
;      To allow a player to cast the wizard magic missile #3
;           Prototype:
;               void wizard_magic_missile_3();
;           Algorithm:
;               void wizard_magic_missile_3(){
;					Console.WriteLine(DoneString);
;					CurrentMonster.hp -= (9 + random_int(11));
;					Console.WriteLine(UseMagicStrings[11]);
;					pass();
;				}
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
wizard_magic_missile_3:

ret

;********************************************************************************
;   wizard_teleport
;   Purpose:
;      To allow a player to cast the wizard teleport spell
;           Prototype:
;               void wizard_teleport();
;           Algorithm:
;               void wizard_teleport(){
;					Console.WriteLine(UseMagicStrings[12]);
;					Console.WriteLine(UseMagicStrings[7]);
;					Character.x = int.Parse(Console.Read());
;					Console.WriteLine(UseMagicStrings[8]);
;					Character.y = int.Parse(Console.Read());
;					pass();
;				}
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
wizard_teleport:

ret

;********************************************************************************
;   wizard_change_0_1
;   Purpose:
;      To allow a player to cast the wizard change 1 0 spell
;           Prototype:
;               void wizard_change_1_0(byte tile);
;           Algorithm:
;               void wizard_change_1_0(byte tile){
;					wizard_change(1);
;				}
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
wizard_change_0_1:

ret

;********************************************************************************
;   wizard_change_1_0
;   Purpose:
;      To allow a player to cast the wizard change 1 0 spell
;           Prototype:
;               void wizard_change_1_0(byte tile);
;           Algorithm:
;               void wizard_change_1_0(byte tile){
;					wizard_change(0);
;				}
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
wizard_change_1_0:

ret

;********************************************************************************
;   wizard_change
;   Purpose:
;      To allow a player to cast the wizard change spell
;           Prototype:
;               void wizard_change(byte tile);
;           Algorithm:
;               void wizard_change(byte tile){
;					Console.WriteLine(UseMagicStrings[12]);
;					Console.WriteLine(UseMagicStrings[7]);
;					int x = int.Parse(Console.Read());
;					Console.WriteLine(UseMagicStrings[8]);
;					int y = int.Parse(Console.Read());
;					if(CurrentDungeon[rows[y] + x] == 0 || CurrentDungeon[rows[y] + x] ==1){
;						CurrentDungeon[rows[y] + x] = tile;
;						Console.WriteLine(DoneString);
;					}
;					else{
;						Console.WriteLine(FailedString)
;					}
;					pass();
;				}
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
wizard_change:

ret

;********************************************************************************
;   wizard_kill
;   Purpose:
;      To allow a player to cast the wizard kill spell
;           Prototype:
;               void wizard_kill();
;           Algorithm:
;               void wizard_kill(){
;					if(random_int(3) > 1){
;						CurrentMonster.status = -1;
;						Console.WriteLine(DoneString);
;					}
;					else{
;						Console.WriteLine(FailedString)
;					}
;					pass();
;				}
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
wizard_kill:

ret

;********************************************************************************
;   wizard_push
;   Purpose:
;      To allow a player to cast the wizard kill spell
;           Prototype:
;               void wizard_push();
;           Algorithm:
;               void wizard_push(){
;					bool force = false;
;					if(CurrentMonster.x - Character.x != 0 && CurrentMonster.y - Character.y != 0){
;						force = true;
;					}
;					Console.WriteLine(UseMagicStrings[13]);
;					push_monster(force);
;				}
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
wizard_push:

ret