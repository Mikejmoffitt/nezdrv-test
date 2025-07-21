#pragma once

#ifndef __ASSEMBLER__
#include <stdint.h>
#endif  // __ASSEMBLER__

#define NEZ_SFX_CHANNEL_COUNT 3

#ifndef __ASSEMBLER__

// Installs the sound driver and resets the sound CPU.
void nezdrv_init(const uint8_t *sfx_data, const uint8_t **pcm_list);

// Pushes pending sound effects.
void nezdrv_update(void);

// Loads and plays the indicated BGM data.
void nezdrv_play_bgm(const uint8_t *bgm_data);

// Plays the specified effect ID on the chosen channel.
void nezdrv_play_sfx(uint16_t channel, uint16_t id);

#endif  // __ASSEMBLER__
