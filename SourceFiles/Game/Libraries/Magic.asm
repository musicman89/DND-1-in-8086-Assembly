section .text
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
	push bx
	mov bh, 0
	mov bl, byte[Character.clericSpellCount]
	.loop:
		cmp al, byte[Character.clericSpells + bx]
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
	push bx
	mov bh, 0
	mov bl, byte[Character.wizardSpellCount]
	.loop:
		cmp al, byte[Character.wizardSpells + bx]
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
