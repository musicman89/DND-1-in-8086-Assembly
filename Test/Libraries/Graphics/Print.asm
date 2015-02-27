SECTION .text
PrintSuccess:
	PrintGreenString Success
ret

PrintFail:
	PrintRedString Fail
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

SECTION .data
	PrintTestString		NewString "Testing Print"
	PrintTestComplete	NewString "Print Test Complete"
	PrintTestRowString	NewString "row: "