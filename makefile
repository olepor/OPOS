include makefile.inc

.PHONY: all
all: os_img
>	echo $<

.PHONY: run
run: all
>	qemu-system-x86_64 -fda os_img -boot a &


# Concatenate the bootloader and the kernel into an image
# After running all the sub-makes
os_img: #$(BINDIR)/boot_sect.bin ${BINDIR}/kernel.bin
# Build the bootloader
> @echo ${CFLAGS}
> @cd boot && $(MAKE) -f boot.mk
# Build the kernel
> @cd kernel && $(MAKE) -f kernel.mk
# Build the drivers
> cd drivers && $(MAKE) -f drivers.mk
> @cat $(BINDIR)/boot_sect.bin $(BINDIR)/kernel.bin > os_img


# Add the debug flag to the debug recipe, and all the recipes for the prerequisites
# also export it so that it is overwritten in all the submakes also
debug: export CFLAGS += -ggdb3 # extensive debugging information for gdb (DWARF 2) files, level three (max)
debug: os_img
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

.PHONY: cleandeps
cleandependencyfiles:
> -rm $(OBJDIR)/*.d

.PHONY: clean
clean: cleanobj cleanbin
>	-rm os_img

.PHONY: cleanall
cleanall: clean cleandeps

.PHONY: todolist
todolist:
>	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file;done ; true
