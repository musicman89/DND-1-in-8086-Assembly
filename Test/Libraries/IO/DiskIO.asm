;********************************************************************************
;	disk_save
;	Purpose:
;      To save sectors to a disk
;			Prototype:
;				void disk_save(byte address, byte sectors, byte drive);
;			Algorithm:
;				void disk_save(byte address, byte sectors, byte drive)
;					try{
;						int sectors_saved = BIOS_INT_0X13(0x03, address, drive, sectors, 0, 0, 0);
;						if(sectors_saved != sectors){
;							Disk_Error()
;						}
;					}
;					catch
;					{
;						Disk_Error();
;					}
;				}
;				
;	Entry:
;       Byte address in register ES:BX, Byte sectors in register DH, Byte drive in register DL
;	Exit:
;       None
;	Uses:
;		BX, DX
;	Exceptions:
;		Disk Read Error
;*******************************************************************************
test_disk_save:
	mov bx, 0x9000
	mov es, bx
	mov ax, test_new_memory
	mov bx, test_memory_area
	mov cx, 64
	call mem_copy
	PrintString DoneString

	mov bx, test_memory_area
	mov dh, 1
	mov dl, [boot_drive]
	call disk_save
ret
align 16
times 256 db 0xAB
test_new_memory  db "This is a string used for testing memory copy data", 0
align 16
times 256 db 0xCD
test_memory_area times 256 db 0xAB