;
; Cave Story 'Labyrinth Fight'
;
	cpu		Z80
	dottedstructs	on
	include	"../../nezdrv/src/nvm_format.inc"
	include	"../../nezdrv/src/opn.inc"
	include	"pcm.inc"

MAIN_VOL = 77h
PSG_VOL = 0Dh
DAMP_VOL = MAIN_VOL-6
RLEN = 5  ; This is one row in the .xm file.
TEMPO = 0CCh

INST_CSBASS1_OCT = 0
INST_CSBASS1 = 1
INST_CSSAW1 = 2
INST_CSORGAN1 = 3
ENV_HAT_OPEN = 4
ENV_HAT_CLOSED = 5

;
; Header
;
	nTrackHeader TEMPO, trk_list, instruments_list

trk_list:
	nTrackRelPtr trk_bass   ; timing OK
	nTrackRelPtr trk_mel0   ; timing OK
	nTrackRelPtr trk_mel1   ; timing OK
	nTrackRelPtr trk_mel2
	nTrackRelPtr trk_mel3   ; timing OK
	nTrackRelPtr trk_drum_pcm

	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_drum_psg
	nTrackListEnd

;
; Instruments
;
instruments_list:
	nTrackRelPtr .inst_csbass1_oct
	nTrackRelPtr .inst_csbass1
	nTrackRelPtr .inst_cssaw1
	nTrackRelPtr .inst_csorgan1
	nTrackRelPtr .env_hat_open
	nTrackRelPtr .env_hat_closed
	nTrackListEnd

.inst_csbass1_oct:
	binclude "inst/csbass1_oct.bin"
.inst_csbass1:
	binclude "inst/csbass1.bin"
.inst_cssaw1:
	binclude "inst/cssaw1.bin"
.inst_csorgan1:
	binclude "inst/csorgan1.bin"
.env_hat_open:
	include "env/hat_open.s"
.env_hat_closed:
	include "env/hat_closed.s"

;
; Track Data
;

trk_unused:
	nStop

;
; Drums (pcm)
;
trk_drum_pcm:
	nVol	7Fh
	nPcmMode 1
	nLength	RLEN*2
.top:
	; Introduction (0-3,0-4)
	nCall	.pt1a
	nCall	.pt1b
	nCall	.pt1a
	nCall	.pt1c
	nCall	.pt1a
	nCall	.pt1b
	nCall	.pt1a
	nCall	.pt1d
	; Transition A (5-6)
	nCall	.pt2a
	nCall	.pt2b
	; Melody A (7-22)
	nLpSet	4
-:
	nCall	.pt1a
	nCall	.pt1b
	nCall	.pt1a
	nCall	.pt1c
	nLpEnd	-
	; Transition B (23-24)
	nCall	.pt4a
	nCall	.pt4b
	; Melody B (25-40)
	nCall	.pt1b  ; 25
	nCall	.pt5a  ; 26
	nCall	.pt1a  ; 27
	nCall	.pt5b  ; 28
	nCall	.pt1b  ; 29
	nCall	.pt5c  ; 30
	nCall	.pt5d  ; 31
	nCall	.pt1d  ; 32
	nCall	.pt1a  ; 33
	nCall	.pt1b  ; 34
	nCall	.pt1a  ; 35
	nCall	.pt5e  ; 36
	nCall	.pt1a  ; 37
	nCall	.pt1b  ; 38
	nCall	.pt5f  ; 39-40

	nJump	.top

.pt1a:
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSSNARE1
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nRest
	nRet

.pt1b:
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nRest
	nRet

.pt1c:
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSKICK1
	nVol	7Bh
	nPcmPlay PCM_CSSNARE1
	nVol	7Fh
	nPcmPlay PCM_CSSNARE1
	nRet

.pt1d:
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSKICK1
	nVol	7Fh
	nPcmPlay PCM_CSSNARE1
	nRest
	nRet

.pt2a:
	nPcmPlay PCM_CSSNARE1, RLEN*4  ; TODO: Should be a combo kick/snare
	nPcmPlay PCM_CSKICK1
	nVol	79h
	nPcmPlay PCM_CSSNARE1, RLEN
	nVol	7Fh
	nPcmPlay PCM_CSSNARE1, RLEN*3
	nPcmPlay PCM_CSKICK1
	nVol	7Bh
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nVol	7Fh
	nRet

