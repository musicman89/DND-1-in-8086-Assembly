NASM=nasm -f bin -i "SourceFiles/"

all:	build

build: stage1.com stage2.com
	cat "Compiled/Source/stage1.com" "Compiled/Source/stage2.com" > "Compiled/Bin/OS.bin"

stage1.com:
	$(NASM) "SourceFiles/Stage1.asm" -o "Compiled/Source/stage1.com"

stage2.com:
	$(NASM) "SourceFiles/Stage2.asm" -o "Compiled/Source/stage2.com"
