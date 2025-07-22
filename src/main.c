#include "sai/sai.h"
#include <stddef.h>
#include "dvram.h"
#include "res.h"
#include "nezdrv/nezdrv.h"

// In a "real program" it'd be better to put this data in its own file, with
// alignment of 0x8000 for the data.

//
// BGM Data
//

alignas(0x8000) static const uint8_t sfx_data[] =
{
	#embed "wrk/sound/sfx.bin"
};

static const uint8_t bgm_labfight[] =
{
	#embed "wrk/sound/bgm/labfight.bin"
};

static const uint8_t bgm_dangus[] =
{
	#embed "wrk/sound/bgm/dangus.bin"
};

//
// PCM Data.
//

alignas(0x8000) static const uint8_t pcm_kick1[] =
{
	#embed "sound/pcm/kick1.bin"
};

static const uint8_t pcm_snare1[] =
{
	#embed "sound/pcm/snare1.bin"
};




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

typedef struct TrackListing
{
	const uint8_t *data;
	const char *title;
	const char *author;
} TrackListing;

static const TrackListing k_tracks[] =
{
	{bgm_labfight, "LABYRINTH FIGHT", "PIXEL"},
	{bgm_dangus, "DANGUS", "MIKE MOFFITT"},
};

#define TRACK_COUNT (sizeof(k_tracks)/sizeof(k_tracks[0]))

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
	draw_status_text("NEZDRV INIT");

	static const uint8_t * const pcm_list[] =
	{
		pcm_kick1,
		pcm_snare1,
		NULL
	};
	const bool init_ok = nezdrv_init(sfx_data, pcm_list);
	if (init_ok)
	{
		draw_status_text("NEZDRV INIT OK");
		draw_guide_text();
	}
	else
	{
		draw_status_text("NEZDRV INIT NG");
	}

	uint16_t track_id = 0;


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

		if (g_sai_in[0].pos & SAI_BTN_C)
		{
			nezdrv_play_sfx(0, 0);
		}


		nezdrv_update();
		sai_finish();
	}
}
