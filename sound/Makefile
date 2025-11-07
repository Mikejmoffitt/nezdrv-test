#
# Compilation of sound data.
#

AS=asl
P2BIN=p2bin
BSPLIT=bsplit
NEZPCM=../nezdrv/util/nezpcm/nezpcm
NEZMML=../nezdrv/util/nezmml/nezmml

WRKDIR=wrk
OUTDIR=out

SOURCE_SFX := sfx.s
OBJECT_SFX := $(OUTDIR)/sfx.bin

SOURCES_DIRECT_DATA := $(shell find bgm/ -type f -name '*.s')
OBJECTS_DIRECT_DATA := $(patsubst bgm/%.s,$(OUTDIR)/bgm/%.bin,$(SOURCES_DIRECT_DATA))

SOURCES_MML := $(shell find bgm/ -type f -name '*.mml')
OBJECTS_MML := $(patsubst bgm/%.mml,$(OUTDIR)/bgm/%.bin,$(SOURCES_MML))

SAMPLES_WAV := $(shell find wav/ -type f -name '*.wav')
SAMPLES_PCM := $(patsubst wav/%.wav,$(OUTDIR)/pcm/%.bin,$(SAMPLES_WAV))

PCM_RATE := 8878

PCM_VOL := 1.50

FFMPEG_FLAGS := -ar $(PCM_RATE)
FFMPEG_FLAGS += -af "volume=$(PCM_VOL)"
FFMPEG_FLAGS += -cutoff 1.0
FFMPEG_FLAGS += -f u8 -acodec pcm_u8
FFMPEG_FLAGS += -loglevel error
FFMPEG_FLAGS += -y



ASFLAGS=-i .

all: $(OUTDIR)/conversion

vars:
	echo "SAMPLES_WAV: " $(SAMPLES_WAV)
	echo "SAMPLES_PCM: " $(SAMPLES_PCM)
	echo "SOURCES_DIRECT_DATA: " $(SOURCES_DIRECT_DATA)
	echo "OBJECTS_DIRECT_DATA: " $(OBJECTS_DIRECT_DATA)
	echo "SOURCES_MML: " $(SOURCES_MML)
	echo "OBJECTS_MML: " $(OBJECTS_MML)
	echo "SOURCE_SFX: " $(SOURCE_SFX)
	echo "OBJECT_SFX: " $(OBJECT_SFX)
	echo "SAMPLES_WAV: " $(SAMPLES_WAV)
	echo "SAMPLES_PCM: " $(SAMPLES_PCM)


.PHONY: $(NEZPCM)
$(NEZPCM):
	make -C $(@D)

.PHONY: $(NEZMML)
$(NEZMML):
	make -C $(@D)

$(OBJECT_SFX): $(SOURCE_SFX)
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	$(AS) $< $(ASFLAGS) -o $(WRKDIR)/$@
	$(P2BIN) $(WRKDIR)/$@ $@

# For $(OBJECTS_DIRECT_DATA)
$(OUTDIR)/bgm/%.bin: bgm/%.s
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	$(AS) $< $(ASFLAGS) -o $(WRKDIR)/$@
	$(P2BIN) $(WRKDIR)/$@ $@

# For $(OBJECTS_MML)
$(OUTDIR)/bgm/%.bin: bgm/%.mml
	mkdir -p $(@D)
	$(NEZMML) $< $@

# For (SAMPLES_PCM)
$(OUTDIR)/pcm/%.bin: wav/%.wav $(NEZPCM)
	mkdir -p $(@D)
	mkdir -p $(WRKDIR)/$(@D)
	ffmpeg -i $< $(FFMPEG_FLAGS) $@
	$(NEZPCM) $@


# Convert $FF to $FE as $FF is the end marker
$(OUTDIR)/conversion: $(OBJECTS_DIRECT_DATA) $(OBJECTS_MML) $(SAMPLES_PCM) # $(OBJECT_SFX)
	mkdir -p $(@D)
	touch $@

.PHONY: clean

clean:
	@-rm -rf $(WRKDIR) $(OUTDIR)

