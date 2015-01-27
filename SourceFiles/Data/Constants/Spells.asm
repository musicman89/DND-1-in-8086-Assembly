struc spell
	.name resw 32
	.cost resw 1
endstruc

%macro NewSpell 2
	istruc spell
		at spell.name, db %1
		at spell.cost, db %2
	iend
%endmacro

WizardSpells:

ClericSpells: