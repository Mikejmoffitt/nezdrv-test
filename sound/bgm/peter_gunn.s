	cpu		Z80
	dottedstructs	on
	include	"../../nezdrv/src/nvm_format.inc"
	include	"../../nezdrv/src/opn.inc"



;
; Test track. It's Freddie Hubbard's "Straight Life".
;

TEST_LENGTH = 6
TEST_TIMER = 0C0h

	nTrackHeader TEST_TIMER, .track_list, .instruments_list

.track_list:
	nTrackRelPtr track_pg_bass
	nTrackRelPtr track_pg_bass_octup
	nTrackRelPtr track_pg_unused
	nTrackRelPtr track_pg_unused
	nTrackRelPtr track_pg_unused
	nTrackRelPtr track_pg_unused

	nTrackRelPtr track_pg_unused
	nTrackRelPtr track_pg_unused
	nTrackRelPtr track_pg_unused
	nTrackRelPtr track_pg_unused
	nTrackListEnd

.instruments_list:
	nTrackRelPtr .inst0_bass
	nTrackListEnd

.inst0_bass:
	include	"inst/bass1.s"


;
;
;
track_pg_unused:
	nStop


track_pg_bass_init_sub:
	nInst	0
	nLength	TEST_LENGTH
	nOct	2
	nVol	7Fh
	nRet

track_pg_bass_octup:
	nCall	track_pg_bass_init_sub
	nOctUp
	nJump	track_pg_bass.start

track_pg_bass:
	nCall	track_pg_bass_init_sub
.start:
	nG
	nOff
	nG
	nOff
	nA
	nOff
	nG
	nOff
	nAs
	nOff
	nG
	nOff
	nOctUp
	nC  TEST_LENGTH
	nRest
	nOctDn
	nB
	nOff
	nJump	.start

	nTrackFooter
