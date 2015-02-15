align 16
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

HPString:
NewString "HP="

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

MoveStrings:
NewString "YOU ARE AT "
NewString " , "
NewString "  DOWN  RIGHT  LEFT  OR  UP"

DoneString:
NewString "DONE"

HitWallStrings:
NewString "YOU RAN INTO A WALL"
NewString "BUT NO DAMAGE WAS INFLICTED"
NewString "AND LOOSE 1 HIT POINT"

DirectionStrings:
NewString "LEFT"
NewString "RIGHT"
NewString "UP"
NewString "DOWN"

TrapStrings:
NewString "OOOOPS A TRAP AND YOU FELL IN "
NewString "AND HIT POINTS LOOSE 1"
NewString "I HOPE YOU HAVE SOME SPIKES AND PREFERABLY ROPE"
NewString "LET ME SEE"
NewString "NO SPIKES AH THATS TOO BAD CAUSE YOUR DEAD "
NewString "GOOD BOTH"
NewString "YOU MANAGE TO GET OUT EASY"
NewString "YOUR STANDING NEXT TO THE EDGE THOUGH I'D MOVE"
NewString "NO ROPE BUT AT LEAS SPIKES"
NewString "YOU FALL HALF WAY UP"
NewString "TRY AGAIN "
NewString "OOPS H.P. LOOSE 1"

SecretDoorStrings:
NewString "YOU JUST RAN INTO A SECRET DOOR"
NewString "AND OPENED IT"

RunIntoMonsterStrings:
NewString "YOU RAN INTO THE MONSTER "
NewString "HE SHOVES YOU BACK"
NewString "YOU LOOSE 6 HIT POINT "

FoundGoldStrings:
NewString "AH......GOLD......."
NewString "PIECES"

PoisonString:
NewString "       POISON      "

OpenDoorStrings:
NewString "DOOR LEFT RIGHT UP OR DOWN"
NewString "THERE IS NOT A DOOR THERE"  
NewString "PUSH"
NewString "DIDNT BUDGE"
NewString "ITS OPEN"

SearchForTrapStrings:
NewString "SEARCH.........SEARCH...........SEARCH..........."
NewString "NO NOT THAT YOU CAN TELL"
NewString "YES THERE IS A TRAP"
NewString "IT IS "
NewString "VERTICALY  "
NewString "HORAZONTALY FROM YOU"
NewString "YES A DOOR"
NewString "IT IS AT "
NewString "VERTICALY  "
NewString "HORAZANTALY"

SwitchWeaponStrings:
NewString "WHICH WEAPON WILL YOU HOLD, NUM OF WEAPON "
NewString "SORRY YOU DONT HAVE THAT ONE"
NewString "O.K. YOU ARE NOW HOLDING A "

BuyHPStrings:
NewString "HOW MANY 200 GP. EACH "
NewString "OK DONE"
NewString "HP= "

BuyMagicStrings:
NewString "YOU CANT BUY ANY"

BuyWizardSpellsStrings:
NewString "DO YOU KNOW THE SPELLS"
NewString "1-PUSH-75   6-M. M. #1-100"
NewString "2-KIHL-500  7-M. M. #2-200"
NewString "3-FIND TRAPS-200  8-M. M. #3-300"
NewString "4-TELEPORT-750  9-FIND S.DOORS-200"
NewString "5-CHANGE 1+0-600  10-CHANGE 0+1-600"
NewString "#OF ONE YOU WANT  NEG.NUM.TO STOP"
NewString "IT IS YOURS"
NewString "COSTS TOO MUCH"
NewString "YOU NOW HAVE"
NewString "#"

BuyClericSpellsStrings:
NewString "DO YOU KNOW THE CHOICES"
NewString "1-KILL-500  5-MAG. MISS. #1-100"
NewString "2-MAG. MISS. #2-200  6-MAG. MISS. #3-300"
NewString "3-CURE LHGHT #1-200  7-CURE LIGHT #2-1000"
NewString "4-FIND ALL TRAPS-200  8-FIND ALL S.DOORS-200"
NewString "INPUT # WANTED   NEG.NUM.TO STOP"
NewString "IT IS YOURS"
NewString "COSTS TOO MUCH"
NewString "YOUR SPELLS "
NewString "#"
NewString "DONE"

FailedString:
NewString "FAILED"

