#include "nezdrv/nezdrv.h"
#include "nezdrv/nezdrv_cmd.h"
#include "nezdrv/nezdrv_defs.h"
#include "nezdrv/nezdrv_load.h"

static const uint8_t k_driver_prg[] =
{
	#embed "wrk/sound/nezdrv.bin"
};

void nezdrv_init(void)
{
	nez_z80_load(k_driver_prg, sizeof(k_driver_prg));
	nezdrv_cmd_wait_ready();
	nezdrv_cmd_load_sfx();
	nezdrv_cmd_load_pcm();
}
