;
; Cave Story 'Labyrinth Fight'
;
	cpu		Z80
	dottedstructs	on
	include	"../../nezdrv/src/nvm_format.inc"
	include	"../../nezdrv/src/opn.inc"
	include	"pcm/pcm.inc"

MAIN_VOL = 7Ah
DAMP_VOL = MAIN_VOL-6
RLEN = 5
TEMPO = 0CCh

INST_CSBASS1_OCT = 0
INST_CSBASS1 = 1
INST_CSSAW1 = 2
INST_CSORGAN1 = 3

	nTrackHeader NEZ_PCMRATE_DEFAULT, TEMPO, trk_list, instruments_list

trk_list:
	nTrackRelPtr trk_bass
	nTrackRelPtr trk_mel0
	nTrackRelPtr trk_mel1
	nTrackRelPtr trk_mel2
	nTrackRelPtr trk_mel3
	nTrackRelPtr trk_unused

	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackListEnd

trk_unused:
	nStop

instruments_list:
	nTrackRelPtr .inst_csbass1_oct
	nTrackRelPtr .inst_csbass1
	nTrackRelPtr .inst_cssaw1
	nTrackRelPtr .inst_csorgan1
	nTrackListEnd

.inst_csbass1_oct:
	binclude "inst/csbass1_oct.bin"
.inst_csbass1:
	binclude "inst/csbass1.bin"
.inst_cssaw1:
	binclude "inst/cssaw1.bin"
.inst_csorgan1:
	binclude "inst/csorgan1.bin"

; Melody
trk_mel_intro_init_sub:
	nVol	MAIN_VOL
	nInst	INST_CSSAW1
	nRet

trk_mel0:
	nCall	trk_mel_intro_init_sub
.top:
	nLpSet	2*2
-:
	nOct	4
	; Introduction
	nCall	.pt1a
	nCall	.pt1b
	nLpEnd	-
	; Transition
	nCall	.pt2a
	nCall	.pt2b
	; Melody A

	nJump	.top

.pt1a:
	nVol	MAIN_VOL
	nLength	RLEN
	nD	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nOff	RLEN*4
	nVol	MAIN_VOL
	nLength	RLEN
	nD
	nOff
	nD	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nOff	RLEN*2
	nVol	MAIN_VOL
	nRet

.pt1b:
	nLength	RLEN
	nVol	MAIN_VOL
	nF
	nOff
	nF	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2

	nLpSet	2
-
	nVol	MAIN_VOL
	nE	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	NRet

.pt2a:
	nLength	RLEN*2
	nLpSet	4
-:
	nVol	MAIN_VOL
	nD
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nRet
	
.pt2b:
	nLength	RLEN
	nVol	MAIN_VOL
	nD
	nVol	DAMP_VOL
	nRest
	nLength	RLEN*2
	nVol	MAIN_VOL
	nD
	nLpSet	3
-:
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nD
	nLpEnd	-
	nRet


trk_mel1:
	nCall	trk_mel_intro_init_sub
.top:
	nLpSet	2*2
-:
	nOct	4
	; Introduction
	nTrn	-3
	nCall	trk_mel0.pt1a
	nTrn	0
	nCall	.pt1b
	nLpEnd	-
	; Transition
	nTrn	-3
	nCall	trk_mel0.pt2a
	nTrn	0
	nCall	.pt2b
	nJump	.top

.pt1b:
	nLength	RLEN
	nVol	MAIN_VOL
	nD
	nOff
	nD	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2

	nLpSet	2
-
	nVol	MAIN_VOL
	nC	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	NRet

.pt2b:
	nLength	RLEN*2
	nVol	MAIN_VOL
	nB
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nAs
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nA
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nRet


trk_mel2:
	nCall	trk_mel_intro_init_sub
.top:
	nOct	4
	; Introduction
	nCall	.intro_bulk
	nTrn	0
	nCall	.pt1c
	nCall	.intro_bulk
	nTrn	0
	nCall	.pt1d
	; Transition
	nTrn	9
	nCall	trk_mel0.pt2a
	nTrn	0
	nCall	.pt2b
	; Melody A
	nCall	.pt3a
	nCall	.pt3b
	nCall	.pt3c
	nCall	.pt3d

	nCall	.pt3b
	nCall	.pt3e
	nCall	.pt3f

	nJump	.top