.pt2b:
	nPcmPlay PCM_CSSNARE1, RLEN*6  ; TODO: combo kick/snare
	nVol	7Bh
	nPcmPlay PCM_CSSNARE1, RLEN*4  ; TODO: combo kick/snare
	nVol	7Fh
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSSNARE1
	nRet

.pt4a:
	nPcmPlay PCM_CSSNARE1
	nRest
	nPcmPlay PCM_CSKICK1, RLEN*6
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nRet

.pt4b:
	nPcmPlay PCM_CSSNARE1, RLEN*6  ; TODO: combo kick/snare
	nVol	7Bh
	nPcmPlay PCM_CSSNARE1, RLEN*4  ; TODO: combo kick/snare
	nVol	7Fh
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1, RLEN
	nVol	7Dh
	nPcmPlay PCM_CSSNARE1, RLEN
	nVol	7Fh
	nPcmPlay PCM_CSSNARE1
	nRet

.pt5a:
	nPcmPlay PCM_CSKICK1, RLEN*6
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1, RLEN*4
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nRet

.pt5b:
	nPcmPlay PCM_CSKICK1, RLEN*4
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSSNARE1, RLEN*4  ; TODO: combo kick/snare
	nPcmPlay PCM_CSSNARE1, RLEN  ; TODO: combo kick/snare
	nVol	7Ah
	nPcmPlay PCM_CSSNARE1, RLEN
	nVol	7Fh
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nRet

.pt5c:
	nLpSet	2
-:
	nPcmPlay PCM_CSKICK1, RLEN*4
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nLpEnd	-
	nRet

.pt5d:
	nLpSet	2
-:
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nLpEnd	-
	nRet

.pt5e:
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1, RLEN*4
	nPcmPlay PCM_CSSNARE1, RLEN*4  ; TODO: combo kick/snare
	nPcmPlay PCM_CSSNARE1, RLEN*4  ; TODO: combo kick/snare
	nRet

.pt5f:
	; 39
	nLpSet	2
-:
	nPcmPlay PCM_CSKICK1
	nVol	78h
	nPcmPlay PCM_CSSNARE1, RLEN
	nVol	7Bh
	nPcmPlay PCM_CSSNARE1, RLEN
	nVol	7Fh
	nPcmPlay PCM_CSSNARE1
	nLpEnd	-
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	; 40
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1, RLEN
	nPcmPlay PCM_CSSNARE1, RLEN*3
	nPcmPlay PCM_CSSNARE1

	nPcmPlay PCM_CSKICK1  ; TODO: slowed-down snare hits
	nPcmPlay PCM_CSKICK1  ; TODO: slowed-down snare hits
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSSNARE1
	nRet


;
; Drums (psg)
;
trk_drum_psg:
	nNoise	07h
	nOct	7
.top:
	nVol	PSG_VOL
	; Introduction (0-3, 0-4)
	nCall	.pt1a
	; Transition A (5-6)
	nCall	.transition_sub
	; Melody A (7-22)
	nCall	.mel_crash
	nLpSet	7
-:
	nCall	.mel_sub
	nLpEnd	-
	nCall	.mel_crash ; 15
	nLpSet	7          ; 16-22
-:
	nCall	.mel_sub
	nLpEnd	-
	; Transition B (23-24)
	nCall	.transition_sub
	; Melody B
	nCall	.pt4a  ; 25
	nCall	.pt4b  ; 26
	nCall	.pt4c  ; 27
	nCall	.pt4d  ; 28
	nCall	.pt4a  ; 29
	nCall	.pt4e  ; 30
	nCall	.pt4f  ; 31
	nCall	.pt4g  ; 32
	nCall	.pt1a
	nJump	.top

	; 8 measures of cymbal on the quarter notes
.pt1a:
	nInst	ENV_HAT_OPEN
	nLength	RLEN*4
	nLpSet	4*8
-:
	nB
	nLpEnd	-
	nRet

