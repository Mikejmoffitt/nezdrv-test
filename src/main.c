#include "sai/sai.h"
#include <stddef.h>
#include "dvram.h"
#include "res.h"
#include "nezdrv/nezdrv.h"

//
// Playing around with H-int scheduled palette changes
//

typedef struct HChartEntry
{
	int16_t lines;
	uint16_t idx;
	uint16_t color;
	uint16_t pad;
} HChartEntry;

static const HChartEntry hirq_chart[] =
{
	{ 0, 0, 0},
	{ 8-1, SAI_PAL333(7, 0, 0), SAI_PAL333(3, 0, 0)},
	{ 8-1, SAI_PAL333(0, 7, 0), SAI_PAL333(0, 3, 0) },
	{ 8-1, SAI_PAL333(0, 0, 7), SAI_PAL333(0, 0, 3) },
	{ 8-1, SAI_PAL333(7, 7, 0), SAI_PAL333(0, 4, 4) },
	{ 8-1, SAI_PAL333(0, 0, 0), SAI_PAL333(1, 2, 2) },
	{-1, 0, 0},
};

static const HChartEntry *s_entry_ptr;

static void hirq_chart_callback(void)
{
	asm __volatile__ (
		"lea	(0xC00008+1).l, %%a0;"
		"read:cmpi.b	#240/2, (%%a0);"
		"bcs.b	read;"
		: : : "a0"
	);
	sai_vdp_set_autoinc(2);
	sai_vdp_set_addr_cramw(0);
	sai_vdp_write_word(s_entry_ptr->color);
	s_entry_ptr++;
	if (s_entry_ptr->lines < 0) sai_vdp_set_hint_en(false);
	else sai_vdp_set_hint_line(s_entry_ptr->lines);
}

static void hirq_chart_reset(void)
{
	s_entry_ptr = hirq_chart;
	sai_vdp_set_hint_line(0);
	sai_vdp_set_hint_en(true);
}

static void hirq_chart_init(void)
{
	g_irq_hbl_callback = hirq_chart_callback;
	hirq_chart_reset();
	sai_vdp_set_hint_en(true);
}

// In a "real program" it'd be better to put this data in its own file, with
// alignment of 0x8000 for the data.

//
// Track Data
//

// SFX
alignas(0x8000) static const uint8_t sfx_data[] =
{
	#embed "wrk/sound/sfx.bin"
};

// BGM
static const uint8_t bgm_labfight[] =
{
	#embed "wrk/sound/bgm/labfight.bin"
};

static const uint8_t bgm_dangus[] =
{
	#embed "wrk/sound/bgm/dangus.bin"
};

static const uint8_t bgm_straight_life[] =
{
	#embed "wrk/sound/bgm/straight_life.bin"
};

//
// PCM Data.
//

alignas(0x8000) static const uint8_t pcm_cskick1[] =
{
	#embed "wrk/sound/pcm/cskick1.bin"
};

static const uint8_t pcm_cssnare1[] =
{
	#embed "wrk/sound/pcm/cssnare1.bin"
};

alignas(0x8000) static const uint8_t pcm_slkick2[] =
{
	#embed "wrk/sound/pcm/slkick2.bin"
};

static const uint8_t pcm_slsnare2[] =
{
	#embed "wrk/sound/pcm/slsnare2.bin"
};

static const uint8_t pcm_slhatc1[] =
{
	#embed "wrk/sound/pcm/slhatc1.bin"
};

static const uint8_t pcm_slhato1[] =
{
	#embed "wrk/sound/pcm/slhato1.bin"
};



//
// Sound lists.
//

// PCM Samples
static const uint8_t * const pcm_list[] =
{
	pcm_cskick1,
	pcm_cssnare1,
	pcm_slkick2,
	pcm_slsnare2,
	pcm_slhatc1,
	pcm_slhato1,
	NULL
};

// Tracks
typedef struct TrackListing
{
	const uint8_t *data;
	const char *title;
	const char *author;
} TrackListing;

static const TrackListing k_tracks[] =
{
	{bgm_dangus, "UNNAMED TEST TRACK", "MIKE MOFFITT"},
	{bgm_labfight, "LABYRINTH FIGHT", "PIXEL"},
	{bgm_straight_life, "STRAIGHT LIFE", "FREDDIE HUBBARD"},
};

#define TRACK_COUNT (sizeof(k_tracks)/sizeof(k_tracks[0]))

