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

# .PHONY = all
all: # TODO add depenencies
# > @echo ${HOSTARCH}
# > @echo ${VPATH}
# > @echo ${C_FILES}
# > @echo ${CFLAGS}

$(OBJDIR)/%.o : %.c
> $(CC) -o $@ -c $< $(CFLAGS)