.pt4a:
	; 25
	nLength	RLEN*2
	nInst	ENV_HAT_OPEN
	nB
	nInst	ENV_HAT_CLOSED
	nB	RLEN
	nB	RLEN
	nB
	nB	RLEN*4
	nB	RLEN*4
	nB
	nRet
.pt4b:
	; 26
	nB
	nB	RLEN
	nB	RLEN*7
	nB	RLEN
	nB	RLEN*3
	nB
	nRet
.pt4c:
	; 27
	nB
	nB
	nRest
	nB
	nB
	nB
	nRest
	nB
	nRet

.pt4d:
	; 28
	nB
	nB	RLEN
	nB	RLEN
	nB	RLEN*4
	nB	RLEN*4
	nB	RLEN*4
	nRet

.pt4e:
	; 30
	nB
	nB	RLEN
	nB	RLEN*3
	nB
	nRest
	nB	RLEN
	nB	RLEN*3
	nB
	nRet

.pt4f:
	; 31
	nB
	nB
	nRest
	nB
	nB
	nB
	nRest
	nB
	nRet

.pt4g:
	nB
	nB	RLEN  ; TODO: this one is quieter
	nB	RLEN
	nB	RLEN*4
	nB	RLEN*3
	nB	RLEN*3
	nB
	nRet

; one measure of quarter note hat hits starting with an open hit
.mel_crash:
	nLength	RLEN*4
	nInst	ENV_HAT_OPEN
	nB
	nInst	ENV_HAT_CLOSED
	nLpSet	3
-:
	nB
	nLpEnd	-
	nRet

; one measure of quarter note hat hits
.mel_sub:
	nLength	RLEN*4
	nInst	ENV_HAT_CLOSED
	nLpSet	4
-:
	nB
	nLpEnd	-
	nRet


.transition_sub:
	nInst	ENV_HAT_OPEN
	nB	RLEN*10
	nB	RLEN*10
	nB	RLEN*8
	nB	RLEN*4
	nRet




;
; Melody (ch3)
;
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
	; Introduction (0-3, 0-4)
	nCall	.pt1a  ; 0, 2
	nCall	.pt1b  ; 1, 3, 4
	nLpEnd	-
	; Transition A (5-6)
	nCall	.pt2a
	nCall	.pt2b
	; Melody A (7-24)
	nCall	.pt3a  ; silence
	nOct	4
	nLpSet	2*2  ; 15-22
-:
	nCall	.pt1a  ; 0, 2
	nCall	.pt1b  ; 1, 3, 4
	nLpEnd	-

	; Transition B (23-24)
	nRest	RLEN*16  ; 23
	nRest	RLEN*16  ; 24

	; Melody B (25-40)
	nLpSet	2
-:
	nCall	.pt3b  ; 25
	nCall	.pt3c  ; 26
	nCall	.pt1a  ; 27
	nCall	.pt1b  ; 28
	nCall	.pt3b  ; 29
	nCall	.pt3c  ; 30
	nCall	.pt1a  ; 31
	nCall	.pt3d  ; 32
	nLpEnd	-
	nJump	.top

; Introduction
.pt1a:
	nLength	RLEN
	nVol	MAIN_VOL
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
; Transition
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
; Melody A
.pt3a:
	nLength	RLEN*16  ; 16 per measure
	nLpSet	8  ; 8 patterns
-:
	nOff
	nLpEnd	-
	nRet

.pt3b:
	nLength	RLEN*2

	nVol	MAIN_VOL
	nF
	nVol	DAMP_VOL
	nRest
	nOff	RLEN*4

	nVol	MAIN_VOL
	nF	RLEN

	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL

	nF
	nVol	DAMP_VOL
	nRest
	nOff
	nVol	MAIN_VOL
	nRet

.pt3c:
	nLength	RLEN
	nVol	MAIN_VOL
	nE
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL

	nLength	RLEN*2
	nE
	nVol	DAMP_VOL
	nRest
	nLpSet	2
-:
	nVol	MAIN_VOL
	nD
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nOff
	nVol	MAIN_VOL
	nRet

.pt3d:
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
	nG	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	nRet




