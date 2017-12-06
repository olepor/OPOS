C_SOURCES = ${wildcard kernel/*.c drivers/*.c}
OBJDIR = build/obj/
HEADERS = ${wildcard kernel/*.h drivers/*.h}
OBJ = ${wildcard build/obj/*.o}
BINS = ${wildcard build/bin/*.bin}


all: os_img

run: all
	qemu-system-x86_64 -fda os_img -boot a &

build/obj/kernel_entry.o: boot/kernel_entry.asm
	nasm -f elf -o $@ $<

build/bin/boot_sect.bin: boot/boot_sect.asm
	pwd
	nasm -f bin -o $@ $<

# kernel.o: kernel.c
# 	gcc -ffreestanding -m32 -c $< -o $@

${OBJDIR}%.o : C_SOURCES ${HEADERS}
	gcc -ffreestanding -m32 -c $< -o $@ # compile a 32-bit obj-file from the c-sources

build/bin/kernel.bin: build/obj/kernel_entry.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386

os_img: build/bin/boot_sect.bin build/bin/kernel.bin
	cat $^ > $@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

debug: os_img boot_entry.asm
	#Boot the image on x86, ready for debug (-s) and stop cpu (-S)
	qemu-system-x86_64 -fda $< -boot a -s -S &
	sleep 1 # Otherwise the connection is not opened yet
	gdb

clean:
	rm *.o *.dis os_img *.bin

.PHONY: debug run clean all
