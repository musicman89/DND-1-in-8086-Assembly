struc string
	.value resb 64
endstruc

%macro NewString 1+
	istruc string
		at string.value, db %1, 0
	iend
%endmacro

TitleString: 
NewString '    Dungeons and Dragons #1',13, 10
NewString '    Copyright 1977-2015 Richard Garriott', 13, 10
NewString '               Ported By Davan Etelamaki', 13, 10

NeedInstructionsString: 
NewString 'DO YOU NEED INSTRUCTIONS? Y/N: '

WhoSaidString: 
NewString '"WHO SAID YOU COULD PLAY"',13, 10

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
NewString "WELCOME TO DUNGEON # "
NewString "YOU ARE AT ("
NewString ","
NewString ")", 13, 10

ItemShopString:
NewString "BUYING WEAPONS",13,10
NewString "FAST OR NORM",13,10

CostsTooMuchString:
NewString "COSTS TOO MUCH", 13, 10
NewString "TRY AGAIN ", 13, 10

WizardCannotUseString:
NewString "YOUR A WIZARD YOU CANT USE THAT"

ClericCannotUseString:
NewString "YOUR A CLERIC YOU CANT USE THAT"

GPString:
NewString "GP= "

FastString:
NewString "Fast"

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

YourCharacteristicsString:
NewString "YOUR CHARACTERISTICS ARE: "

HitPointsString:
NewString "HIT POINTS: "

EQListString:
NewString "EQ List"

CommandStrings:
NewString "COMMANDS LIST "
NewString "1=MOVE  2=OPEN DOOR  3=SEARCH FOR TRAPS AND SECRET DOORS"
NewString "4=SWITCH WEAPON HN HAND  5=FIGHT"
NewString "6=LOOK AROUND  7=SAVE GAME  8=USE MAGIC  9=BUY MAGIC"
NewString "0=PASS  11=BUY H.P."
NewString "COMMAND="
NewString "COME ON "

StringBuffer times 256 db 0 