;
; Melody (ch4)
;
trk_mel1:
	nCall	trk_mel_intro_init_sub
.top:
	nLpSet	2*2
-:
	nOct	4
	; Introduction (0-3, 0-4)
	nTrn	-3
	nCall	trk_mel0.pt1a
	nTrn	0
	nCall	.pt1b
	nLpEnd	-
	; Transition A (5-6)
	nTrn	-3
	nCall	trk_mel0.pt2a
	nTrn	0
	nCall	.pt2b
	; Melody A (7-14)
	nCall	trk_mel0.pt3a  ; silence
	nOct	4
	nLpSet	2*2  ; 15-22
-:
	nTrn	-3
	nCall	trk_mel0.pt1a  ; 0, 2
	nTrn	0
	nCall	.pt1b  ; 1, 3, 4
	nLpEnd	-
	; Transition B (23-24)
	nRest	RLEN*16
	nRest	RLEN*16
	; Melody B (25-40)
	nLpSet	2
-:
	nTrn	0
	nCall	trk_mel0.pt1a  ; 25
	nTrn	-2
	nCall	.pt1b          ; 26

	nTrn	-4
	nCall	trk_mel0.pt1a  ; 27
	nTrn	0
	nCall	.pt1b          ; 28
	nTrn	0
	nCall	trk_mel0.pt1a  ; 29
	nTrn	-2
	nCall	.pt1b          ; 30

	nTrn	-4
	nCall	trk_mel0.pt1a  ; 31
	nTrn	0
	nCall	.pt4a          ; 32
	nLpEnd	-
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
	nRet

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

.pt4a:
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
	nD	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	nRet



;
; Melody (ch5)
;
trk_mel2:
	nCall	trk_mel_intro_init_sub
.top:
	nOct	4
	; Introduction (0-3, 0-4)
	nCall	.intro_bulk
	nTrn	0
	nCall	.pt1c
	nCall	.intro_bulk
	nTrn	0
	nCall	.pt1d
	; Transition A (5-6)
	nTrn	9
	nCall	trk_mel0.pt2a
	nTrn	0
	nCall	.pt2b
	; Melody A (7-14) accompaniment
	nCall	.pt3a  ; 7
	nCall	.pt3b  ; 8
	nCall	.pt3c  ; 9
	nCall	.pt3d  ; 10

	nCall	.pt3b  ; 11
	nCall	.pt3e  ; 12
	nCall	.pt3f  ; 13, 14
	; 15-22 reprise the introduction
	nCall	.intro_bulk
	nTrn	0
	nCall	.pt1c
	nCall	.intro_bulk
	nTrn	0
	nCall	.pt1d

	; Transition B (23-24)
	nCall	.pt4a
	; Melody B (25-32)
	nLpSet	2
-:
	nTrn	6
	nCall	trk_mel0.pt3b  ; 25
	nTrn	0
	nCall	.pt5a          ; 26
	nTrn	5
	nCall	trk_mel0.pt1a  ; 27
	nTrn	0
	nCall	.pt1b          ; 28
	nLpEnd	-
	; 33-40 are a little different in a way that is unique to this channel
	nTrn	6
	nCall	trk_mel0.pt3b  ; 33
	nTrn	0
	nCall	.pt5b          ; 34
	nTrn	5
	nCall	trk_mel0.pt1a  ; 35
	nTrn	0
	nCall	.pt1b          ; 36

	nTrn	6
	nCall	trk_mel0.pt3b  ; 37
	nTrn	0
	nCall	.pt5b          ; 38
	nTrn	8
	nCall	trk_mel0.pt1a  ; 39
	nTrn	0
	nCall	.pt5c

	nJump	.top


.pt4a:
	nOctDn
	nLength	RLEN*2
	nVol	MAIN_VOL
	nLpSet	4
-:
	nOctUp
	nD
	nOctDn
	nG
	nLpEnd	-

	nLpSet	2
-:
	nOctUp
	nF
	nOctDn
	nG
	nLpEnd	-
	nF
	nF
	nE
	nD
	nOctUp
	nRet

.pt5a:
	nVol	MAIN_VOL
	nLength	RLEN*2
	nAs	RLEN
	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL
	nAs
