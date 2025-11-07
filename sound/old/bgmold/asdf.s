	cpu		Z80
	dottedstructs	on
	include	"../../nezdrv/src/nvm_format.inc"
	include	"../../nezdrv/src/opn.inc"
	include	"pcm.inc"


MAIN_VOL = 7Bh
; typical rest value
RLEN = 12
; stecatto hit
RSTEC = RLEN/4
; rest following stecatto
RSTECOFF = RSTEC*3

TEMPO = 0CCh

INST_BASS1 = 0
INST_GUITAR1 = 1

	nTrackHeader TEMPO, trk_list, instruments_list

trk_list:
	nTrackRelPtr trk_a
	nTrackRelPtr trk_b
	nTrackRelPtr trk_c
	nTrackRelPtr trk_d
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_drums

	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackListEnd

trk_unused:
	nStop

instruments_list:
	nTrackRelPtr .inst_bass1
	nTrackRelPtr .inst_guitar1
	nTrackListEnd

.inst_bass1:
	include	"inst/bass1.s"
.inst_guitar1:
	include	"inst/guitar1.s"
.inst_bass2:
	include	"inst/bass2.s"

trk_a:
	nInst	INST_GUITAR1
	nVol	7Fh
	nLength	RLEN
	nLfo	6
.loop:
	nOct	5

	nLpSet	2
-:
	nF	
	nRest	RLEN*2

	nPms	6
	nE
	nTie	RLEN*4
	nRest

	nPms	0
	nF
	nRest	RLEN*2

	nPms	6
	nE	RLEN*4

	nPms	0
	nF	
	nRest	RLEN*2

	nPms	6
	nE	RLEN*5
	nRest

	nPms	0
	nDs
	nRest	RLEN*2

	nPms	6
	nF	RLEN*4
	nPms	0

	nLpEnd	-
	nJump	.loop

trk_b:
	nInst	INST_GUITAR1
	nVol	7Fh
	nLength	RLEN
.loop:
	nOct	5

	nLpSet	2
-:
	nD	
	nRest	RLEN*2
	nC	RLEN*5
	nRest
	nD
	nRest	RLEN*2
	nC	RLEN*4

	nD	
	nRest	RLEN*2
	nC	RLEN*5
	nRest
	nC
	nRest	RLEN*2
	nD	RLEN*4
	nLpEnd	-
	nJump	.loop

trk_c:
	nInst	INST_GUITAR1
	nVol	7Fh
	nLength	RLEN
.loop:
	nOct	5
	nOctDn

	nLpSet	2
-:
	nAs	
	nRest	RLEN*2
	nG	RLEN*5
	nRest
	nAs
	nRest	RLEN*2
	nG	RLEN*4

	nAs	
	nRest	RLEN*2
	nG	RLEN*5
	nRest
	nGs
	nRest	RLEN*2
	nAs	RLEN*4
	nLpEnd	-
	nJump	.loop

trk_d:
	nInst	INST_BASS1
	nVol	7Fh
	nLength	RLEN
.loop:
	nOct	3
	nLpSet	2
-:
	nC
	nC
	nOctUp
	nC
	nOctDn
	nC
	nRest
	nC
	nOctUp
	nC
	nOctDn
	nC
	nLpEnd	-
	nJump	.loop

kk   = PCM_SLKICK2
sn   = PCM_SLSNARE2
hc   = PCM_SLHATC1
ho   = PCM_SLHATO1

;
; Drums
;
trk_drums:
	nVol	7Fh
	nPcmMode 1
	nLength RLEN
.loop:
	nLpSet 3
-:
	nPcmPlay kk
	nPcmPlay kk
	nPcmPlay sn
	nPcmPlay kk
	nPcmPlay kk
	nPcmPlay kk
	nPcmPlay sn
	nPcmPlay kk
	nRest
	nPcmPlay kk
	nPcmPlay sn
	nRest
	nPcmPlay kk
	nPcmPlay kk
	nPcmPlay sn
	nPcmPlay kk
	nLpEnd	-
	nJump	.loop

	nTrackFooter