.intro_bulk:
	nTrn	5
	nCall	trk_mel0.pt1a
	nTrn	0
	nCall	.pt1b
	nTrn	5
	nCall	trk_mel0.pt1a
	nRet
	

.pt1b:
	nLength	RLEN
	nVol	MAIN_VOL
	nAs
	nOff
	nAs	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nOctUp

	nLpSet	2
-
	nVol	MAIN_VOL
	nC	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	nOctDn
	NRet

.pt1c:
	nCall	.pt1cd_bulk
	nVol	MAIN_VOL
	nA
	nG
	nF
	nRet
	NRet

.pt1d:
	nCall	.pt1cd_bulk
	nVol	MAIN_VOL
	nLength	RLEN*2
	nA
	nVol	DAMP_VOL
	nRest
	nOff
	nRet

.pt1cd_bulk:
	nLength	RLEN
	nVol	MAIN_VOL
	nAs
	nOff
	nLength	RLEN*2
	nAs
	nVol	DAMP_VOL
	nRest

	nVol	MAIN_VOL
	nA
	nVol	DAMP_VOL
	nRest
	nRet

.pt2b:
	nLength	RLEN*2
	nVol	MAIN_VOL
	nOctUp
	nG
	nOctDn
	nG
	nOctUp
	nG
	nOctDn
	nG
	nOctUp
	nG	RLEN
	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL
	nG
	nFs
	nF
	nOctDn
	nRet

.pt3a:
	nLength	RLEN
	nG
	nOff
	nOctUp
	nD
	nOff
	nG
	nOff
	nOctDn
	nG
	nOff	RLEN*3

	nG
	nOff
	nOctUp
	nG
	nOff
	nOctDn
	nG
	nOff
	nRet

.pt3b:

	nLpSet	2
-
	nRest	RLEN*2
	nG
	nOff
	nOctUp
	nG
	nOff
	nOctDn
	nG
	nOff
	nLpEnd	-
	nRet

.pt3c:

	nRest	RLEN*2
	nG
	nOff
	nOctUp
	nF
	nOff
	nOctDn
	nG	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL

	nG
	nOff
	nOctUp
	nF
	nOff
	nOctDn
	nF	RLEN*2
	nRet

.pt3d:
	nG
	nOff
	nOctUp
	nF
	nOff
	nG
	nOff
	nOctDn
	nG
	nOff	RLEN*3
	nOctUp
	nF
	nOff
	nG
	nOff
	nOctDn
	nG
	nOff
	nRet

.pt3e:
	nRest	RLEN*2
	nG
	nOff
	nOctUp
	nG
	nOff
	nOctDn
	nG
	nOff	RLEN*3
	nG	RLEN*2
	nF	RLEN*2
	nG
	nOff
	nRet

	; Almost pt3c from mel3
.pt3f:
	nLength	RLEN*2
	nLpSet	2
-:
	nD
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nLpEnd	-

	nD	RLEN
	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL
	nD
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nD
	; Measure 7
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nOff	RLEN*14
	nRet

trk_mel3:
	nInst	INST_CSORGAN1
.top:
	; Introduction
	; Wait for most of introduction and transition
	nLpSet	8+1
-:
	nRest	RLEN*16
	nLpEnd	-
	nLength	RLEN*2
	; Last measure of transition
	nOct	4
	nVol	MAIN_VOL
	nLpSet	3
-:
	nG
	nOff
	nLpEnd	-
	nG
	nA
	; Melody A
	nCall	.pt3a
	nCall	.pt3b
	nCall	.pt3c
	nCall	.pt3a
	nCall	.pt3b
	nCall	.pt3d
	nJump	.top

.pt3a:
	nLength	RLEN*2
	; Measure 0
	nLpSet	2
