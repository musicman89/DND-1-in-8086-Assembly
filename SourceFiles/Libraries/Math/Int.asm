;********************************************************************************
;   parse_int
;   Purpose:
;      To parse an integer from a string
;           Prototype:
;               int parse_int(byte address);
;           Algorithm:
;               int parse_int(byte address){
;                   int temp = 0
;                   while(*address != 0){
;                       int parsedChar = parse_int_from_char(*address);
;                       if(parsedChar < 0){
;                           return 0;
;                       }
;                       temp += parsedChar;
;                       temp *= 10;
;                       address++;
;                   }
;                   return temp;
;               }
;               
;   Entry:
;       Byte address in register BX
;   Exit:
;       Int value in register BX
;   Uses:
;       AX, BX, CX
;   Exceptions:
;       
;*******************************************************************************
parse_int:
	push cx
	push ax
    mov word [IntBuffer], 0
    mov cx, 10
    .loop:
        mov al, [bx]
        mov ah, 0
        test al, al
        jz .return

        call parse_int_from_char
        test al, al
        jl .fail

        push ax
        mov ax, [IntBuffer]
        mul cx
        mov [IntBuffer], ax
        pop ax

        add word [IntBuffer], ax


        inc bx
        jmp .loop
		jmp .return
	.fail:
		mov word [IntBuffer],0
    .return:
		mov bx, [IntBuffer]
		
	pop ax
	pop cx
ret

;********************************************************************************
;   parse_int_from_char
;   Purpose:
;      To parse an integer from a character
;           Prototype:
;               int parse_int_from_char(byte char);
;           Algorithm:
;               int parse_int_from_char(byte char){
;                   if(char < '0' || char > '9'){
;                       return -1;
;                   }
;                   return char - '0';
;               }
;               
;   Entry:
;       Byte char in register AL
;   Exit:
;       Int value in register AL
;   Uses:
;       AL
;   Exceptions:
;       
;*******************************************************************************
parse_int_from_char:
        cmp al, '-'
        je .negative

        cmp al, '0'
        jl .no
        
        cmp al, '9'
        jg .no

        sub al, '0'
        jmp .return
        .negative:
        mov al, -0
        jmp .return
        .no:
            mov al, -1
        .return:
ret

;********************************************************************************
;   get_seed
;   Purpose:
;      To get a seed for random number generation
;           Prototype:
;               int get_seed();
;           Algorithm:
;               int get_seed(){
;                   int ticks = BIOS_INT_0x1A(0x00)
;                   return ticks % 0xABBA
;               }
;               
;   Entry:
;       None
;   Exit:
;       None
;   Uses:
;       AX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
get_seed:
    push dx
    push cx
    push ax
    mov ah, 00h              ;call the BIOS to get the system time        
    int 1ah                  ;CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx              ;move the number of ticks to ax
    xor  dx, dx              ;clear dx
    mov  cx, 0xABBA          ;set our base for the seed
    div cx                   ;divide the number of ticks by our base
    mov [RandSeed], dx       ;set the remainder which is any number between 0 and our base as the seed
    pop ax
    pop cx
    pop dx
ret

;********************************************************************************
;   random_int
;   Purpose:
;      To get a random integer between 0 and a given value
;           Prototype:
;               void random_int(int base);
;           Algorithm:
;               void random_int(int base){
;                   int rnd = get_random()
;                   seed = rnd % base
;               }
;               
;   Entry:
;       Int base in register CX
;   Exit:
;       Int in register BX
;   Uses:
;       AX, BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
random_int:
	push dx
	push cx
	push ax
    call get_random
	xor  dx, dx

    mov ax, bx
    div cx
    mov bx, dx
	pop ax
	pop cx
	pop dx
ret

;********************************************************************************
;   get_random
;   Purpose:
;      To get an unbounded random integer
;           Prototype:
;               int get_random();
;           Algorithm:
;               int get_random(){
;                   seed = (seed * 0x001F + 0x000D) % 0x4CE3
;                   return seed
;               }
;               
;   Entry:
;       None
;   Exit:
;       Int in register BX
;   Uses:
;       AX, BX, DX
;   Exceptions:
;       
;*******************************************************************************
get_random:
	push dx
	push ax
    xor  dx, dx
    mov ax, [RandSeed]   ; set new initial value z 
    mov bx, 0x001F       ; 31D 
    mul bx               ; 31 * z
                         ; result dx:ax, higher value in dx, lower value in ax
    add ax, 0x000D       ; +13
    mov bx, 0x4CE3       ; 19683D
    div bx              ; div by 19683D
                        ; result ax:dx, quotient in ax, remainder in dx 
    mov [RandSeed], dx
    mov bx, dx
	pop ax
	pop dx
ret

RandSeed dw 0
IntBuffer dw 0