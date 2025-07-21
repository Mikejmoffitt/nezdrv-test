#pragma once

#ifndef __ASSEMBLER__

#include <stdint.h>

extern uint8_t *nezdrv_data_bgm_list[];
extern uint8_t *nezdrv_data_sfx[];

#else

	.extern	nezdrv_data_bgm_list
	.extern	nezdrv_data_sfx

#endif  // __ASSEMBLER__
