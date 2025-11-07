	cpu		Z80
	dottedstructs	on
	include	"../nezdrv/src/nvm_format.inc"
	include	"../nezdrv/src/opn.inc"
	include	"pcm.inc"

SFX_VOL = 7Fh
RLEN = 12

INST_SAW      = 0
INST_SQUARE   = 1
INST_SQUARE_FASTDECAY = 2
ENV_FASTDECAY = 3

	nTrackHeader 0, trklist, instlist

trklist:
	nTrackRelPtr snd_bounce
	nTrackRelPtr snd_csdoor
	nTrackRelPtr snd_psgshit
	nTrackRelPtr snd_psgshit2
	nTrackListEnd

instlist:
	nTrackRelPtr .inst_saw
	nTrackRelPtr .inst_square
	nTrackRelPtr .inst_square_fastdecay
	nTrackRelPtr .env_fastdecay
	nTrackListEnd

.inst_saw:
	include	"inst/saw1.s"
.inst_square:
	include	"inst/square1.s"
.inst_square_fastdecay:
	include	"inst/square1_fastdecay.s"
.env_fastdecay:
	db	NVM_MACRO_LPSET
	db	0Fh
	db	NVM_MACRO_LPEND
	db	0Ch
	db	09h
	db	06h
	db	03h
	db	00h
	db	NVM_MACRO_END

snd_csdoor:
	nSfxCh	NVM_CHID_OPN0
	nInst	INST_SQUARE_FASTDECAY
	nLength	2
	nVol	7Fh

	nOct	2
	nG
	nVol	7Eh
	nAs
	nOctUp
	nVol	7Dh
	nC
	nVol	7Ch
	nD
	nVol	7Bh
	nF
	nVol	7Ah
	nAs
	nOctUp
	nVol	79h
	nC
	nVol	78h
	nF
	nVol	77h
	nAs
;	nOctUp
;	nVol	76h
;	nDs
	nOff	1
	nStop

snd_bounce:
	nSfxCh	NVM_CHID_OPN4
	nInst	INST_SAW
	nLength	1
	nOct	4
	nC	1
	nSwpDn	70h
	nRest	5
	nSwpUp	0E0h
	nRest	5

	nLpSet	10
-:
	nSwpUp	0D6h
	nRest	1
	nSwpDn	0E0h
	nRest	1
	nLpEnd	-

	nOff
	nStop

snd_psgshit2:
	nSfxCh	NVM_CHID_PSG0
	nOct	3
	nInst	ENV_FASTDECAY
	nC
	nD
	nE
	nF
	nG
	nF
	nE
	nD
	nC
	nOff
	nStop

snd_psgshit:
	nSfxCh	NVM_CHID_PSGNS
	nNoise	4
	nLength	32
	nInst	ENV_FASTDECAY
	nOct	2
	nA
	nOff
	nStop

	nTrackFooter
