SECTION .text
IntTests:
	WriteLine IntParseString
	call test_parse_int_bad_num_string
	call test_parse_int_good_num_string
	call test_parse_int_good_negative_num_string
	call test_parse_int_good_low_num_string
	call test_parse_int_good_high_num_string
	WriteLine GetRootTestString
	call test_get_root
ret

test_parse_int_bad_num_string:
	mov bx, TestBadNumString
	call parse_int
	mov cx, 0
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

int_assert_equal:
	mov dx, bx
	mov bx, dx
	
	call print_dec
	
	Write StringEqual
	
	mov bx, cx
	call print_dec
	
	Write Space
	
	mov bx, dx
	
	cmp dx, cx
	jne .fail
		call PrintSuccess
	ret
	.fail:
		call PrintFail
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
SECTION .data
	GetRootTestString 			NewString "Testing Get Root"
	IntParseString 				NewString "Testing Parse Int"
	TestGoodNumString 			NewString "1052"
	TestGoodNegativeNumString 	NewString "-1052"
	TestBadNumString 			NewString "1lw"
	TestGoodLowNumString 		NewString "1"
	TestGoodHighNumString 		NewString "32767"