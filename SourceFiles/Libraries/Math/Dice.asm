FlipCoin:
	push cx
	mov cx, 2
	call random_int
	pop cx
ret

RollD4:
	push cx
	mov cx, 4
	call random_int
	inc bx
	pop cx
ret

RollD7:
	push cx
	mov cx, 7
	call random_int
	inc bx
	pop cx
ret

RollD6:
	push cx
	mov cx, 6
	call random_int
	inc bx
	pop cx
ret


RollD8:
	push cx
	mov cx, 8
	call random_int
	inc bx
	pop cx
ret

RollD12:
	push cx
	mov cx, 12
	call random_int
	inc bx
	pop cx

RollD25:
	push cx
	mov cx, 25
	call random_int
	inc bx
	pop cx
ret

RollD20:
	push cx
	mov cx, 20
	call random_int
	inc bx
	pop cx
ret

RollD100:
	push cx
	mov cx, 100
	call random_int
	inc bx
	pop cx
ret

