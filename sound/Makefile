#
# Compilation of sound data.
#

AS=asl
P2BIN=p2bin
BSPLIT=bsplit
NEZPCM=../nezdrv/util/nezpcm/nezpcm

WRKDIR=wrk
OUTDIR=out

SOURCE_SFX := sfx.s
OBJECT_SFX := $(OUTDIR)/sfx.bin

SOURCES_BGM := $(shell find bgm/ -type f -name '*.s')
OBJECTS_BGM := $(patsubst bgm/%.s,$(OUTDIR)/bgm/%.bin,$(SOURCES_BGM))

SAMPLES_WAV := $(shell find wav/ -type f -name '*.wav')
SAMPLES_PCM := $(patsubst wav/%.wav,$(OUTDIR)/pcm/%.bin,$(SAMPLES_WAV))

PCM_RATE := 10650
PCM_VOL := 1.50

FFMPEG_FLAGS := -ar $(PCM_RATE)
FFMPEG_FLAGS += -af "volume=$(PCM_VOL)"
FFMPEG_FLAGS += -cutoff 1.0
FFMPEG_FLAGS += -f u8 -acodec pcm_u8


ASFLAGS=-i .

all: $(OUTDIR)/conversion

vars:
	echo "SAMPLES_WAV: " $(SAMPLES_WAV)
	echo "SAMPLES_PCM: " $(SAMPLES_PCM)
	echo "SOURCES_BGM: " $(SOURCES_BGM)
	echo "OBJECTS_BGM: " $(OBJECTS_BGM)
	echo "SOURCE_SFX: " $(SOURCE_SFX)
	echo "OBJECT_SFX: " $(OBJECT_SFX)
	echo "SAMPLES_WAV: " $(SAMPLES_WAV)
	echo "SAMPLES_PCM: " $(SAMPLES_PCM)


.PHONY: $(NEZPCM)
$(NEZPCM):
	make -C $(@D)

$(OBJECT_SFX): $(SOURCE_SFX)
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	$(AS) $< $(ASFLAGS) -o $(WRKDIR)/$@
	$(P2BIN) $(WRKDIR)/$@ $@

# For $(OBJECTS_BGM)
$(OUTDIR)/bgm/%.bin: bgm/%.s
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	$(AS) $< $(ASFLAGS) -o $(WRKDIR)/$@
	$(P2BIN) $(WRKDIR)/$@ $@

$(OUTDIR)/pcm/%.bin: wav/%.wav
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	ffmpeg -i $< $(FFMPEG_FLAGS) $@
	$(NEZPCM) $@


# Convert $FF to $FE as $FF is the end marker
$(OUTDIR)/conversion: $(OBJECTS_BGM) $(OUTDIR)/sfx.bin $(SAMPLES_PCM)
	mkdir -p $(@D)
	touch $@

.PHONY: clean

clean:
	@-rm -rf $(WRKDIR) $(OUTDIR)

