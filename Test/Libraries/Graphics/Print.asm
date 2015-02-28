section .text
PrintSuccess:
	PrintGreenString Success
	call new_line
ret

PrintFail:
	PrintRedString Fail
	call new_line
ret		

PrintTest:
	WriteLine PrintTestString
	mov cx, 27
	.loop:
		Write PrintTestRowString
		mov bx, cx
		call print_dec
		call new_line
	dec cx
	jnz .loop
	mov bx, [ypos]
	mov cx, 23
	call int_assert_equal
	WriteLine PrintTestComplete
ret

section .data
PrintTestString		NewString "Testing Print"
PrintTestComplete	NewString "Print Test Complete"
PrintTestRowString	NewString "row: "