// =============================================================================
//
// NEZDRV Constants
//
// =============================================================================

#pragma once

// Z80 memory addresses for the mailbox.

#define NEZ_MAILBOX     (0xA00000+0x1FF0)
#define NEZ_MAILBOX_CMD (NEZ_MAILBOX+0x0)
#define NEZ_MAILBOX_SFX (NEZ_MAILBOX+0x8)
#define NEZ_SIG         (0xA00000)
#define NEZ_BUSREQ_PORT (0xA11100)
#define NEZ_RESET_PORT  (0xA11200)

// Command bytes for the mailbox.
#define NEZ_CMD_READY          0
#define NEZ_CMD_LOAD_SFX       1
#define NEZ_CMD_LOAD_PCM       2
#define NEZ_CMD_LOAD_BGM       3
#define NEZ_CMD_PAUSE_BGM      4
#define NEZ_CMD_RESUME_BGM     5
#define NEZ_CMD_STOP_BGM       6
#define NEZ_CMD_STOP_SFX       7
#define NEZ_CMD_SET_VOLUME_SFX 8
#define NEZ_CMD_SET_VOLUME_BGM 

#ifdef __ASSEMBLER__

// Macros for controlling Z80.
.macro	NEZ_Z80_RESET_ASSERT
	move.w	#0x000, NEZ_RESET_PORT
.endm

.macro	NEZ_Z80_RESET_DEASSERT
	move.w	#0x100, NEZ_RESET_PORT
.endm

.macro	NEZ_Z80_RESET_WAIT
	NEZ_Z80_RESET_ASSERT
	moveq	#20, d0
9:
	dbf	d0, 9b
.endm

.macro	NEZ_Z80_BUSREQ
	move.w	#0x100, NEZ_BUSREQ_PORT
.endm

.macro	NEZ_Z80_BUSREQ_WAIT
	NEZ_Z80_BUSREQ
9:
	btst	#0, NEZ_BUSREQ_PORT
	bne.s	9b
.endm

.macro	NEZ_Z80_BUSREL
	move.w	#0x000, NEZ_BUSREQ_PORT
.endm

#endif  // __ASSEMBLER__
