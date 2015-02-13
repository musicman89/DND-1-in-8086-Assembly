pass:
; 07000 IF K1=-1 THEN 08290  //Monster Dead
; 07010 IF C(0)<2 THEN 08160  //HP Check
; 07020 IF K>0 THEN 07160  //Monster Battle
; 07030 IF G<>1 THEN 07110	//Check for Random Encounter
; 07040 IF H<>12 THEN 07110	//Check for Random Encounter

; 07050 PRINT "SO YOU HAVE RETURNED"
; 07060 IF C(7)<100 THEN 07110 //Check for Random Encounter
; 07070 LET C(7)=C(7)-100	//Take 100 gold
; 07080 PRINT "WANT TO BUY MORE EQUIPMENT"
; 07090 INPUT Q$
; 07100 IF Q$="YES" THEN 07130	//Goto the shop

; 07110 IF RND(0)*20>10 THEN 07830
; 07120 GO TO 01590	//Get a Command from the User
ret