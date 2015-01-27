struc CharacterAttribute
	.name resb 8
endstruc

%macro NewAttribute 1
	istruc CharacterAttribute
		at CharacterAttribute.name, db %1
	iend
%endmacro


CharacterAttributeNames:
NewAttribute 'STR'
NewAttribute 'DEX'
NewAttribute 'CON'
NewAttribute 'CHAR'
NewAttribute 'WIS'
NewAttribute 'INT'
NewAttribute 'GOLD'
