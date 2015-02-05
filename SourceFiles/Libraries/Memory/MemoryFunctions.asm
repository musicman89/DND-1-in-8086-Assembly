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
;      To copy a string from one address to another
;			Prototype:
;				void mem_copy(byte addressA, byte addressB, byte length);
;			Algorithm: 
;				void mem_copy(byte addressA, byte addressB, byte length){
;					while(length != 0){
;						*[string_addressB + length] = *[string_addressA + length];
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

    .loop:

        cmp cx, 1
        je .single
        sub cx, 2 					;advance to the next characters
        
		mov di, cx
		add di, ax
        mov dx, [di]				;load the current byte of the string

        mov di, cx
        add di, bx
        mov [di], dx
        

        jnz .loop
        jmp .return
        .single:
        	dec cx
			mov di, cx
			add di, ax
	        mov dl, [di]				;load the current byte of the string

	        mov di, cx
	        add di, bx
	        mov [di], dl
        .return:
	pop dx
	pop cx
	pop bx
	pop ax
ret

extended_mem_copy:
	push ax
	push bx
	push cx
	push dx
	mov di, 0
    cmp di, cx
    je .return

    .loop:
		mov es, ax
        mov dx, [es:di]				;load the current byte of the string

        mov es, bx
        mov [es:di], dx
        
        add di, 2 					;advance to the next characters
        cmp di, cx
        jg .single
        jl .loop
        jmp .return
        .single:
        	dec di
			mov es, ax
	        mov dl, [es:di]				;load the current byte of the string

	        mov es, bx
	        mov [es:di], dl
        .return:
	pop dx
	pop cx
	pop bx
	pop ax
ret