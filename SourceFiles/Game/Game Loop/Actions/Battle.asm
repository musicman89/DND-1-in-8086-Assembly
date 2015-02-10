;********************************************************************************
;   range_and_hit_check
;   Purpose:
;      To check if the player is in range to attack the monster
;           Prototype:
;               void range_and_hit_check();
;           Algorithm:
;               void range_and_hit_check(){
;					if(CurrentMonster.type != 0){
;						CurrentMonster.distance_x = ABS(CurrentMonster.x - Character.x);
;						CurrentMonster.distance_y = ABS(CurrentMonster.y - Character.y);
;						CurrentMonster.range = get_root(CurrentMonster.distance_x^2 + CurrentMonster.distance_y^2);
;					}
;					else{
;						CurrentMonster.range = 1000;
;					}
;					int chance = roll_d20();
;					if(chance > 18){
;						CurrentMonster.hit = 3; //Critical hit
;					}
;					else if(chance > Monsters[CurrentMonster.type].dex - Character.dex/3){
;						CurrentMonster.hit = 2; //Hit
;					}
;					else if(chance > 17){
;						CurrentMonster.hit = 1; //Barely Missed
;					}
;					else{
;						CurrentMonster.hit = 0; //Completely Missed
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
range_and_hit_check:
	cmp byte [CurrentMonster.type], 0
	je .no_monster

	jmp .no_monster

	mov cl, [CurrentMonster.y]
	mov dl, [CurrentMonster.x]

	.monster:
	cmp dl, [Character.x]
	jl .lessX
		sub dl, [Character.x]
		mov [CurrentMonster.distance_x], dl
		jmp .getY

	.lessX:
		mov al, [Character.x]
		sub al, dl
		mov [CurrentMonster.distance_x], al

	.getY:
	cmp cl, [Character.y]
	jl .lessX
		sub cl, [Character.y]
		mov [CurrentMonster.distance_y], cl
		jmp .getRange

	.lessY:
		mov al, [Character.y]
		sub al, cl
		mov [CurrentMonster.distance_y], al

	.getRange:
		mov ah, 0
		mov al, [CurrentMonster.distance_y]
		mov dx, ax
		mul dx
		mov dx, ax

		mov ah, 0
		mov al, [CurrentMonster.distance_x]
		mov cx, ax
		mul cx
		mov cx, ax

		mov bx, dx
		add bx, cx
		call get_root
		mov [CurrentMonster.range], bx
		jmp .hit_check

	.no_monster:
	mov bx, 1000
	mov [CurrentMonster.range], bx

	.hit_check:
		call roll_d20
		cmp bx, 18
		jl .no_crit
			mov byte [CurrentMonster.hit], 3
			jmp .return

		.no_crit:
			push bx 									;We need to get the current monsters attributes
			mov ax, [CurrentMonster.type] 				;Lets load the monster type into ax
			mov bx, monster_size 						;The size of a monster object goest into bx
			mul bx 										;We will get the offset of where our monster is 
			mov bx, ax 									;Lets move that offset into bx for addressing
			mov bx, [Monsters + bx + monster.dex]  		;Now we can get the dextarity of the monster

			mov ax, [Character.dex] 					;In ax we will load our character's dextarity
			mov dx, 3 									;Put 3 in dx 
			div dx 										;Divide our dextarity by 3
			sub bx, ax 									;Now subtract this from the monster's dextarity
			mov dx, bx 									;Move the final value into dx
			pop bx
		cmp bx, dx 										;Check if our chance roll was greater than the value we just calculated
		jl .no_hit
			mov byte [CurrentMonster.hit], 2
			jmp .return

		.no_hit:
		cmp bx, 17
		jl .complete_miss
			mov byte [CurrentMonster.hit], 1
			jmp .return

		.complete_miss:
			mov byte [CurrentMonster.hit], 0
	.return:
ret

monster_attack:
	push bx 													;We need to get the current monsters attributes
	mov ax, [CurrentMonster.type] 								;Lets load the monster type into ax
	mov bx, monster_size 										;The size of a monster object goest into bx
	mul bx 														;We will get the offset of where our monster is 
	mov bx, ax 													;Lets move that offset into bx for addressing
	add bx, [Monsters + bx + monster.name]
	PrintString bx
	PrintString WatchItString

	mov ax, 10
	call check_inventory
	cmp ax, 0
	jge .tlte

	mov ax, 9
	call check_inventory
	cmp ax, 0
	jge .chain

	mov ax, 8
	call check_inventory
	cmp ax, 0
	jge .leather

		mov dx, Character.dex
		add dx, 6
		jmp .hit
	.tlte:
		mov dx, Character.dex
		add dx, 20
		jmp .hit
	.chain:
		mov dx, Character.dex
		add dx, 16
		jmp .hit
	.leather:
		mov dx, Character.dex
		add dx, 12

	.hit:
		mov cx, 40
		call random_int
		cmp bx, dx
		jl .no_hit
			call monster_hit
			jmp .return
		.no_hit:
		mov cx, 2
		call random_int
		cmp bx, 1
		jg .miss
			call monster_hit_no_damage
			jmp .return
		.miss:
			call monster_miss
		.return:
ret

monster_killed:
	mov byte [CurrentMonster.status], 0
	push bx 													;We need to get the current monsters attributes
	mov ax, [CurrentMonster.type] 								;Lets load the monster type into ax
	mov bx, monster_size 										;The size of a monster object goest into bx
	mul bx 														;We will get the offset of where our monster is 
	mov bx, ax 													;Lets move that offset into bx for addressing
	add bx, Monsters	
	push bx						
	mov dx, [bx + monster.gold]
	mov [Character.gold], dx
	PrintString MonsterKilledStrings + 0 * string_size
	PrintString bx + monster.name
	mov bx, dx
	PrintString MonsterKilledStrings + 1 * string_size
	call print_dec
	PrintString MonsterKilledStrings + 2 * string_size
	mov bx, [CurrentMonster.y]
	mov bx, [rows + bx]
	add bx, [CurrentMonster.x]
	mov byte[CurrentDungeon + bx], 0
	mov byte[CurrentMonster.x], 0
	mov byte[CurrentMonster.y], 0
	mov bx, [Character.gold]
	PrintString MonsterKilledStrings + 3 * string_size
	call print_dec
	PrintString MonsterKilledStrings + 4 * string_size
	pop bx
	cmp byte [Character.continues],1
	je .continue
		mov byte [bx + monster.initGold], 0
	.continue:
		mov byte [bx + monster.gold], 0
	cmp byte [Character.continues], 1
	jg .no_revive
	mov cx, [bx + monster.str]
	mov ax, [bx + monster.initHP]
	mul cx
	mov [bx + monster.hp], ax

	mov cx, [bx + monster.str]
	mov ax, [bx + monster.initGold]
	mul cx
	mov [bx + monster.gold], cx
	.no_revive:
	mov byte [CurrentMonster.type], 0

	call pass
ret

survive_with_constitution:
	cmp word [Character.con], 9
	jge .live
		call dead
		jmp .return
	.live:
		sub word [Character.con], 2
		inc word [Character.hp]
		call hp_check
	.return:
ret

dead:
	PrintString DeadString
	cli
	hlt
ret

hp_check:
	cmp [Character.hp], 0 
	jg .might_live
		call survive_with_constitution
	.might_live:
	cmp [Character.con], 9
	jg .live
		call dead
	.live:
	PrintString HPCheckString
ret

hp_low:
08160 IF C(O)<1 THEN 08190
08170 PRINT "WATCH IT H.P.=";C(0)
08180 GO TO 07020

ret

random_encounter:
08120 LET D(G+M,H+N)=5	
08130 LET F1=G+M
08140 LET F2=H+N
08150 GO TO 07000

ret

check_for_random_encounter:
08000 LET K=M
08010 M1=INT(RND(0)*7+1)
08015 FOR M=-M1 TO M1
	08020 FOR N=-M1 TO M1
		08025 IF ABS(M)<=2 OR ABS(N)<=2 THEN 08080
		08065 IF RND(0)>.7 THEN 08080
		08070 IF D(G+M,H+N)=0 THEN 08110 //Random Encounter
	08080 NEXT N
08090 NEXT M
08100 GO TO 08010

ret

reset_monsters:
07930 REM
07931 LET J4=J4+1 //Increment the Difficulty
07932 FOR M=1 TO 10
07950 LET B(M,3)=B(M,4)*J4 //Reset the Monster Health
07960 LET B(M,6)=B(M,5)*J4 //Reset the Monster Gold
07970 NEXT M
07980 LET C(0)=C(0)+5 //Add 5 HP
07990 GO TO 01590 //Get a User Command

ret

check_for_monsters:
07830 FOR Z7=1 TO 50
	07840 FOR M=1 TO 10
		07850 IF B(M,5)>=1 AND RND(0)>.925 THEN 08000	//Check Monster Status and if Random Encounter
	07860 NEXT M
07870 NEXT Z7
07880 PRINT "ALL MONSTERS DEAD"
07890 PRINT "RESET";
07900 INPUT Q$
07910 IF Q$="YES" THEN 07930
07920 STOP

ret

monster_hit:
07790 PRINT "MONSTER SCORES A HIT"
07800 LET C(0)=C(0)-INT(RND(0)*B(K,2)+1)
07810 PRINT "H.P.=";C(0)
07820 GO TO 07000

ret

monster_hit_no_damage:
	PrintString MonsterHitNoDamageString
ret

monster_miss:
	PrintString MonsterMissedString
ret

monster_trapped:
07530 PRINT "GOOD WORK YOU LED HIM INTO A TRAP"
07540 LET K1=-1
07550 LET B(K,6)=0
07560 GO TO 07000

07570 LET R8=-.5*R8
07580 LET R9=-.5*R9
07590 GO TO 07420

ret

monster_battle:
	call range_and_hit_check

07170 IF B(K,3)<1 THEN 08290  //Monster Dead
07180 IF R1<2.0 THEN 07600  //Monster Attack
07190 IF P0>10 THEN 01590  //Get Player command

07200 REM HE IS COMMING
07210 IF ABS(R8)>ABS(R9) THEN 07260
07220 LET F5=0
07230 IF M=1 THEN 07270
07240 LET F6=-(R9/ABS(R9))
07250 GO TO 07280

07260 LET F5=-(R8/ABS(R8))
07270 LET F6=0
07280 FOR Q=0 TO 8
07290 IF Q=1 OR Q=5 THEN 07320
07300 IF F1+F5<0 OR F1+F5>25 OR F2+F6<0 OR F2+F6>25 THEN 07320
07310 IF D(F1+F5,F2+F6)=Q THEN 07340
07320 NEXT Q
07330 GO TO 07510

07340 IF Q=0 THEN 07430
07345 IF Q=6 OR Q=7 OR Q=8 THEN 07430
07350 IF Q=2 THEN 07530
07360 IF Q=3 OR Q=4 THEN 07380
07370 GO TO 07510

07380 REM "THROUGH THE DOOR"
07390 IF D(F1+2*F5,F2+2*F6)<>0 THEN 07510
07400 LET F5=F5*2
07410 LET F6=F6*2
07420 GO TO 07440


07430 REM "CLOSER"
07440 LET D(F1,F2)=0
07450 LET F1=F1+F5
07460 LET F2=F2+F6
07470 LET D(F1,F2)=5
07480 GOSUB 08410
07490 REM
07500 GO TO 01590

07510 REM "NOWHERE"
07520 GO TO 07490
ret