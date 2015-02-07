IntTests:
	PrintString IntParseString
	call test_parse_int_bad_num_string
	call test_parse_int_good_num_string
	call test_parse_int_good_negative_num_string
	call test_parse_int_good_low_num_string
	call test_parse_int_good_high_num_string
	PrintString GetRootTestString
	call test_get_root
ret

test_get_root:
	mov bx, 25
	call get_root
	mov cx, 5
	call int_assert_equal

	mov bx, 81
	call get_root
	mov cx, 9
	call int_assert_equal

	mov bx, 31012
	call get_root
	mov cx, 176
	call int_assert_equal

	mov bx, 712
	call get_root
	mov cx, 26
	call int_assert_equal
ret

test_parse_int_good_num_string:
	mov bx, TestGoodNumString
	call parse_int
	mov cx, 1052
	call int_assert_equal
ret

test_parse_int_good_negative_num_string:
	mov bx, TestGoodNegativeNumString
	call parse_int
	mov cx, -1052
	call int_assert_equal
ret

test_parse_int_good_low_num_string:
	mov bx, TestGoodLowNumString
	call parse_int
	mov cx, 1
	call int_assert_equal
ret

test_parse_int_good_high_num_string:
	mov bx, TestGoodHighNumString
	call parse_int
	mov cx, 32767
	call int_assert_equal
ret

test_parse_int_bad_num_string:
	mov bx, TestBadNumString
	call parse_int
	mov cx, 0
	call int_assert_equal
ret

int_assert_equal:

	mov dx, bx
	mov bx, dx
	
	call print_dec
	
	PrintString StringEqual
	
	mov bx, cx
	call print_dec
	
	PrintString Space
	
	mov bx, dx
	
	cmp dx, cx
	jne .fail
		call PrintSuccess
	ret
	.fail:
		call PrintFail
ret
GetRootTestString db "Testing Get Root", 13,10,0
IntParseString db "Testing Parse Int", 13,10,0
TestGoodNumString db "1052", 0
TestGoodNegativeNumString db "-1052", 0
TestBadNumString db "1lw", 0
TestGoodLowNumString db "1", 0
TestGoodHighNumString db "32767", 0