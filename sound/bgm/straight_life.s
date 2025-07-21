	cpu		Z80
	dottedstructs	on
	include	"../../nezdrv/src/nvm_format.inc"
	include	"../../nezdrv/src/opn.inc"
	include	"pcm/pcm.inc"



;
; Test track. It used to be Freddie Hubbard's "Straight Life".
;

MAIN_VOL = 78h
RLEN = NEZ_REST_LENGTH_DEFAULT

	nTrackHeader NEZ_PCMRATE_DEFAULT, NEZ_TEMPO_DEFAULT, .track_list, .instruments_list

.track_list:
	nTrackRelPtr track_sl_lead
	nTrackRelPtr track_sl_bass
	nTrackRelPtr track_sl_unused
	nTrackRelPtr track_sl_unused
	nTrackRelPtr track_sl_unused
	nTrackRelPtr track_sl_drum

	nTrackRelPtr track_sl_unused
	nTrackRelPtr track_sl_unused
	nTrackRelPtr track_sl_unused
	nTrackRelPtr track_sl_unused
	nTrackListEnd

.instruments_list:
	nTrackRelPtr .inst0_lead
	nTrackRelPtr .inst1_bass
	nTrackListEnd

.inst0_lead:
	include	"inst/saw1.s"
.inst1_bass:
	include	"inst/bass1.s"


track_sl_unused:
	nStop

;
; Drums
;
track_sl_drum:
	nPcmMode 1
	nLength RLEN
	nRest	RLEN*3
.loop:
	nLpSet 3
-:
	nPcmPlay PCM_KICK1
	nRest
	nRest
	nPcmPlay PCM_KICK1
	nPcmPlay PCM_SNARE1
	nRest

	nRest
	nPcmPlay PCM_KICK1
	nRest
	nPcmPlay PCM_KICK1
	nRest
	nPcmPlay PCM_KICK1
	nPcmPlay PCM_SNARE1
	nRest
	nRest
	nRest
	nLpEnd	-

	nPcmPlay PCM_KICK1
	nRest
	nRest
	nPcmPlay PCM_KICK1
	nPcmPlay PCM_SNARE1
	nRest
	nRest
	nPcmPlay PCM_KICK1
	nPcmPlay PCM_KICK1
	nPcmPlay PCM_KICK1
	nPcmPlay PCM_SNARE1
	nRest
	nPcmPlay PCM_SNARE1
	nPcmPlay PCM_SNARE1
	nPcmPlay PCM_SNARE1
	nPcmPlay PCM_SNARE1
	nJump	.loop

;
; Bassline
;

track_sl_bass_init_sub:
	nInst	1
	nLength	RLEN
	nOct	3
	nRet

track_sl_bass_echo:
	nCall	track_sl_bass_init_sub
	nVol	MAIN_VOL-0Ch
	nRest	3*RLEN/2
	nJump	track_sl_bass.start

track_sl_bass:
	nCall	track_sl_bass_init_sub
	nVol	MAIN_VOL
.start:
	nRest	RLEN*3
.loop:
	nCall	.pt1_sub
	nJump	.loop

.pt1_sub:
	nC RLEN*2
	nE
	nG
	nOctUp
	nC
	nOctDn
	nG
	nC

	nOctDn
	nBb RLEN*2
	nBb
	nOctUp
	nD
	nF
	nBb
	nF
	nOctDn
	nBb RLEN*2
	nOctUp
	nRet

;
;
;
track_sl_lead_init_sub:
	nInst	0
	nLength	RLEN
	nOct	4
	nRet

track_sl_lead_echo:
	nCall	track_sl_lead_init_sub
	nVol	MAIN_VOL-0Ch
	nPanL
	nRest	3*RLEN/2
	nJump	track_sl_lead.loop

track_sl_lead:
	nCall	track_sl_lead_init_sub
	nVol	MAIN_VOL
.loop:
	nCall	.pre_sub
	nCall	.pt1_sub
	nCall	.pt1_sub
	nCall	.pt2_sub
	nCall	.pt3_sub
	nCall	.pt3a_sub
	nJump	.loop

.pre_sub:
	nG
	nF
	nOff
	nRet

.pt1_sub:
	nE RLEN*3
	nD
	nE
	nD
	nC RLEN*2

	nD RLEN*3
	nC
	nD
	nC
	nOctDn
	nBb RLEN*2
	nBb RLEN*2
	nOctUp
	nC RLEN*11
	nE RLEN*2
	nEb
	nRet

.pt2_sub:
	nLength RLEN*2
	nE
	nF
	nG
	nLength RLEN
	nA
	nAs
	nOff RLEN*8
	nLength RLEN*2
	nAs
	nA
	nG
	nLength RLEN
	nF
	nG
	nOff RLEN*8
	nLength	RLEN*2
	nE
	nF
	nG
	nA
	nAs
	nA
	nG
	nF
	nG
	nE
	nE
	nLength	RLEN
	nEb
	nE
	nOff RLEN*3
	nRet

.pt3_sub:
	nLpSet	2
-:
	nCall	.pt3_inner
	nRest RLEN*4
	nLpEnd	-
	nCall	.pt3_inner
	nRet

.pt3_inner:
	nE RLEN*2
	nD
	nC
	nOctDn
	nBb
	nOctUp

	nC RLEN*2
	nOctDn
	nBb
	nOff RLEN*4
	nOctUp
	nRet

.pt3a_sub:
	nOctDn
	nG
	nBb
	nOctUp
	nC
	nC
	nC
	nC
	nOff
	nD
	nC RLEN*5
	nOctDn
	nBb
	nG
	nOff RLEN*7
	nOctUp
	nRet

	nTrackFooter
