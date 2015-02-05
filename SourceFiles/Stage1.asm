[BITS 16]
[ORG 0x7c00]
[CPU 8086]
%include "../SourceFiles/Libraries/Graphics/Macros.asm"
main:
	mov [BOOT_DRIVE], dl
	xor ax, ax	;clear ax
	mov ds, ax	;clear ds
	mov ss, ax	;start the stack at 0
	mov bp, 0x8000	;move the stack pointer to 0x2000 past the start
	mov sp, bp

	mov bx, 0x9000
	mov dh, 99
	mov dl, [BOOT_DRIVE]
	call disk_load

	call clear_screen

	mov bx, SectorsLoaded
	call print_string

	jmp 0x9000

	cli			;Disable Interrupts
	hlt			;Halt the Processor
	
%include "Libraries/Graphics/Print.asm"
%include "Libraries/IO/DiskIO.asm"

BOOT_DRIVE db 0
BootString db 'Booting', 13, 10, 0
LoadingSectors db 'Loading Sectors from Memory', 13, 10, 0
SectorsLoaded db 'Sector Load Complete', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55