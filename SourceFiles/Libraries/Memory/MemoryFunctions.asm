;*******************************************************************************
;	MemoryFunctions.asm - x86 Assembly String Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for memory comparison and manipulation
;
;*******************************************************************************

;********************************************************************************
;	mem_copy
;	Purpose:
;      To copy data from one address to another
;			Prototype:
;				void mem_copy(word addressA, word addressB, word length);
;			Algorithm: 
;				void mem_copy(word addressA, word addressB, word length){
;					while(length != 0){
;						*[string_addressB + length] = *[string_addressA + length];
;						length--;
;					}
;				}
;
;	Entry:
;       addressA in register AX, addressB in BX, length in register CX
;	Exit:
;       addressA in register AX, addressB in BX, length in register CX
;	Uses:
;		AX, BX, CX, DX, DI
;	Exceptions:
;		None
;*******************************************************************************

mem_copy:
	push ax
	push bx
	push cx
	push dx

	mov di, 0 						;Set our starting offset to 0
    cmp cx, 1 						;Test for the case of only 1 byte to move
    je .single		

    cmp di, cx 						;Ensure our length is greater than 0
    je .return
	
	mov dx, bx
    .loop:
		mov bx, ax 					;Set our address segment to address a
		add bx, di
        push word [bx]				;load the current word of data into dx
        
        mov bx, dx 					;Set our address segment to address b
        add bx, di
        pop word [bx]				;Push the word from dx to address b with offset di
        
        add di, 2 					;advance to the next word
        cmp di, cx 					;Check if we are at the end

        jl .loop					;If we are less than the end there is at least one more 
        je .return 					;If they are equal we have hit the end
       	dec di						;Otherwise we passed the end so there must have only been one byte remaining

        .single:
			mov bx, ax 				;Set our address segment to address a
			add bx, di
	        mov cl, [bx]			;load the current byte of data into dl

	        mov bx, dx 				;Set our address segment to address b
	        add bx, di
	        mov [bx], cl	 		;Push the bye from dl to address b with offset di
        .return:
	pop dx
	pop cx
	pop bx
	pop ax
ret

;********************************************************************************
;	extended_mem_copy
;	Purpose:
;      To copy data from one address to another with the addresses offset by 16 bits
;			Prototype:
;				void extended_mem_copy(word addressA, word addressB, word length);
;			Algorithm: 
;				void extended_mem_copy(word addressA, word addressB, word length){
;					while(length != 0){
;						*[string_addressB:length] = *[string_addressA:length];
;						length--;
;					}
;				}
;
;	Entry:
;       addressA in register AX, addressB in BX, length in register CX
;	Exit:
;       addressA in register AX, addressB in BX, length in register CX
;	Uses:
;		AX, BX, CX, DX, DI
;	Exceptions:
;		None
;*******************************************************************************
extended_mem_copy:
	push ax
	push bx
	push cx
	push dx
	push es
	mov di, 0 						;Set our starting offset to 0
    cmp cx, 1 						;Test for the case of only 1 byte to move
    je .single		

    cmp di, cx 						;Ensure our length is greater than 0
    je .return
			
    .loop:
		mov es, ax 					;Set our address segment to address a
        mov dx, [es:di]				;load the current word of data into dx
        
        mov es, bx 					;Set our address segment to address b
        mov [es:di], dx 			;Push the word from dx to address b with offset di
        
        add di, 2 					;advance to the next word
        cmp di, cx 					;Check if we are at the end

        jl .loop					;If we are less than the end there is at least one more 
        je .return 					;If they are equal we have hit the end
       	dec di						;Otherwise we passed the end so there must have only been one byte remaining

        .single:
			mov es, ax 				;Set our address segment to address a
	        mov dl, [es:di]			;load the current byte of data into dl

	        mov es, bx 				;Set our address segment to address b
	        mov [es:di], dl 		;Push the bye from dl to address b with offset di
        .return:
    pop es
	pop dx
	pop cx
	pop bx
	pop ax
ret