UseMagicStrings:
NewString "MAGIC"
NewString "YOU CANT TSE MAGIC YOUR NOT A M.U."
NewString "YOU CANT USE MAGIC WITH WEAPON IN HAND"
NewString "CLERICAL SPELL #"
NewString "YOU DONT HAVE THAT SPELL"
NewString "NO MORE"
NewString "THERE IS ONE AT "
NewString "LAT."
NewString "LONG."
NewString "SPELL #"
NewString "DO NOT HAVE THAT ONE"
NewString "M-HP="
NewString "INPUT CO-ORDINATES"
NewString "ARE YOU ABOVE,BELOW,RIGHT, OR LEFT OF IT"

MonsterKilledStrings:
NewString "GOOD WORK YOU JUST KILLED A "
NewString "AND GET "
NewString "GOLD PIECES"
NewString "YOU HAVE"
NewString " GOLD "

DeadString:
NewString "SORRY YOUR DEAD"

MonsterHitNoDamageString:
NewString "HE HIT YOU BUT NOT GOOD ENOUGH"

MonsterMissedString:
NewString "HE MISSED"

WatchItString:
NewString " WATCH IT"

HPCheckString:
NewString "H.P.=0 BUT CONST. HOLDS"

HPLowString:
NewString "WATCH IT H.P.="

CheckForMonstersStrings:
NewString "ALL MONSTERS DEAD"
NewString "RESET"

MonsterHitStrings:
NewString "MONSTER SCORES A HIT"
NewString "H.P.="

MonsterTrappedString:
NewString "GOOD WORK YOU LED HIM INTO A TRAP"

PassStrings:
NewString "SO YOU HAVE RETURNED"
NewString "WANT TO BUY MORE EQUIPMENT"

FightStrings:
NewString "YOUR WEAPON IS "
NewString "HP="

MoveMonsterString: 
NewString "MONSTER MOVED BACK"

DidntWorkString:
NewString "DIDN’T WORK"

FoodFightStrings:
NewString "FOOD ???.... WELL O.K."
NewString "IS IT TO HIT OR DISTRACT"
NewString "HIT" 
NewString "THROW A-ABOVE,B-BELOW,L-LEFT,OR R-RIGHT OF THE MONSTER"

MonsterTrappedKilledString:
NewString "GOOD WORK THE MONSTER FELL INTO A TRAP AND IS DEAD"

CheckHitStrings:
NewString "TOTAL MISS"
NewString "DIRECT HIT"
NewString "HIT"
NewString "YOU HIT HIM BUT NOT GOOD ENOUGH"

FistFightStrings:
NewString "DO YOU REALIZE YOU ARE BARE HANDED"
NewString "DO YOU WANT TO MAKE ANOTHER CHOICE"
NewString "O.K. PUNCH BITE SCRATCH HIT ........"
NewString "NO GOOD ONE"
NewString "TERRIBLE NO GOOD"
NewString "GOOD A HIT"

AttackWithSwordStrings:
NewString "SWING"
NewString "HE IS OUT OF RANGE"
NewString "CRITICAL HIT"
NewString "GOOD HIT"
NewString "NOT GOOD ENOUGH"
NewString "MISSED TOTALY"

AttackWith2HandSwordStrings:
NewString "SWHNG"
NewString "HE IS OUT OF RANGE"
NewString "CRITICAL HIT"
NewString "HIT"
NewString "HIT BUT ‘ WELL ENOUGH"
NewString "MISSED TOTALY"

DaggerFightStrings:
NewString "YOU DONT HAVE A DGGER"
NewString "HE IS OUT OF RANGE"
NewString "CRITICAL HIT"
NewString "HIT BUT NO DAMAGE"
NewString "HIT"
NewString "MISSED TOTALY"

AttackWithMaceStrings:
NewString "SWING"
NewString "HE IS OUT OF RANGE"
NewString "CRITICAL HIT"
NewString "HIT"
NewString "HIT BUT NO DAMAGE"
NewString "MISS"

NoWeaponString:
NewString "NO WEAPON FOUND"

AttackWithCrossStrings:
NewString "AS A CLUB OR SIGHT"
NewString "SIGHT" 
NewString "FAILED"
NewString "THE MONSTER IS HURT"

AttackWithOtherWeaponStrings:
NewString "CRITICAL HIT"
NewString "HIT"
NewString "HIT BUT NO DAMAGE"
NewString "MISS"

StringBuffer times 256 db 0 