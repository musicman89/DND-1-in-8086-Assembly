struc string
	.value resb 64
endstruc

%macro NewString 1+
	istruc string
		at string.value, db %1, 0
	iend
%endmacro

TitleString: 
NewString 'DND1',13, 10
NewString 'Copyright 1977-2015 Richard Garriott', 13, 10
NewString 'Ported By Davan Etelamaki', 13, 10

NeedInstructionsString: 
NewString 'DO YOU NEED INSTRUCTIONS? Y/N: '

WhoSaidString: 
NewString 'WHO SAID YOU COULD PLAY',13, 10

NoInstructionsString: 
NewString 'OLD OR NEW GAME: '

DungeonNumberString: 
NewString 'DUNGEON # '

ResetContinuesString: 
NewString 'CONTINUES RESET 1=YES, 2=NO: '

PlayerNameInputString: 
NewString 'PLAYERS NAME: '

PlayerNameShavs: 
NewString 'SHAVS'

ClassStrings: 
NewString 'CLASSIFICATION', 13, 10
NewString 'WHICH DO YOU WANT TO BE', 13, 10
NewString 'FIGHTER, CLERIC, OR WIZARD ', 13, 10


Classes:
NewString "none"
NewString "Fighter"
NewString "Cleric"
NewString "Wizard"

WelcomeStrings:
NewString "WELCOME TO DUNGEON # {0}", 13, 10
NewString "YOU ARE AT ({0},{1})", 13, 10

WeaponStoreStrings:
NewString "BUYING WEAPONS",13,10
NewString "FAST OR NORM",13,10

YesString: 
NewString 'YES'

NoString: 
NewString 'NO'

NewGameString: 
NewString 'NEW'

OldGameString: 
NewString 'OLD'

Space: 
NewString ' '

StringBuffer times 256 db 0 