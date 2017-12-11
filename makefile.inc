# Change the recipe prefix for readability
.RECIPEPREFIX = >

# We dont need to run the implicit rules for all kinds of files
# Clear the list
.SUFFIXES: 
# Assign what we need
.SUFFIXES: .c .h .o .bin

PROJDIR = /home/opus/OPOS

OBJDIR := $(PROJDIR)/build/obj
BINDIR := $(PROJDIR)/build/bin

HOSTARCH ?= i386

# %.o : $(CODEDIR)%.o : $(C_SOURCES)
	# This should get just the filename as a pattern

# #(notdir dir/foo.c) -> foo.c
# $(addprefix src/, foo) -> src/foo

# Export all variables to submakes?
# .EXPORT_ALL_VARIABLES

# .DELETE_ON_ERROR # Do not keep files that are not processed completely

CC ?= gcc
CFLAGS ?= -ffreestanding -m32 -Wall

# include ${C_SOURCES:.c=.d} # Read in all the .d files
# include boot/boot.mk # kernel/kernel.mk drivers/drivers.mk # Run the other makefiles first