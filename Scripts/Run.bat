if "%1"=="Run" goto run

cd "../SourceFiles"

:build
nasm -f bin stage1.asm -o ../compiled/source/stage1.com
nasm -f bin stage2.asm -o ../compiled/source/stage2.com
nasm -f bin padding.asm -o ../compiled/source/padding.com
cd "../Compiled/Source"
copy /b "stage1.com" + "stage2.com"+ "padding.com" + "../bin/OS.bin"

:run
qemu-system-i386 -m 16 -hda ../bin/OS.bin

