nasm -f elf32 -o asm.o $1
ld -m elf_i386 -o asm asm.o
objdump -M intel -d asm
objdump -d asm |grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'