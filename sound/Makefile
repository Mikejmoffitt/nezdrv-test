#
# Compilation of sound data.
#

AS=asl
P2BIN=p2bin
BSPLIT=bsplit
MAME=mame

WRKDIR=wrk
OUTDIR=out

SOURCE_SFX := sfx.s

SOURCES_BGM := $(shell find bgm/ -type f -name '*.s')
OBJECTS_BGM := $(patsubst bgm/%.s,$(OUTDIR)/bgm/%.bin,$(SOURCES_BGM))

SAMPLES_WAV := $(shell find wav/ -type f -name '*.wav')
SAMPLES_PCM := $(patsubst wav/%.s,$(OUTDIR)/pcm/%.bin,$(SAMPLES_WAV))

BIN2S := ../saikodev/sai/util/core/bin2s
BIN2H := ../saikodev/sai/util/core/bin2h

ASFLAGS=-i .

all: $(OUTDIR)/conversion

$(OUTDIR)/sfx.bin: $(SOURCE_SFX)
	mkdir -p $(WRKDIR)
	mkdir -p $(OUTDIR)
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	$(AS) $< $(ASFLAGS) -o $(WRKDIR)/$@
	$(P2BIN) $(WRKDIR)/$@ $@

$(OUTDIR)/bgm/%.bin: bgm/%.s
	mkdir -p $(WRKDIR)
	mkdir -p $(OUTDIR)
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	$(AS) $< $(ASFLAGS) -o $(WRKDIR)/$@
	$(P2BIN) $(WRKDIR)/$@ $@

$(OUTDIR)/pcm/%.bin: pcm/%.s
	mkdir -p $(WRKDIR)
	mkdir -p $(OUTDIR)
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	ffmpeg -i $< -osr 10650 -f u8 -acodec pcm_u8 $@_raw

# Convert $FF to $FE as $FF is the end marker


$(OUTDIR)/conversion: $(OBJECTS_BGM) $(OUTDIR)/sfx.bin
	mkdir -p $(@D)
	touch $@

.PHONY: clean

clean:
	@-rm -rf $(WRKDIR) $(OUTDIR)
