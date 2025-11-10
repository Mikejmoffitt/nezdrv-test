#include "sai/sai.h"
#include <stddef.h>
#include "dvram.h"
#include "res.h"
#include "nezdrv/nezdrv.h"

#define WANT_Z80_OVERCLOCK

// In a "real program" it'd be better to put this data in its own file, with
// alignment of 0x8000 for the data.

//
// Track Data
//

// SFX
/*alignas(0x8000) static const uint8_t sfx_data[] =
{
	#embed "wrk/sound/sfx.bin"
};*/

// BGM
/*
static const uint8_t bgm_asdf[] =
{
	#embed "wrk/sound/bgm/asdf.bin"
};

static const uint8_t bgm_straight_life[] =
{
	#embed "wrk/sound/bgm/straight_life.bin"
};
*/

static const uint8_t bgm_labfight[] =
{
	#embed "wrk/sound/bgm/labfight.bin"
};

static const uint8_t bgm_dangus[] =
{
	#embed "wrk/sound/bgm/dangus.bin"
};

static const uint8_t bgm_test[] =
{
	#embed "wrk/sound/bgm/test.bin"
};

//static const uint8_t bgm_tatsujin_oh_bgm6[] =
//{
//	#embed "wrk/sound/bgm/tatsujin_oh_bgm6.bin"
//};

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

static const uint8_t pcm_slkick2[] =
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
	pcm_slkick2,
	pcm_slsnare2,
	pcm_slhatc1,
	pcm_slhato1,
	pcm_cskick1,
	pcm_cssnare1,
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
	{bgm_test, "MML TEST", "MIKE MOFFITT"},
//	{bgm_asdf, "ASDF", "MIKE MOFFITT"},
	{bgm_dangus, "UNNAMED TEST TRACK", "MIKE MOFFITT"},
	{bgm_labfight, "LABYRINTH FIGHT", "PIXEL"},
//	{bgm_straight_life, "STRAIGHT LIFE", "FREDDIE HUBBARD"},
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

	// NEZDRV init
	draw_status_text("INIT...");
	const bool init_ok = nezdrv_init(NULL, pcm_list);
	if (init_ok)
	{
		draw_status_text("NEZDRV DEMO");
		draw_guide_text();
	}
	else
	{
		draw_status_text("INIT NG!");
	}

	// Interface
	uint16_t track_id = 0;
	uint16_t sfx_trk_id = 0;
#ifdef WANT_Z80_OVERCLOCK
	sai_vdp_debug_set(0x00, VDP_DBG01_Z80CK);
#endif  // WANT_Z80_OVERCLOCK

	play_track(track_id);
#ifdef WANT_Z80_OVERCLOCK
	sai_vdp_debug_set(0x00, VDP_DBG01_Z80CK);
#endif  // WANT_Z80_OVERCLOCK
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
		
		// sfx triggers
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
			nezdrv_play_sfx(0, sfx_trk_id);
		}

		nezdrv_update();
		sai_finish();
	}
}
