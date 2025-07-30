	cpu		Z80
	dottedstructs	on
	include	"../../nezdrv/src/nvm_format.inc"
	include	"../../nezdrv/src/opn.inc"
	include	"pcm/pcm.inc"


MAIN_VOL = 74h
; typical rest value
RLEN = 12
; stecatto hit
RSTEC = RLEN/4
; rest following stecatto
RSTECOFF = RSTEC*3

TEMPO = 0CCh

INST_BASS1 = 0
INST_GUITAR1 = 1
INST_WEIRDPUYO = 2
INST_BASS2 = 3
INST_BRASS1 = 4
INST_PSG0 = 5

	nTrackHeader TEMPO, trk_list, instruments_list

trk_list:
	nTrackRelPtr trk_a
	nTrackRelPtr trk_b
	nTrackRelPtr trk_c
	nTrackRelPtr trk_d
	nTrackRelPtr trk_e
	nTrackRelPtr trk_drums

	nTrackRelPtr trk_unused; trk_g
	nTrackRelPtr trk_unused; trk_h
	nTrackRelPtr trk_unused
	nTrackRelPtr trk_unused
	nTrackListEnd

trk_unused:
	nStop

instruments_list:
	nTrackRelPtr .inst_bass1
	nTrackRelPtr .inst_guitar1
	nTrackRelPtr .inst_weirdpuyo
	nTrackRelPtr .inst_bass2
	nTrackRelPtr .inst_brass1
	nTrackRelPtr .env_psg0
	nTrackListEnd

.inst_bass1:
	include	"inst/bass1.s"
.inst_guitar1:
	include	"inst/guitar1.s"
.inst_weirdpuyo:
	include	"inst/weirdpuyo.s"
.inst_bass2:
	include	"inst/bass2.s"
.inst_brass1:
	include	"inst/brass1.s"
.env_psg0:
	db	0Fh
	db	0Eh
	db	0Eh
	db	0Dh
	db	0Ch
	db	0Bh
	db	0Ah
	db	09h
	db	08h
	db	NVM_MACRO_LPSET
	db	08h
	db	07h
	db	06h
	db	05h
	db	04h
	db	03h
	db	04h
	db	05h
	db	06h
	db	07h
	db	NVM_MACRO_LPEND
	db	8,9,10,11,12,13,14,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
	db	NVM_MACRO_END

; Mostly backs the FM4/5 parts
trk_g:
	nInst	INST_PSG0
	nVol	0Eh
.loop:
	nOct	2
	nCall	trk_d.pt1_body
	nOctUp
	nCall	trk_d.pt1_body
	nCall	trk_b.pt2_body
	nCall	trk_b.pt2_body
	nCall	trk_b.pt2_body
	nCall	trk_b.pt2_body
	nJump	.loop

; Mostly backs the FM4/5 parts
trk_h:
	nInst	INST_PSG0
	nVol	0Eh
.loop:
	nOct	2
	nCall	trk_e.pt1_body
	nOctUp
	nCall	trk_e.pt1_body
	nCall	trk_c.pt2_body
	nCall	trk_c.pt2_body
	nCall	trk_c.pt2_body
	nCall	trk_c.pt2_body
	nJump	.loop
;
; Bassline
;

trk_bass_init_sub:
	nInst	INST_BASS1
	nLength	RLEN
	nOct	2
	nVol	MAIN_VOL
	nLfo	03h
	nRet

trk_a:
	nCall	trk_bass_init_sub
.start:
	;nCall	.pt1
.loop:
	nCall	.pt1
	nCall	.pt1
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nCall	.pt3
	nJump	.loop

.pt1:
	nCall	.pt1a
	nCall	.pt1b
	nCall	.pt1a
	nJump	.pt1c

.pt1a:
	nLpSet	3
-:
	nG
	nG RSTEC
	nOff RSTECOFF
	nLpEnd	-

	nOctUp
	nG
	nOctDn
	nG
	nRet

.pt1b:
	nLpSet	3
-:
	nG
	nG	RSTEC
	nOff	RSTECOFF
	nLpEnd	-

	nOctUp
	nG
	nOctDn
	nF
	nRet