//
// Interface stuff
//


#define PAL_FONT 0

static uint16_t s_font_vram;

#define TEST_BG_VRAM_FONT_ADDR 0x0000
#define TEST_SPR_VRAM_ADDR (TEST_BG_VRAM_FONT_ADDR+BG_FONT_CHR_BYTES)

#define TEXT_ATTR VDP_ATTR(VDP_TILE(TEST_BG_VRAM_FONT_ADDR), 0, 0, PAL_FONT, 1)

static inline void print_string(uint32_t vram_addr, const uint16_t attr_base,
                                const char *str)
{
	sai_vdp_set_autoinc(2);
	sai_vdp_set_addr_vramw(vram_addr);

	char val;
	while ((val = *str))
	{
		if (val >= ' ')
		{
			sai_vdp_write_word((val-' ') + attr_base);
		}
		str++;
	}
}

static void draw_status_text(const char *str)
{
	print_string(sai_vdp_calc_plane_addr(VDP_PLANE_A, 0, 0),
	             TEXT_ATTR, str);
}

static void draw_guide_text()
{
	print_string(sai_vdp_calc_plane_addr(VDP_PLANE_A, 1, 26),
	             TEXT_ATTR, "L/R : Change Track");
}

static void play_track(uint16_t id)
{
	const TrackListing *trk = &k_tracks[id];

	nezdrv_play_bgm(trk->data);

	const char *k_spaces = "                                      ";
	print_string(sai_vdp_calc_plane_addr(VDP_PLANE_A, 1, 4),
	             TEXT_ATTR, k_spaces);
	print_string(sai_vdp_calc_plane_addr(VDP_PLANE_A, 1, 5),
	             TEXT_ATTR, k_spaces);
	print_string(sai_vdp_calc_plane_addr(VDP_PLANE_A, 1, 4),
	             TEXT_ATTR, trk->title);
	print_string(sai_vdp_calc_plane_addr(VDP_PLANE_A, 1, 5),
	             TEXT_ATTR, trk->author);
}

//
// Main
//

void __attribute__((noreturn)) main(void)
{
	sai_init();
	// CHR load
	dvram_reset();
	s_font_vram = dvram_alloc(BG_FONT_CHR_WORDS);
	sai_vdp_dma_transfer_vram(s_font_vram,
	                          vel_get_wrk_gfx_chr(BG_FONT),
	                          BG_FONT_CHR_WORDS, 2);
	sai_pal_load(PAL_FONT, vel_get_wrk_gfx_pal(BG_FONT), 1);
	sai_finish();
	draw_status_text("INIT...");
	const bool init_ok = nezdrv_init(sfx_data, pcm_list);
	if (init_ok)
	{
		draw_status_text("NEZDRV DEMO (HICLOCK VER)");
		draw_guide_text();
	}
	else
	{
		draw_status_text("INIT NG!");
	}

	uint16_t track_id = 0;
	uint16_t sfx_ch_id = 0;
	uint16_t sfx_trk_id = 0;

//	hirq_chart_init();

	play_track(track_id);
	while (true)
	{
		if (g_sai_in[0].pos & SAI_BTN_RIGHT)
		{
			track_id++;
			if (track_id >= TRACK_COUNT) track_id = 0;
			play_track(track_id);
		}
		else if (g_sai_in[0].pos & SAI_BTN_LEFT)
		{
			if (track_id == 0) track_id = TRACK_COUNT-1;
			else track_id--;
			play_track(track_id);
		}

		/*
		if (g_sai_in[0].pos & SAI_BTN_DOWN)
		{
			sai_vdp_debug_set(0x01, 0);
		}
		if (g_sai_in[0].pos & SAI_BTN_UP)
		{
			sai_vdp_debug_set(0x01, VDP_DBG01_Z80CK);
		}*/

		/*
		if (g_sai_in[0].pos & SAI_BTN_DOWN)
		{
			sfx_trk_id++;
		}
		if (g_sai_in[0].pos & SAI_BTN_UP)
		{
			sfx_trk_id--;
		}
		if (g_sai_in[0].pos & SAI_BTN_C)
		{
			nezdrv_play_sfx(sfx_ch_id, sfx_trk_id);
		}
		sfx_ch_id++;*/
		if (sfx_ch_id > 2) sfx_ch_id = 0;

		nezdrv_update();
//		sai_irq_vbl_wait();
//		hirq_chart_reset();
		sai_finish();
	}
}
