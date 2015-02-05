PrintSuccess:
	PrintGreenString Success
ret

PrintFail:
	PrintRedString Fail
ret		

PrintTest:
	mov cx, 27
	.loop:
		mov bx, cx
		call print_dec
		call new_line
	dec cx
	jnz .loop
ret