.pt5a_join:
	nVol	DAMP_VOL
	nRest
	nLpSet	2
-:
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nOff	RLEN*2
	nVol	MAIN_VOL
	nRet

.pt5b:
	nVol	MAIN_VOL
	nLength	RLEN*2
	nB	RLEN
	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL
	nB
	nJump	.pt5a_join

.pt5c:
	nLength	RLEN*2
	nVol	MAIN_VOL
	nD	RLEN
	nVol	DAMP_VOL
	nRest	RLEN
	nVol	MAIN_VOL
	nD
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nD
	nVol	DAMP_VOL
	nRest
	nOctUp
	nLength	RLEN
	nLpSet	3
-:
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nOctDn
	nRet


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
	nOctDn
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
	nLength	RLEN
	nRest	RLEN*2
	nG
	nOff
	nOctUp
	nF
	nOff
	nOctDn
	nG	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
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
	nOctUp
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
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nOff	RLEN*14
	nRet

;
; Melody (ch6)
;
trk_mel3:
	nInst	INST_CSORGAN1
.top:
	; Introduction (0-4)
	nLpSet	3
-:
	nRest	RLEN*16
	nLpEnd	-
	nOct	4
	nCall	.pt1a  ; 3
	nLpSet	4+1  ; 4-5
-:
	nOff	RLEN*16
	nLpEnd	-
	; Last measure of transition (6)
	nOct	4
	nVol	MAIN_VOL
	nLength	RLEN*2
	nLpSet	3
-:
	nG
	nOff
	nLpEnd	-
	nG
	nA
	; Melody A (7-22)
	nCall	.pt3a    ; 7-9
	nCall	.pt1a    ; 10
	nCall	.pt3b    ; 11-12
	nCall	.pt3c    ; 13-14
	nCall	.pt3a    ; 15-17
	nCall	.pt1a    ; 18
	nCall	.pt3b    ; 19-20
	nCall	.pt3d    ; 21-22
	; Transition 2 (23-24)
	nRest	RLEN*16  ; 23 is just waiting
	nCall	.pt4a    ; 24
	; Melody B (25-40)
	nOff	RLEN*16  ; 25
	nRest	RLEN*16  ; 26
	nRest	RLEN*16  ; 27
	nCall	.pt4a    ; 28
	nOff	RLEN*16  ; 29
	nRest	RLEN*16  ; 30
	nRest	RLEN*16  ; 31
	nCall	.pt4b    ; 32
	nCall	.pt4c    ; 33
	nCall	.pt4d    ; 34
	nOff	RLEN*16  ; 35
	nRest	RLEN*16  ; 36
	nCall	.pt4c    ; 37
	nCall	.pt4d    ; 38
	nCall	.pt4e    ; 39
	nOff	RLEN*16  ; 40

	nJump	.top

.pt1a:
	nLength	RLEN
	nG	RLEN*2
	nOctUp

	nPanBoth
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest

	; Little creative license due to a lack of smooth panning.
	nLpSet	3
-
	nPanL
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nPanR
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nPanBoth
	nOctDn
	nOctDn
	nRet


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
	nRet

.pt3b:
	nLength	RLEN*2
	; Measure 4
	nOff
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
.pt3c_damp:
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

.pt4a:
	nLength	RLEN*2
	nLpSet	2
-:
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nVol	MAIN_VOL
	nG
	nG
	nFs
	nF
	nRet

.pt4b:
	nLength	RLEN*2
	nOff
	nVol	MAIN_VOL
	nPanBoth
	nOctUp
	nOctUp
	nC
	nOctDn
	nB
	nAs
	nG
	nFs
	nF
	nE
	nOctDn
	nRet

.pt4c:
	nLength	RLEN*2
	nPanR
	nAs
	nOff
	nPanBoth
	nA
	nG
	nPanL
	nOctUp
	nC
	nOff
	nOctDn
	nPanBoth
	nAs
	nA
	nRet

.pt4d:
	nLength	RLEN*2
	nPanR
	nG
	nOff
	nPanBoth
	nA
	nG
	nPanL
	nAs
	nOff
	nPanBoth
	nA
	nG
	nRet

