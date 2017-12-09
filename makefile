include makefile.inc

.PHONY: all
all: os_img
>	echo $<

.PHONY: run
run: all
>	qemu-system-x86_64 -fda os_img -boot a &

# kernel_entry.o: boot/kernel_entry.asm
# 	nasm -f elf -o $@ $<

# boot_sect.bin: boot/boot_sect.asm
# 	pwd
# 	nasm -f bin -o $@ $<

# kernel.o: kernel.c
# 	gcc -ffreestanding -m32 -c $< -o $@

# $(OBJS): ${C_SOURCES} ${HEADERS} | $(OBJDIR)
# 	echo "building objs"
# 	echo $@
# 	$(CC) -ffreestanding -m32 -c $< -o $(OBJDIR)/$@ # compile a 32-bit obj-file from the c-sources

# $(OBJDIR):
# 	mkdir $(OBJDIR)

# $(OBJDIR)/%.o : C_SOURCES ${HEADERS}
# 	$(CC) -ffreestanding -m32 -c $< -o $@ # compile a 32-bit obj-file from the c-sources

# $(BINDIR)/kernel.bin: $(OBJDIR)/kernel_entry.o # TODO - what to link here?
# 	ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386

# Concatenate the bootloader and the kernel into an image
os_img: #$(BINDIR)/boot_sect.bin ${BINDIR}/kernel.bin
# Build the bootloader
> @cd boot && $(MAKE) -f boot.mk
# Build the kernel
> @cd kernel && $(MAKE) -f kernel.mk
# Build the drivers
> cd drivers && $(MAKE) -f drivers.mk
# > @echo "os_img"
# >	cat $^ > $@
> @cat $(BINDIR)/boot_sect.bin $(BINDIR)/kernel.bin > os_img


# Add the debug flag to the debug recipe, and all the recipes for the prerequisites
debug: CFLAGS += -g
debug: os_img boot_entry.asm
	#Boot the image on x86, ready for debug (-s) and stop cpu (-S)
>	@qemu-system-x86_64 -fda $< -boot a -s -S &
>	@sleep 1 # Otherwise the connection is not opened yet
>	@gdb

.PHONY: cleanobj
cleanobj:
>	-rm $(OBJDIR)/*.o

.PHONY: cleanbin
cleanbin:
>	-rm $(BINDIR)/*.bin

.PHONY: clean
clean:
>	-rm *.o *.dis os_img *.bin

.PHONY: cleanall
cleanall: cleanobj cleanbin clean

.PHONY: todolist
todolist:
>	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file;done ; true