-:
	nVol	MAIN_VOL
	nB
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nOctUp
	nVol	MAIN_VOL
	nC
	nD
	nVol	DAMP_VOL
	nRest
	nOctDn
	nVol	MAIN_VOL
	nB
	; Measure 1
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nB
	nA
	nG
	nOff
	nG
	nF
	nE
	; Measure 2
	nOctUp
	nD  ; TODO: original had a slight pan here
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL-3
	nE
	nD
	nF
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL-3
	nE
	nD
	; Measure 3 - Has a panning effect that requires assistance of mel1.
	nOctDn
	nG
	nLength	RLEN
	nOctUp

	nPanL
	nVol	MAIN_VOL-(0)
	nG	
	nVol	DAMP_VOL-(0)
	nRest
	nVol	MAIN_VOL-(1)
	nG	
	nVol	DAMP_VOL-(1)
	nRest
	nVol	MAIN_VOL-(2)
	nG	
	nVol	DAMP_VOL-(2)
	nRest
	nVol	MAIN_VOL-(3)
	nG	
	nVol	DAMP_VOL-(3)
	nRest
	nVol	MAIN_VOL-(4)
	nG	
	nVol	DAMP_VOL-(4)
	nRest
	nVol	MAIN_VOL-(5)
	nG	
	nVol	DAMP_VOL-(5)
	nRest
	nVol	MAIN_VOL-(6)
	nG	
	nVol	DAMP_VOL-(6)
	nRest
	nRet

.pt3b:
	nLength	RLEN*2
	nPanBoth
	; Measure 4
	nOff
	nOctDn
	nVol	MAIN_VOL
	nB
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nB
	nOctUp
	nC
	nD
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nD
	; Measure 5
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nD
	nC
	nOctDn
	nB
	nOff
	nOctUp
	nOctUp
	nD
	nC
	nOctDn
	nB
	nOctDn
	nRet

	; Measure 6 - also used by mel2, transposed.
.pt3c:
	nLength	RLEN*2
	nLpSet	2
-:
	nG
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nLpEnd	-
	nG
	nF
.pt3c_end:
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nG
	; Measure 7
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nOff	RLEN*14
	nRet

	; Measure 6 variant.
.pt3d:
	nLength	RLEN*2
	nLpSet	2
-:
	nG
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nLpEnd	-
	nG
	nAs
	nJump	.pt3c_end


; Bassline
trk_bass:
	nLength	RLEN
	nVol	MAIN_VOL
.top:
	nOct	2
	nLpSet	2
-:
	nCall	.pt1a
	nCall	.pt1b
	nCall	.pt1a
	nCall	.pt1c
	nLpEnd	-
	nCall	.pt1d

	nJump	.top


.pt1a:
	nLength	RLEN
	nInst	INST_CSBASS1_OCT
	nVol	MAIN_VOL
	nG	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nOff	RLEN*4
	nVol	MAIN_VOL
	nG
	nOff
	nG	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nOff	RLEN*2
	nRet

.pt1b:
	nLength	RLEN
	nVol	MAIN_VOL
	nAs
	nOff
	nAs	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nOctUp
	nLpSet	2
-
	nVol	MAIN_VOL
	nC	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	nOctDn
	nRet

.pt1c:
	nVol	MAIN_VOL
	nF
	nOff
	nF	RLEN*4
	nLength	RLEN*2
	nE
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nE
	nInst	INST_CSBASS1
	nD
	nC
	nRet

.pt1d:
	nOctUp
	nLength	RLEN*2
	nLpSet	4
-:
	nInst	INST_CSBASS1_OCT
	nC
	nOctDn
	nInst	INST_CSBASS1
	nC
	nOctUp
	nLpEnd	-

	nVol	MAIN_VOL
	nLpSet	2
-:
	nInst	INST_CSBASS1_OCT
	nD
	nOctDn
	nInst	INST_CSBASS1
	nD
	nOctUp
	nLpEnd	-
	nInst	INST_CSBASS1_OCT

	nLength	RLEN
	nLpSet	2
-:
	nC
	nVol	DAMP_VOL
	nRest	RLEN*2
	nVol	MAIN_VOL
	nLpEnd	-
	nOctDn
	nB	RLEN*2
	nA	RLEN*2
	nRet

	nTrackFooter