.pt4e:
	nLength	RLEN*2
	nPanR
	nG
	nOff
	nPanBoth
	nA
	nG
	nPanL
	nAs
	nOff
	nPanBoth
	nOctUp
	nC
	nD
	nPanBoth
	nRet

.pt4f:
	nLength	RLEN*2
	nG
	nVol	DAMP_VOL
	nRest
	nOff	RLEN*14
	nVol	MAIN_VOL
	nRet





; Bassline
trk_bass:
	nLength	RLEN
	nVol	MAIN_VOL
.top:
	nOct	2
	; Introduction 0-3, 0-4
	nLpSet	2
-:
	nInst	INST_CSBASS1_OCT
	nCall	.pt1a  ; 0
	nCall	.pt1b  ; 1
	nCall	.pt1a  ; 2
	nCall	.pt1c  ; 3  sets instrument
	nLpEnd	-
	;  Transition (5-6)
	nCall	.pt1d
	; Melody A (7-14)
	nLpSet	2
-:
	nInst	INST_CSBASS1
	nCall	.pt1a  ; 7
	nCall	.pt1b  ; 8
	nCall	.pt1a  ; 9
	nCall	.pt1c  ; 10
	nLpEnd	-
	nLpSet	2  ; 15-22, basically the intro again.
-:
	nInst	INST_CSBASS1_OCT
	nCall	.pt1a  ; 15
	nCall	.pt1b  ; 16
	nCall	.pt1a  ; 17
	nCall	.pt1c  ; 18
	nLpEnd	-
	; Transition B (23-24)
	nCall	.pt1d  ; 23-24
	; Melody B (25-40)
	nInst	INST_CSBASS1
	nLpSet	4  ; 25-40
-:
	nCall	.pt4a
	nCall	.pt4b
	nCall	.pt4c
	nCall	.pt4d
	nLpEnd	-

	nJump	.top


.pt1a:
	nVol	MAIN_VOL
	nLength	RLEN*2
	nG
	nVol	DAMP_VOL
	nRest
	nOff	RLEN*4
	nVol	MAIN_VOL
	nG	RLEN
	nOff	RLEN
	nG
	nVol	DAMP_VOL
	nRest
	nOff
	nVol	MAIN_VOL
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
-:
	nVol	MAIN_VOL
	nC	RLEN*2
	nVol	DAMP_VOL
	nRest	RLEN*2
	nLpEnd	-
	nOff	RLEN*2
	nOctDn
	nRet

.pt1c:
	nLength	RLEN
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
	nRest
	nVol	MAIN_VOL
	nLpEnd	-
	nOctDn
	nLength	RLEN*2
	nB
	nA
	nRet

.pt4a:
	nLength	RLEN*2
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nOctUp
	nD
	nOctDn
	nG
	nOctUp
	nG
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nF
	nE
	nOctDn
	nRet

.pt4b:
	nLength	RLEN*2
	nG	RLEN*4
	nF
	nG
	nOctUp
	; TODO: ch6 needs to harmonize with FED here
	nAs
	nVol	DAMP_VOL
	nRest
	nVol	MAIN_VOL
	nA
	nG
	nOctDn
	nRet

.pt4c:
	nLength	RLEN
	nLpSet	2
-:
	nVol	MAIN_VOL
	nAs
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nRest	RLEN*2
	nOff	RLEN*2

	nOctUp
	nLpSet	2
-:
	nVol	MAIN_VOL
	nC
	nVol	DAMP_VOL
	nRest
	nLpEnd	-
	nRest	RLEN*2
	nOff	RLEN*2

	nOctDn
	nVol	MAIN_VOL
	nRet

.pt4d:  ; TODO: Need harmony up a fifth from this.
	nLength	RLEN
	nLpSet	2
-:
	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest
	nLpEnd	-

	nLength	RLEN*2
	nRest

	nVol	MAIN_VOL
	nG
	nVol	DAMP_VOL
	nRest

	nVol	MAIN_VOL
	nG
	nRest
	nVol	DAMP_VOL
	nRest
	nRet

	nTrackFooter
