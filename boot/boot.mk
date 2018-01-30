# Makefile included by the toplevel makefile
# Depends on several variables being defined in the includefile file such as:
# HOSTARCH
# CFLAGS
# CC

include ../makefile.inc


# this will copy the current directory structure under proj/build
OBJDIR = ${shell pwd | sed 's:OPOS:OPOS/build:'}

.PHONY = all
all: $(BINDIR)/boot_sect.bin
# > @echo ${HOSTARCH}
# > @echo ${VPATH}
# > @echo ${C_FILES}
# > @echo ${CFLAGS}

$(BINDIR)/boot_sect.bin: boot_sect.asm
> @echo $(BINDIR)
>	nasm -f bin -o $@ $<
