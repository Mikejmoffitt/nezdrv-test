#include "nezdrv/nezdrv.h"

// =============================================================================
//
// NEZDRV Constants
//
// =============================================================================

// Z80 memory addresses for the mailbox.

#define NEZ_MEM          (0xA00000)
#define NEZ_MEM_BYTES    0x2000
#define NEZ_SIG_OFFS     0x0000
#define NEZ_MAILBOX_OFFS 0x1FF0

#define NEZ_MAILBOX      (NEZ_MEM+0x1FF0)
#define NEZ_MAILBOX_CMD  (NEZ_MAILBOX+0x0)
#define NEZ_MAILBOX_SFX  (NEZ_MAILBOX+0x8)
#define NEZ_SIG          (NEZ_MEM)

#define NEZ_BUSREQ_PORT (0xA11100)
#define NEZ_RESET_PORT  (0xA11200)

// Command bytes for the mailbox.
#define NEZ_CMD_READY          0
#define NEZ_CMD_LOAD_SFX       1
#define NEZ_CMD_LOAD_PCM       2
#define NEZ_CMD_PLAY_BGM       3
#define NEZ_CMD_PAUSE_BGM      4
#define NEZ_CMD_RESUME_BGM     5
#define NEZ_CMD_STOP_BGM       6
#define NEZ_CMD_STOP_SFX       7
#define NEZ_CMD_SET_VOLUME_SFX 8
#define NEZ_CMD_SET_VOLUME_BGM 9

static inline void nez_z80_bus_req(bool wait)
{
	asm volatile("" ::: "memory");
	asm volatile("move.w #0x0100, (0xA11100).l");
	volatile uint16_t *z80_bus = (volatile uint16_t *)NEZ_BUSREQ_PORT;

//	*z80_bus = 0x0100;
	if (!wait) return;
	asm volatile("" ::: "memory");
	while (*z80_bus & 0x0100)
	{
		__asm__("nop");
	}
}

static inline void nez_z80_bus_release(void)
{
	asm volatile("" ::: "memory");
	asm volatile("move.w #0x0000, (0xA11100).l");
//	volatile uint16_t *z80_bus = (volatile uint16_t *)NEZ_BUSREQ_PORT;
//	*z80_bus = 0x0000;
}

static inline void nez_z80_reset_deassert(void)
{
	asm volatile("" ::: "memory");
	asm volatile("move.w #0x0100, (0xA11200).l");
//	volatile uint16_t *z80_reset = (volatile uint16_t *)NEZ_RESET_PORT;
//	*z80_reset = 0x0100;
}

static inline void nez_z80_reset_assert(bool wait)
{
	asm volatile("" ::: "memory");
	asm volatile("move.w #0x0000, (0xA11200).l");
//	volatile uint16_t *z80_reset = (volatile uint16_t *)NEZ_RESET_PORT;
//	*z80_reset = 0x0000;
	if (!wait) return;
	for (uint16_t i = 0; i < 64; i++)
	{
		__asm__ volatile("nop");
		__asm__ volatile("nop");
		__asm__ volatile("nop");
	}
}

// -----------------------------------------------------------------------------


static uint8_t s_sfx_queue[NEZ_SFX_CHANNEL_COUNT];

// The built NEZDRV binary.
static const uint8_t k_driver_prg[] =
{
	#embed "wrk/sound/nezdrv.bin"
};
_Static_assert(sizeof(k_driver_prg) <= NEZ_MEM_BYTES);

typedef struct NezMb
{
	uint8_t cmd;
	union
	{
		struct
		{
			uint8_t level;
		} vol;
		struct
		{
			uint8_t bank;    // 68K Address bits 21-16
			uint8_t ptr_lo;  // 68K address bits 7-0
			uint8_t ptr_hi;  // 68K address bits 15-8
		} addr;
	};
	uint8_t pad[4];
	uint8_t sfx[NEZ_SFX_CHANNEL_COUNT];
} NezMb;