.pt1c:
	nLpSet	2
-:
	nF
	nOctUp
	nF	RSTEC
	nOff	RSTECOFF
	nF
	nOctDn
	nLpEnd	-
	nF
	nOctUp
	nF
	nOctDn
	nRet

.pt2:
	nCall	.pt2a
	nJump	.pt2b

.pt2a:
	nEb
	nBb
	nOctUp
	nEb
	nOctDn
	nEb

	nF
	nOctUp
	nC
	nF
	nOctDn
	nF

	nG
	nOctUp
	nD
	nG
	nOctDn
	nG	RLEN*2

	nG
	nOctUp
	nG
	nOctDn
	nG
	nRet

.pt2b:
	nEb
	nOctUp
	nEb
	nOctDn
	nEb
	nF	RLEN*2

	nOctUp
	nF
	nOctDn
	nF
	nG	RLEN*2

	nOctUp
	nG
	nOctDn
	nG
	nOctUp
	nC
	nOctDn
	nG
	nOctUp
	nB
	nG
	nD
	nOctDn
	nRet

.pt3:
	nCall	.pt2a

	nEb
	nBb
	nOctUp
	nEb
	nOctDn
	nEb

	nF
	nOctUp
	nC
	nF
	nOctDn
	nF

	nD
	nD
	nOctUp
	nD
	nOctDn
	nD
	nOctUp
	nC
	nD
	nA
	nD
	nOctDn
	nRet

;
; B and C
;

trk_lead_guitar_init:
	nVol	MAIN_VOL
	nOct	6
	nLength RLEN
	nRet

trk_intro_wait_sub:
	nLpSet	4
-:
	nRest	RLEN*8
	nLpEnd -
	nRet

trk_c:
	;nCall	trk_intro_wait_sub
.loop:
	nCall	trk_lead_guitar_init
	nPanL
	nOct	7
	nInst	INST_GUITAR1
	nCall	trk_b.pt1
	nCall	trk_b.pt1
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nJump	.loop

.pt2:
	nInst	INST_WEIRDPUYO
.pt2_body:
	nOct	4
	nG
	nA	RSTEC
	nOff	RSTECOFF
	nAs	RSTEC
	nOff	RSTECOFF
	nA	RLEN*2

	nF
	nC	RSTEC
	nOff	RSTECOFF
	nA	RLEN*2

	nB
	nA	RSTEC
	nOff	RSTECOFF
	nG	RLEN*2

	nD
	nD
	nF
	nG
	nA	RSTEC
	nOff	RSTECOFF
	nAs	RSTEC
	nOff	RSTECOFF
	nA	RLEN*2

	nF
	nC	RSTEC
	nOff	RSTECOFF
	nG
	nRest	RLEN*4

	nOff	RLEN*4
	nRet


trk_b:
	;nCall	trk_intro_wait_sub
	; Wait for bass opening
.loop:
	nCall	trk_lead_guitar_init
	nPanR
	nInst	INST_GUITAR1
	nCall	.pt1
	nCall	.pt1
	nInst	INST_BRASS1
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2  ; pt3
	nJump	.loop

.pt1:
	; TODO: Vibrato
	nC
	nPms	6
	nRest
	nPms	0
	nOctDn
	nB
	nOff
	nOctUp
	nC
	nD
	nOff
	nC
	nOff
	nOctDn
	nB
	nOctUp
	nOff

	nC
	nPms	6
	nRest
	nPms	0

	nOctDn
	nB
	nG
	nF
	nOctUp

	nC
	nPms	6
	nRest
	nPms	0

	nOctDn
	nB
	nOff
	nOctUp
	nC
	nD
	nOff
	nC
	nPms	6
	nRest
	nPms	0
	nOctDn
	nB
	nG
	nF	RLEN*3
	nF
	nG
	nOctUp
	nRet


.pt2:
	nOct	5
