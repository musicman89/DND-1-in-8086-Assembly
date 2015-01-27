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

parse_int_from_char:
        cmp al, '0'
        jl .no
        
        cmp al, '9'
        jg .no

        sub al, '0'
        jmp .return
        .no:
            mov al, -1
        .return:
ret
get_seed:
	push dx
	push cx
	push ax
   mov ah, 00h  ; interrupts to get system time        
   INT 1ah      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 0xABBA
   div cx   
   mov [RandSeed], dx
   pop ax
   pop cx
   pop dx
ret

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