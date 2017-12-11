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
# TODO add the objdir to all the obj-files on OBJS
# Make all depend on all the driver obj-files in objdir-directory
all: $(addprefix $(OBJDIR)/, $(notdir $(OBJS)))
> @echo ${HOSTARCH}
> @echo ${VPATH}
> @echo ${C_FILES}
> @echo ${CFLAGS}
> @echo $(OBJS)
> @echo $(OBJDIR)
> @echo $(addprefix $(OBJDIR)/, $(notdir $(OBJS)))

# Add all object files as targets, and c-files as prerequisites
# and run the implicit rule defined below
# FIXME - include .d files to list all prerequisites for each obj file (e.g. .c and .h files)
$(addprefix $(OBJDIR)/, $(notdir $(OBJS))) : $(C_FILES)

$(OBJDIR)/%.o : %.c
> @echo "Obj implicit rule"
> $(CC) -o $@ -c $< $(CFLAGS)
