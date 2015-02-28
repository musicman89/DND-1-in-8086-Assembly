;*******************************************************************************
;	StringFunctions.asm - x86 Assembly String Functions
;						
;
;       Copyright (c) Davan Etelamaki
;
;	Purpose:
;       To provide the functions needed for string comparison and manipulation
;
;*******************************************************************************
section .text
;********************************************************************************
;	substr
;	Purpose:
;      To get a substring
;			Prototype:
;				word substr(byte string_address, int length);
;			Algorithm: 
;				word substr(byte* string_address, int length){
;					byte* buffer_address = StringBuffer;
;					while(length > 0 && *string_address !=0){
;						*buffer_address = *string_address;
;						length--;
;						string_address++;
;						buffer_address++
;					}
;					return StringBuffer;
;				}
;
;	Entry:
;       string_address in register BX, length in register CX
;	Exit:
;       The address of the sub-string in register BX
;	Uses:
;		AX, BX, CX, SI
;	Exceptions:
;		None
;*******************************************************************************
StringFunctionTests:
	WriteLine StringFunctionTestsString
	call test_string_compare
	call test_to_upper
	call test_to_lower


	call test_substr
	call test_string_copy
	call test_get_string_array
ret

test_substr:

ret

;********************************************************************************
;	string_compare
;	Purpose:
;      To compare two strings
;			Prototype:
;				word string_compare(byte string_addressA, byte string_addressB);
;			Algorithm: 
;				word string_compare(byte string_addressA, byte string_addressB){
;					while(true){
;						key = get_key();
;						if(*string_addressA > *string_addressB){
;							return 1;
;						}
;						else if(*string_addressA < *string_addressB){
;							return -1;
;						}
;						if(*string_addressA == 0){
;							return 0;
;						}
;						string_addressA++;
;						string_addressB++
;					}
;				}
;
;	Entry:
;       string_addressA in register CX, string_addressB in register DX
;	Exit:
;       AX == 0 if stringA == stringB, AX == -1 if stringA < stringB, AX == 1 if stringA > stringB
;	Uses:
;		AX, BX, CX, DX
;	Exceptions:
;		None
;*******************************************************************************
test_string_compare:
	WriteLine TestingStringCompareString
	call test_string_compare_greater
	call test_string_compare_less
	call test_string_compare_equal
	call test_string_compare_insensitive
ret

test_string_compare_greater:
	mov cx, UpperWord
	mov dx, LowerWord
	call string_assert_greater
ret

test_string_compare_less:
	mov cx, LowerWord
	mov dx, UpperWord
	call string_assert_less
ret

test_string_compare_equal:
	mov cx, MixedWord
	mov dx, MixedWord
	call string_assert_equal
ret

test_string_compare_insensitive:
	mov cx, LowerWord
	mov dx, MixedWord
	call string_assert_insensitive_equal
ret
;********************************************************************************
;	to_lower
;	Purpose:
;      Make a string lower case
;			Prototype:
;				word to_lower(byte string_address);
;			Algorithm: 
;				word to_lower(byte string_address){
;					byte buffer = string_address;
;					while(true){
;						if(*buffer == 0){
;							return string_address;
;						}
;						char_to_lower(*buffer);
;						buffer++
;					}
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
test_to_lower:
	WriteLine TestingToLowerString
	call test_to_lower_lower
	call test_to_lower_upper
	call test_to_lower_mixed
ret
test_to_lower_lower:
	mov cx, LowerWord
	call test_to_lower_sub
ret
test_to_lower_upper:
	mov cx, UpperWord
	call test_to_lower_sub
ret
test_to_lower_mixed:
	mov cx, MixedWord
	call test_to_lower_sub
ret
test_to_lower_sub:
	mov dx, StringBuffer
	call string_copy
	mov bx, StringBuffer
	call to_lower
	mov cx, StringBuffer
	mov dx, LowerWord
	call string_assert_equal
ret

;********************************************************************************
;	to_upper
;	Purpose:
;      Make a string upper case
;			Prototype:
;				word to_upper(byte string_address);
;			Algorithm: 
;				word to_upper(byte string_address){
;					byte buffer = string_address;
;					while(true){
;						if(*buffer == 0){
;							return string_address;
;						}
;						char_to_upper(*buffer);
;						buffer++
;					}
;				}
;
;	Entry:
;       string_address in register BX
;	Exit:
;       string_address in register BX
;	Uses:
;		AX, BX
;	Exceptions:
;		None
;*******************************************************************************
test_to_upper:
	WriteLine TestingToUpperString
	call test_to_upper_lower
	call test_to_upper_upper
	call test_to_upper_mixed
ret
test_to_upper_lower:
	mov cx, LowerWord
	call test_to_upper_sub
ret
test_to_upper_upper:
	mov cx, UpperWord
	call test_to_upper_sub
ret
test_to_upper_mixed:
	mov cx, MixedWord
	call test_to_upper_sub
ret

test_to_upper_sub:
	mov dx, StringBuffer
	call string_copy
	mov bx, StringBuffer
	call to_upper
	mov cx, StringBuffer
	mov dx, UpperWord
	call string_assert_equal
ret

test_string_copy:
	WriteLine TestingStringCopyString
	mov cx, UpperWord
	mov dx, StringBuffer
	call string_copy
	call string_assert_equal
ret

string_assert_equal:
	call string_compare
	Write cx
	Write StringEqual
	Write dx
	Write Space
	cmp ax, 0
	jne .fail
		call PrintSuccess
	ret
	.fail:
		call PrintFail
ret

string_assert_insensitive_equal:
	call string_compare_insensitive
	Write cx
	Write StringEqual
	Write dx
	Write Space
	cmp ax, 0
	jne .fail
		call PrintSuccess
	ret
	.fail:
		call PrintFail
ret

string_assert_greater:
	call string_compare
	Write cx
	Write StringGreater
	Write dx
	Write Space
	cmp ax, 0
	jle .fail
		call PrintSuccess
	ret
	.fail:
		call PrintFail
ret

string_assert_less:
	call string_compare
	Write cx
	Write StringLess
	Write dx
	Write Space
	cmp ax, 0
	jge .fail
		call PrintSuccess
	ret
	.fail:
		call PrintFail
ret

test_get_string_array:

ret

section .data
	StringFunctionTestsString 	NewString "Testing Sring Functions"
	StringGreater 				NewString " > "
	StringLess 					NewString " < "
	StringEqual 				NewString " = "
	TestingStringCopyString 	NewString "Testing String Copy:"
	TestingToUpperString 		NewString "Testing To Upper:"
	TestingToLowerString 		NewString "Testing To Lower:"
	TestingStringCompareString 	NewString "Testing String Compare:"
	TestingSubstringString 		NewString "Testing Substring:"
	UpperWord 					NewString "THIS IS A TEST WORD!"
	LowerWord 					NewString "this is a test word!"
	MixedWord 					NewString "This Is A Test Word!"
	SubStringTestWord 			NewString "IsATest"