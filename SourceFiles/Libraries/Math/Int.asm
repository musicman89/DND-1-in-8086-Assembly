;********************************************************************************
;   parse_int
;   Purpose:
;      To parse an integer from a string
;           Prototype:
;               int parse_int(byte address);
;           Algorithm:
;               int parse_int(byte address){
;                   int temp = 0
;                   word flags = 0;
;                   while(*address != 0){
;                       int parsedChar = parse_int_from_char(*address);
;                       if(parsedChar < 0){
;                           if(parsedChar == -2){
;                               flags xor 0xFFFF;
;                           }
;                           else{
;                              return 0;
;                           }
;                       }
;                       temp += parsedChar;
;                       temp *= 10;
;                       address++;
;                   }
;                   return flags != 0 ? (temp or flags) + 1: temp;
;               }
;               
;   Entry:
;       Byte address in register BX
;   Exit:
;       Int value in register BX
;   Uses:
;       AX, BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
parse_int:
    push dx
	push cx
	push ax
    mov word [IntBuffer], 0                 ;Clear our buffer
    mov word [IntFlags], 0                   ;Clear our flags
    .loop:
        mov al, [bx]                        ;Take the current character of the string into al
        mov ah, 0                           ;Ensure we have not hit the end of the string
        test al, al
        jz .return

        call parse_int_from_char            ;Parse the character
        test al, al                         ;If it isn't a number test if we have an invalid string
        jl .failCheck

        mov dx, [IntBuffer]                 ;Push the buffer into dx
        mov cl, 3                           ;Set cl to 3 to do our left shift (dx * 8)
        shl dx, cl                          
        shl word [IntBuffer], 1             ;Shift our buffer by one byte (buffer * 2)
        add [IntBuffer], dx                 ;Add dx to our buffer (buffer * 10)

        add [IntBuffer], ax                 ;Add the value of the character to the buffer

        inc bx                              ;advance to the next character
        jmp .loop
	.failCheck:
        cmp al, -2                          ;If the value is -2 that signals we have a negative number
        jne .fail
            xor word[IntFlags], 0xFFFF      ;Set our flags to negative
            inc bx                          ;Advance to the next character and return to the loop
        jmp .loop
    .fail:
		mov word [IntBuffer], 0             ;Set our value to 0 and return
    .return:
        mov bx, word[IntFlags]              ;Move our flags into bx 
        cmp bx, 0                           ;Check if the flags have been set 
        jge .positive
            xor word[IntBuffer], bx		    ;Flip the bytes to their opposite
            inc word[IntBuffer]             ;Increment the buffer to compensate for twos complement
        .positive:
        mov bx, [IntBuffer]                 ;Set bx to the value of our buffer
		
	pop ax
	pop cx
    pop dx
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
        cmp al, '-'             ;Check if the number is negative
        je .negative

        cmp al, '0'             ;If the character is less than 0 it is not a number
        jl .no
        
        cmp al, '9'             ;If the character is greater than 9 it also is not a number
        jg .no

        sub al, '0'             ;Offset the byte to get the value of the character
        jmp .return
        .negative:
            mov al, -2          ;Flag a negative number
            jmp .return
        .no:
            mov al, -1          ;Flag an invalid number
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
;                   return ticks % 65000
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
    mov  cx, 65000           ;set our base for the seed
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
    call get_random            ;Get a random number
	xor  dx, dx                ;Clear dx

    mov ax, bx                 ;Move our random number into ax
    div cx                     ;Divide by our base
    mov bx, dx                 ;Move the remainder (A number between 0 and our base) into bx
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
;                   seed = (seed * 31 + 13) % 19683
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
    xor  dx, dx          ;Clear dx
    mov ax, [RandSeed]   ;Set ax to our initial seed value
    mov bx, 31           ;Set bx to 31 and multiply our seed by it
    mul bx               
                         ;Our result is in dx:ax, higher value in dx, lower value in ax
    add ax, 13           ;Add 13 to our result
    mov bx, 19683        ;Set bx to 19683 and divide our result by it
    div bx               
                         ;Our result is in ax:dx, quotient in ax, remainder in dx 
    mov [RandSeed], dx   ;Set our seed value to the remainder of our result
    mov bx, dx           ;Set bx to the remainder of our result
	pop ax
	pop dx
ret

;********************************************************************************
;   get_root
;   Purpose:
;      To get the integer portion of a square root
;           Prototype:
;               int get_root(int number);
;           Algorithm:
;               int get_root(int number){
;                   int result = 0;                     //Initialize the result to 0
;                   int bit = 16384;                    //Initialize to the highest power of 4 in range
;
;                   while(bit > number){
;                       bit /= 4;                       //Find the lowest power of 4 below our number
;                   }
;
;                   while(bit != 0){
;                       if(number >= result + bit){     
;                           number -= result + bit;
;                           result = result / 2 + bit;
;                       }
;                       else{
;                           result /= 2;
;                       }
;                       bit /= 4;
;                   }
;                   return result;
;               }
;               
;   Entry:
;       Int number in register bx
;   Exit:
;       Int result in register BX
;   Uses:
;       AX, BX, CX, DX
;   Exceptions:
;       
;*******************************************************************************
get_root:
    push ax
    push cx
    push dx

    mov ax, 0                       ;Initialize our result

    mov dx, 16384                   ;Set our bit

    cmp dx, bx                      ;Check if our bit is greater than our number
    jle .loop

    mov cl, 2
    .highest4Power:
        shr dx, cl                  ;Move to the next lowest power of 4
        cmp dx, bx                  ;Check our bit again
        jg .highest4Power           ;If it is still greater repeat

    .loop:
        mov cx, ax                  ;We are going put our result in cx
        add cx, dx                  ;Add our bit to it
        cmp cx, bx                  ;Compare our bit to our number

        jg .right_shift             ;If it is less than or equal we continue
            sub bx, cx              ;We subtract our bit and result combination from our number
            shr ax, 1               ;We divide our result by 2
            add ax, dx              ;Now add our bit to the result
            jmp .check              ;Lets go check if we are done

        .right_shift:               ;If the combination was greater than our number
            shr ax, 1               ;We simply divide the result by 2
            
        .check:
            mov cl, 2               
            shr dx, cl              ;Lets move to the next lowest power of 4
            cmp dx, 0               ;Make sure we have not hit 0
            jne .loop               ;If we have not hit 0 go for another round

    mov bx, ax                      ;Now that we have finished lets move the result into bx

    pop dx
    pop cx
    pop ax
ret

abs_int:
    cmp ax, 0
    jge .return
        xor ax, 0xFFFF          ;Make our number positive
        inc ax                  ;Adjust for the twos compliment switch
    .return:
ret
RandSeed dw 0
IntBuffer dw 0
IntFlags dw 0