// Waits until NEZDRV is ready to accept commands.
// Returns true if the driver signature is present and it can take commands.
// Returns false if it was unable to enter a ready state.
// If true is returned, then the bus is still held.
// If faflse is returned, then the bus was released.
static bool wait_ready(void)
{
	volatile uint8_t *z80mem = (volatile uint8_t *)NEZ_MEM;
	volatile NezMb *nezmb = (volatile NezMb *)&z80mem[NEZ_MAILBOX_OFFS];

	uint16_t tries = 127;

	while (tries-- > 0)
	{
		nez_z80_bus_req(/*wait=*/true);

		// Check for the init complete signature and the ready command byte.
		if (z80mem[NEZ_SIG_OFFS+0] == 'N' &&
		    z80mem[NEZ_SIG_OFFS+1] == 'E' &&
		    z80mem[NEZ_SIG_OFFS+2] == 'Z' &&
		    nezmb->cmd == NEZ_CMD_READY)
		{

			return true;
		}

		// It's not ready; let it run a little more.
		nez_z80_bus_release();

		for (uint16_t i = 0; i < 64; i++)
		{
			__asm__ volatile("nop");
		}
	}

	nez_z80_bus_release();
	return false;
}


static void write_native_addr(const void *address, volatile NezMb *nezmb)
{
	const uint32_t addr32 = (uint32_t)address;
	// The bank is A22-A15.
	nezmb->addr.bank = addr32 >> 15;
	nezmb->addr.ptr_lo = addr32 & 0xFF;
	nezmb->addr.ptr_hi = ((addr32 >> 8) & 0x7F) | 0x80;
	nezmb->pad[0] = 1;
}


void nezdrv_write_pcm_list(const uint8_t * const *pcm_list)
{
	volatile uint8_t *z80mem = (volatile uint8_t *)NEZ_MEM;
	volatile NezMb *nezmb = (volatile NezMb *)&z80mem[NEZ_MAILBOX_OFFS];
	// Register all PCM samples.
	if (pcm_list)
	{
		while (*pcm_list)
		{
			if (!wait_ready()) return;
			nez_z80_bus_req(/*wait=*/true);
			write_native_addr(*pcm_list, nezmb);
			nezmb->cmd = NEZ_CMD_LOAD_PCM;
			nez_z80_bus_release();
			pcm_list++;
		}
	}
}

bool nezdrv_init(const uint8_t *sfx_data, const uint8_t * const *pcm_list)
{
	// Load driver into memory.
	volatile uint8_t *z80mem = (volatile uint8_t *)NEZ_MEM;
	volatile NezMb *nezmb = (volatile NezMb *)&z80mem[NEZ_MAILBOX_OFFS];

	nez_z80_reset_assert(/*wait=*/false);
	nez_z80_bus_req(/*wait=*/false);
	nez_z80_reset_deassert();

	for (uint16_t i = 0; i < sizeof(k_driver_prg); i++)
	{
		z80mem[i] = k_driver_prg[i];
		asm volatile("" ::: "memory");
	}

	nez_z80_reset_assert(/*wait=*/true);
	nez_z80_reset_deassert();
	nez_z80_bus_release();

	if (sfx_data)
	{
		if (!wait_ready()) return false;
		// Load the sound effect data.
		nez_z80_bus_req(/*wait=*/true);
		write_native_addr(sfx_data, nezmb);
		nezmb->cmd = NEZ_CMD_LOAD_SFX;
		nez_z80_bus_release();
	}

	nezdrv_write_pcm_list(pcm_list);

	for (uint16_t i = 0; i < sizeof(s_sfx_queue); i++)
	{
		s_sfx_queue[i] = 0;
	}
	return true;
}

void nezdrv_play_bgm(const uint8_t *bgm_data)
{
	volatile uint8_t *z80mem = (volatile uint8_t *)NEZ_MEM;
	volatile NezMb *nezmb = (volatile NezMb *)&z80mem[NEZ_MAILBOX_OFFS];

	if (!wait_ready()) return;

	nez_z80_bus_req(/*wait=*/true);
	write_native_addr(bgm_data, nezmb);
	nezmb->cmd = NEZ_CMD_PLAY_BGM;
	nez_z80_bus_release();
};

void nezdrv_play_sfx(uint16_t channel, uint16_t id)
{
	s_sfx_queue[channel] = id+1;
}

void nezdrv_update(void)
{
	volatile uint8_t *z80mem = (volatile uint8_t *)NEZ_MEM;
	volatile NezMb *nezmb = (volatile NezMb *)&z80mem[NEZ_MAILBOX_OFFS];

	nez_z80_bus_req(/*wait=*/true);
	for (uint16_t i = 0; i < sizeof(s_sfx_queue); i++)
	{
		nezmb->sfx[i] = s_sfx_queue[i];
		s_sfx_queue[i] = 0;
	}
	nez_z80_bus_release();

}
