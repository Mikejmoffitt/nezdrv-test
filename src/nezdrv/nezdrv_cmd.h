#pragma once

#ifndef __ASSEMBLER__
#include <stdint.h>
#endif // __ASSEMBLER__

#define NEZ_SFX_CHANNEL_COUNT 3

#ifndef __ASSEMBLER__
extern uint8_t g_nezdrv_sfx_queue[NEZ_SFX_CHANNEL_COUNT];
void nezdrv_cmd_wait_ready(void);
void nezdrv_cmd_load_sfx(void);    // Do this first.
void nezdrv_cmd_load_pcm(void);    // Do this second.
void nezdrv_cmd_load_bgm(void);    // Do this at any time after the first two.
void nezdrv_cmd_update_sfx(void);  // Run this periodically.
#else
	.extern g_nezdrv_sfx_queue[NEZ_SFX_CHANNEL_COUNT];
#endif // __ASSEMBLER__
