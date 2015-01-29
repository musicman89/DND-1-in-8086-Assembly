flip_coin:
	push cx
	mov cx, 2
	call random_int
	pop cx
ret

roll_d4:
	push cx
	mov cx, 4
	call random_int
	inc bx
	pop cx
ret

roll_d7:
	push cx
	mov cx, 7
	call random_int
	inc bx
	pop cx
ret

roll_d6:
	push cx
	mov cx, 6
	call random_int
	inc bx
	pop cx
ret


roll_d8:
	push cx
	mov cx, 8
	call random_int
	inc bx
	pop cx
ret

roll_d12:
	push cx
	mov cx, 12
	call random_int
	inc bx
	pop cx
ret

roll_d20:
	push cx
	mov cx, 20
	call random_int
	inc bx
	pop cx
ret

roll_d100:
	push cx
	mov cx, 100
	call random_int
	inc bx
	pop cx
ret

