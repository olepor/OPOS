# Makefile included by the toplevel makefile
# Depends on several variables being defined in the toplevel file such as:
# HOSTARCH
# CFLAGS
# CC

include ../makefile.inc

ARCHDIR = arch/${HOSTARCH}/
VPATH = ${ARCHDIR} # Reveal all the files from the arch/type-arch dir
C_FILES := ${shell find . -name *.c}
OBJS = ${C_FILES:.c=.o} # patsubst shortcut

# Temp hostarch and variables. remove later when testing of this file is done
HOSTARCH ?= i386
CC ?= gcc
CFLAGS ?= -ffreestanding -m32
OBJDIR ?= obj
BINDIR ?= bin

.PHONY = all
all: $(BINDIR)/kernel.bin
> @echo ${HOSTARCH}
> @echo ${VPATH}
> @echo ${C_FILES}
> @echo ${CFLAGS}

# Automatically generate a prerequisicite file for all .c files
# %.d: %.c
# 	@echo "creating all dependency files"
#   @set -e; rm -f $@; \ # Exit shell on error
#    $(CC) -M $(CPPFLAGS) $< > $@.$$$$; \ # Get the list of dependencies
#    sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \ # Transform the list by adding %.d as a target
#    rm -f $@.$$$$

$(OBJDIR)/%.o : %.c # Implicit rule to build all c-files, and create the obj-dir if it doesnt exist
> @echo "Implicit kernel rule" $<
> @$(CC) -o $@ -c $< $(CFLAGS)
> @echo "after implicit kernel rule"

$(OBJDIR)/kernel_entry.o: kernel_entry.asm
> @nasm -f elf -o $@ $<

$(BINDIR)/kernel.bin: $(OBJDIR)/kernel_entry.o $(OBJDIR)/kernel.o
> @ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386

kernel.dis: $(BINDIR)/kernel.bin
>	ndisasm -b 32 $< > $@
