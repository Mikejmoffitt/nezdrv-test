# Project Setup  ---------------------------------------------------------------

PROJECT_NAME := nezdrv-test
SAI := saikodev/sai

WRKDIR := wrk
SRCDIR := src
RESDIR := res
OBJDIR := $(WRKDIR)/obj
SAIOBJDIR := $(WRKDIR)/saiobj
OUTDIR := out
NEZDRVDIR := nezdrv

PROJECT_OUTPUT := $(OUTDIR)/$(PROJECT_NAME).bin

.PHONY: all vars clean

# Saikodev Build Rules and Sources ---------------------------------------------

include $(SAI)/md/Sources.mk
include $(SAI)/mk/m68k-flags.mk
include $(SAI)/mk/utils.mk
include $(SAI)/mk/utils-md.mk

# Linker -----------------------------------------------------------------------

LDSCRIPT := $(SAI)/ld/md.ld
LDFLAGS +=
LIBS +=

# Compilation Flags ------------------------------------------------------------
CFLAGS +=
CPPFLAGS +=
ASFLAGS +=

# User Sources -----------------------------------------------------------------

SOURCES_ASM := $(shell find $(SRCDIR)/ -type f -name '*.a68')
SOURCES_C   := $(shell find $(SRCDIR)/ -type f -name   '*.c')
SOURCES_CPP := $(shell find $(SRCDIR)/ -type f -name '*.cpp')

OBJECTS_ASM := $(patsubst $(SRCDIR)/%.a68,$(OBJDIR)/%.o,$(SOURCES_ASM))
OBJECTS_C   := $(patsubst $(SRCDIR)/%.c,  $(OBJDIR)/%.o,$(SOURCES_C))
OBJECTS_CPP := $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o,$(SOURCES_CPP))

# Recipes ----------------------------------------------------------------------

all: $(PROJECT_OUTPUT)
.DEFAULT_GOAL := all

clean:
	rm -rf $(OUTDIR) $(OBJDIR) $(SAIOBJDIR) $(WRKDIR)
	make -C sound clean
	make -C $(NEZDRVDIR) clean

# Prebuild should depend on any targets that are required before compilation.
.PHONY: prebuild
prebuild: $(WRKDIR)/gfx.chr $(WRKDIR)/sound/nezdrv.bin $(WRKDIR)/sound/conversion

include $(SAI)/mk/build-rules.mk

#
# Graphics
#
.PHONY: $(WRKDIR)/gfx.chr
$(WRKDIR)/gfx.chr: png/gfx.ini $(VELELLA)
	mkdir -p $(WRKDIR)
	$(VELELLA) $<

#
# Sound
#

# The driver.
.PHONY: $(WRKDIR)/sound/nezdrv.bin
$(WRKDIR)/sound/nezdrv.bin: $(NEZDRVDIR)/out/nezdrv.bin
	mkdir -p $(@D)
	cp $< $@

.PHONY: $(NEZDRVDIR)/out/nezdrv.bin
$(NEZDRVDIR)/out/nezdrv.bin:
	make -C $(NEZDRVDIR)/

# The BGM and SFX data.
.PHONY: $(WRKDIR)/sound/conversion
$(WRKDIR)/sound/conversion: sound/out/conversion
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/sound/
	cp -r sound/out/* $(WRKDIR)/sound/

.PHONY:
sound/out/conversion:
	make -C sound/

