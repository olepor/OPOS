# Change the recipe prefix for readability
.RECIPEPREFIX = >

# We dont need to run the implicit rules for all kinds of files
# Clear the list
.SUFFIXES: 
# Assign what we need
.SUFFIXES: .c .h .o .bin

PROJDIR = /home/olepor/OPOS

# TODO - all makefiles should make a copy of it's directory structure in build,
# and keep it's object files there
# OBJDIR := $(PROJDIR)/build/obj
BINDIR := $(PROJDIR)/sysroot/usr/bin
DEPDIR := $(PROJDIR)/sysroot/usr/dep

HOSTARCH ?= i686

# %.o : $(CODEDIR)%.o : $(C_SOURCES)
	# This should get just the filename as a pattern

# #(notdir dir/foo.c) -> foo.c
# $(addprefix src/, foo) -> src/foo

# Export all variables to submakes?
# .EXPORT_ALL_VARIABLES

# .DELETE_ON_ERROR # Do not keep files that are not processed completely

CC ?= i686-elf-gcc
CFLAGS ?= -ffreestanding -Wall -std=gnu11
# -wrap option could be handy for testing
LDFLAGS ?= -Map=linkmapfile.map --verbose  --oformat binary #--print-map

# include ${C_SOURCES:.c=.d} # Read in all the .d files