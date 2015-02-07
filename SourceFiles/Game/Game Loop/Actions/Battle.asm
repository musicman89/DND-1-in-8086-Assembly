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

ret

monster_killed:

ret

survive_with_constitution:

ret

dead:

ret

hp_check:

ret

hp_low:

ret

random_encounter:

ret

check_for_random_encounter:

ret

reset_monsters:

ret

check_for_monsters:

ret

monster_hit:

ret

monster_hit_no_damage:

ret

monster_miss:

ret

monster_trapped:

ret