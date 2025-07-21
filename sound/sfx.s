	cpu		Z80
	dottedstructs	on
	include	"../nezdrv/src/nvm_format.inc"
	include	"../nezdrv/src/opn.inc"
	include	"pcm/pcm.inc"

SFX_VOL = 7Fh
RLEN = 12

INST_SAW       = 0
INST_PSG0      = 1

	nTrackHeader NEZ_PCMRATE_DEFAULT, 0, trklist, instlist

trklist:
	nTrackRelPtr snd_00
	nTrackRelPtr snd_01
	nTrackListEnd

instlist:
	nTrackRelPtr .inst_saw
	nTrackRelPtr .env_psg0
	nTrackListEnd

.inst_saw:
	include	"inst/saw1.s"
.env_psg0:
	db	0Fh
	db	0Ch
	db	0Ah
	db	06h
	db	03h
	db	NVM_MACRO_LPSET
	db	02h
	db	NVM_MACRO_LPEND
	db	02h
	db	02h
	db	01h
	db	01h
	db	01h
	db	00h
	db	NVM_MACRO_END

snd_00:
	nSfxCh	NVM_CHID_OPN4
	nInst	INST_SAW
	nLength	1
	nOct	4
	nC	1
	nSwpDn	40h
	nRest	6
	nSwpUp	0C0h
	nRest	6

	nLpSet	10
-:
	nSwpUp	70h
	nRest	3
	nSwpDn	70h
	nRest	3
	nLpEnd	-

	nOff
	nStop

snd_01:
	nSfxCh	NVM_CHID_PSG0
	nInst	INST_PSG0
	nLength	3
	nOct	4
	nA
	nG
	nA
	nG	20
	nOff
	nStop

	nTrackFooter
