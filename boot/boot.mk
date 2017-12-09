# Makefile included by the toplevel makefile
# Depends on several variables being defined in the includefile file such as:
# HOSTARCH
# CFLAGS
# CC

include ../makefile.inc

# Temp hostarch and variables. remove later when testing of this file is done
HOSTARCH ?= i386
CC ?= gcc
CFLAGS ?= -ffreestanding -m32
OBJDIR ?= obj
BINDIR ?= bin

# .PHONY = all
# all: $(BINDIR)/boot_sect.bin
# > @echo ${HOSTARCH}
# > @echo ${VPATH}
# > @echo ${C_FILES}
# > @echo ${CFLAGS}

# Automatically generate a prerequisicite file for all .c files
# %.d: %.c
# 	@echo "creating all dependency files"
#   @set -e; rm -f $@; \ # Exit shell on error
#    $(CC) -M $(CPPFLAGS) $< > $@.$$$$; \ # Get the list of dependencies
#    sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \ # Transform the list by adding %.d as a target
#    rm -f $@.$$$$

$(BINDIR)/boot_sect.bin: boot_sect.asm
> @echo $(BINDIR)
>	nasm -f bin -o $@ $<