.pt2_body:
	nAs
	nOctUp
	nC	RSTEC
	nOff	RSTECOFF
	nD	RSTEC
	nOff	RSTECOFF
	nC	RLEN*2

	nOctDn
	nA
	nF	RSTEC
	nOff	RSTECOFF
	nOctUp
	nC	RLEN*2

	nD
	nC	RSTEC
	nOff	RSTECOFF
	nOctDn
	nB	RLEN*2

	nG
	nG
	nA
	nAs
	nOctUp
	nC	RSTEC
	nOff	RSTECOFF
	nD	RSTEC
	nOff	RSTECOFF
	nC	RLEN*2

	nOctDn
	nA
	nF	RSTEC
	nOff	RSTECOFF
	nB
	nRest	RLEN*4

	nOff
	nG	RSTEC
	nOff	RSTECOFF
	nG
	nA	RSTEC
	nOff	RSTECOFF
	nRet


;
; D and E
;

trk_backing_init:
	nVol	MAIN_VOL
	nLength	RLEN
	nRet

trk_d:
	nCall	trk_backing_init
	nPanL
.loop:
	nCall	.pt1
	nCall	.pt1
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nJump	.loop

.pt1:
	nOct	4
	nInst	INST_WEIRDPUYO
.pt1_body:
	nLpSet	8
-:
	nOff
	nD
	nF
	nG
	nLpEnd	-
	nRet

.pt2:
	nOct	4
	nInst	INST_BASS2
	nLpSet	2
-:
	nG
	nG	RSTEC
	nOff	RSTECOFF
	nLpEnd	-

	nA
	nB	RSTEC
	nOff	RSTECOFF
	nOctUp
	nC	RSTEC
	nOff	RSTECOFF
	nOctDn
	nA
	nRest	; TODO: Vib
	nA
	nOff
	nG
	nRest	;TODO: vib

	nLpSet	3
-:
	nG	RSTEC
	nOff	RSTECOFF
	nLpEnd	-

	nLpSet	2
-:
	nG
	nG	RSTEC
	nOff	RSTECOFF
	nLpEnd	-

	nA
	nB	RSTEC
	nOff	RSTECOFF
	nOctUp
	nC	RSTEC
	nOff	RSTECOFF
	nOctDn
	nG
	nRest	RLEN*3  ; TODO: vib
	nOff	RLEN

	nRest

	nLpSet	3
-:
	nG	RSTEC
	nOff	RSTECOFF
	nLpEnd	-
	nRet

trk_e:
	nCall	trk_backing_init
	nPanR
.loop:
	nCall	.pt1
	nCall	.pt1
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nCall	.pt2
	nJump	.loop

.pt1:
	nOct	4
	nInst	INST_WEIRDPUYO
.pt1_body:
	nLpSet	8
-:
	nF
	nG
	nOff
	nD
	nLpEnd	-
	nRet

.pt2:
	nOct	5
	nInst	INST_GUITAR1
	nLpSet	2
-:
	nDs
	nDs	RSTEC
	nOff	RSTECOFF
	nLpEnd	-

	nC
	nC	RSTEC
	nOff	RSTECOFF
	nOctUp
	nC	RSTEC
	nOff	RSTECOFF
	nOctDn
	nC
	nRest	; TODO: Vib
	nC
	nOff
	nOctDn
	nB
	nRest	;TODO: vib

	nOctUp
	nC	RSTEC
	nOff	RSTECOFF
	nD	RSTEC
	nOff	RSTECOFF
	nD	RSTEC
	nOff	RSTECOFF

	nLpSet	2
-:
	nDs
	nDs	RSTEC
	nOff	RSTECOFF
	nLpEnd	-

	nC
	nC	RSTEC
	nOff	RSTECOFF
	nC	RSTEC
	nOff	RSTECOFF
	nOctDn
	nB
	nRest	RLEN*3  ; TODO: vib
	nOff	RLEN
	nOctUp

	nRest

	nC	RSTEC
	nOff	RSTECOFF
	nD	RSTEC
	nOff	RSTECOFF
	nD	RSTEC
	nOff	RSTECOFF

	nRet





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
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSSNARE1
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nRest
	nLpEnd	-
	nPcmPlay PCM_CSKICK1
	nRest
	nPcmPlay PCM_CSSNARE1
	nRest
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSKICK1
	nPcmPlay PCM_CSSNARE1
	nPcmPlay PCM_CSSNARE1
	nJump	.loop

	nTrackFooter
