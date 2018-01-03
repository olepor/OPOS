# Makefile included by the toplevel makefile
# Depends on several variables being defined in the toplevel file such as:
# HOSTARCH
# CFLAGS
# CC

include ../makefile.inc

ARCHDIR = arch/${HOSTARCH}/
VPATH = ${ARCHDIR} # Reveal all the files from the arch/type-arch dir
C_FILES := ${shell find . -name "*.c"}
DEPENDENCY_FILES = ${addprefix ${DEPDIR}/, ${notdir ${C_FILES:.c=.d}}}
OBJS = ${C_FILES:.c=.o} # patsubst shortcut
OBJFILES := ${addprefix ${OBJDIR}/, ${notdir ${OBJS}}}

# Temp hostarch and variables. remove later when testing of this file is done
HOSTARCH ?= i386
CC ?= gcc
CFLAGS ?= -ffreestanding # -m32
OBJDIR ?= obj
BINDIR ?= bin

.PHONY: all
all: ${OBJFILES} ${BINDIR}/kernel.bin
# all: $(OBJDIR)/kernel.o

# Include all the automatically generated makefiles made my the .d dependencies
# include ${DEPENDENCY_FILES}

$(OBJDIR)/kernel_entry.o: kernel_entry.asm
> @nasm -f elf64 -o $@ $<

$(BINDIR)/kernel.bin: $(OBJDIR)/kernel_entry.o $(OBJDIR)/kernel.o
> @$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_x86_64

kernel.dis: $(BINDIR)/kernel.bin
>	ndisasm -b 32 $< > $@

# Implicit rule to build all c-files
.SECONDEXPANSION:
$(OBJDIR)/%.o : $$(shell ../utils/scripts/generatedeps %.c)
> @echo "Implicit kernel rule" $<
> @$(CC) -o $@ -c $< $(CFLAGS)
> @echo "after implicit kernel rule"
