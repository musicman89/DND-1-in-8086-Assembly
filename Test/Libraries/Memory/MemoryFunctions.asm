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
MemoryFunctionTests:
	call test_mem_copy
ret

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

test_mem_copy:
	WriteLine TestingMemoryCopyString
	mov ax, TestMemData
	mov bx, TestMemDestination
	mov cx, TestMemDestination - TestMemData
	call mem_copy

	mov cx, TestMemData
	mov dx, TestMemDestination
	call string_assert_equal
ret
align 16
TestingMemoryCopyString db "Testing Memory Copy:", 10, 13, 0
align 16
TestMemData db "This is a string used for testing memory copy data", 0
TestMemDestination times 64 db 0