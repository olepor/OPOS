# Makefile included by the toplevel makefile
# Depends on several variables being defined in the toplevel file such as:
# HOSTARCH
# CFLAGS
# CC

include ../makefile.inc

ARCHDIR = arch/${HOSTARCH}/
VPATH = ${ARCHDIR} # Reveal all the files from the arch/type-arch dir
C_FILES := ${shell find . -name "*.c" -not -path "./test/*"}
H_FILES := ${shell find . -name "*.h" -not -path "./test/*"}
OBJS = ${C_FILES:.c=.o} # patsubst shortcut

# Temp hostarch and variables. remove later when testing of this file is done
HOSTARCH ?= i386
CC ?= gcc
CFLAGS ?= -ffreestanding # -m32
BINDIR ?= bin

.PHONY: all
all: ${OBJS} kernel.bin
> @echo ${OBJFILES}
> @echo ${OBJDIR}
> @echo ${OBJS}
# all: $(OBJDIR)/kernel.o

.PHONY: install-headers
install-headers:
> cp -r --preserve=timestamps ${H_FILES} ../sysroot/usr/include

kernel_entry.o: kernel_entry.asm
> nasm -o $@ $< -f elf

# TODO link in compilation
kernel.bin: kernel_entry.o kernel.o framebuffer.o
> @echo $(LD)
> @$(LD) -o $@ -Ttext 0x1000 $^ $(LDFLAGS)

kernel.dis: $(BINDIR)/kernel.bin
>	ndisasm -b 32 $< > $@

# Implicit rule to build all c-files
%.o:%.c
> @$(CC) -o $@ -c $< $(CFLAGS)
# .SECONDEXPANSION:
# $(OBJDIR)/%.o : $$(shell ../utils/scripts/generatedeps %.c)
# > @echo "Implicit kernel rule" $<
# > @$(CC) -o $@ -c $< $(CFLAGS)
# > @echo "after implicit kernel rule"

.PHONY: clean
clean:
>	@rm -rf *.o *.bin
