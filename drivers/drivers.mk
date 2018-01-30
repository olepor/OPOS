# Makefile included by the toplevel makefile
# Depends on several variables being defined in the toplevel file such as:
# HOSTARCH
# CFLAGS
# CC

include ../makefile.inc

ARCHDIR = arch/${HOSTARCH}/
VPATH = ${ARCHDIR} # Reveal all the files from the arch/type-arch dir
C_FILES := ${shell find . -name *.c}
H_FILES := ${shell find . -name *.h}
OBJS = ${C_FILES:.c=.o} # patsubst shortcut

# this will copy the current directory structure under proj/build
OBJDIR = ${shell pwd | sed 's:OPOS:OPOS/build:'}

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


.PHONY: install-headers
install-headers:
> cp -r --preserve=timestamps ${H_FILES} ../sysroot/usr/include

# Add all object files as targets, and c-files as prerequisites
# and run the implicit rule defined below
# FIXME - include .d files to list all prerequisites for each obj file (e.g. .c and .h files)
# $(addprefix $(OBJDIR)/, $(notdir $(OBJS))) : $(C_FILES)

.SECONDEXPANSION:
$(OBJDIR)/%.o : $$(shell ../utils/scripts/generatedeps %.c)
> @echo "Obj implicit rule"
> $(CC) -o $@ -c $< $(CFLAGS)
