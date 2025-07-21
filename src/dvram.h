#pragma once

#ifndef __ASSEMBLER__
#include <stdint.h>
#endif  // __ASSEMBLER__

extern uint16_t g_dvram_addr;

// Dynamic video memory for allocation at the start of a stage / room.
static inline void dvram_reset(void);

// Allocates specified word count in VRAM (bytes/2) and returns the address.
static inline uint16_t dvram_alloc(uint16_t words);

// -----------------------------------------------------------------------------

static inline void dvram_reset(void)
{
	g_dvram_addr = 0;
}

static inline uint16_t dvram_alloc(uint16_t words)
{
	const uint16_t ret = g_dvram_addr;
	g_dvram_addr += words*2;
	return ret;
}
