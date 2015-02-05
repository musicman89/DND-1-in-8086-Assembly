
RunTests:
	call clear_screen
	call MemoryFunctionTests
	call wait_key
	call clear_screen

	call PrintTest
	call wait_key
	call clear_screen

	call IntTests
	call wait_key
	call clear_screen


	call StringFunctionTests
	call wait_key



ret
	
Success db "Success",13,10,0
Fail db "Fail",13,10,0
%include "../Test/Libraries/Math/Int.asm"
%include "../Test/Libraries/Strings/StringFunctions.asm"
%include "../Test/Libraries/Memory/MemoryFunctions.asm"
%include "../Test/Libraries/Graphics/Print.asm"
%include "../Test/Libraries/IO/KeyboardIO.asm"