#pragma once

#ifndef __ASSEMBLER__
#include <stdint.h>
#endif  // __ASSEMBLER__
#include "sai/sai.h"
#include "nezdrv/nezdrv_cmd.h"
#include "nezdrv/nezdrv_defs.h"

#ifndef __ASSEMBLER__

// Installs the sound driver and resets the sound CPU.
void nezdrv_init(void);

// Pushes pending sound effects.
static inline void nezdrv_update(void);

// Loads and plays the specified BGM ID.
static inline void nezdrv_play_bgm(uint16_t id);

// Plays the specified effect ID on the chosen channel.
static inline void nezdrv_play_sfx(uint16_t channel, uint16_t id);

// -----------------------------------------------------------------------------

static inline void nezdrv_play_bgm(uint16_t id)
{
	register uint16_t d0 asm ("d0") = id;
	asm volatile ("jsr nezdrv_cmd_load_bgm"
	:
	: "d" (d0)
	:  "d1", "a0", "a1", "memory", "cc" );
};

static inline void nezdrv_play_sfx(uint16_t channel, uint16_t id)
{
	g_nezdrv_sfx_queue[channel] = id+1;
}

static inline void nezdrv_update(void)
{
	asm volatile ("jsr nezdrv_cmd_update_sfx");
}

#endif  // __ASSEMBLER__
