/*
RMT2LZSS player based on rensoup and dmsc sources for DLI or VBI usage
call as often as needed to have the correct speed (e.g. 1 time/VBI for 50 or 60 Hz speed or 2 times/VBI for 100 or 120 Hz)
*/


.ifndef PLAYER				;compile to this address
PLAYER	= $9000
.endif
.ifndef POKEY
POKEY	= $d200
.endif
.ifndef POKEY2
POKEY2	= $d210
.endif

	org PLAYER
	.proc ZPLZS
/*
zero page vars
*/
	.zpvar .word SongPtr
	.zpvar .byte bit_data
	.endp

/*
vars
*/
SongIdx
	.byte 0
SongsSLOPtrs
	.byte .LO(Song0Start)
	.byte .LO(Song1Start)
SongsSHIPtrs
	.byte .HI(Song0Start)
	.byte .HI(Song1Start)
SongsSHIPtrs2

SongsELOPtrs
	.byte .LO(Song0End)
	.byte .LO(Song1End)
SongsEHIPtrs
	.byte .HI(Song0End)
	.byte .HI(Song1End)
/*
songs
*/
Song0Start
;        ins     'fefmsg.lzss'	;music file from RMT2LZSS
        ins     'braveheart_menu.lzss'	;music file from RMT2LZSS
Song0End
Song1Start
;        ins     'braveheart_menu.lzss'	;music file from RMT2LZSS
        ins     'braveheart_ingame.lzss'	;music file from RMT2LZSS
Song1End
/*
init once before play
*/
	.proc init_song
	jsr t_stereo
	bmi present
	mva #3 skctl			;init POKEY
	jmp w
present
	mva #3 skctl			;init POKEY
	sta skctl+16			;init 2nd POKEY
	mva #1 LZS.stereo
w	jsr SetNewSongPtrs		;call for initial song pointer
	rts
;---
t_stereo
	inc $d40e
	lda #$03
	sta $d21f
	sta $d210
	ldx #$00
	stx $d211
	inx
	stx $d21e

	ldx:rne $d40b

	stx $d219
loop	ldx $d40b
	bmi stop
	lda #$01
	bit $d20e
	bne loop

stop	lda $10
	sta $d20e
	dec $d40e

	txa
	rts
	.endp

/*
song pointer
	-SongSpeed must be 1 to work fine
*/
SongSpeed = 1// 1 = 50/60hz, 2 = 100/120hz, ..., -> 6

	.proc SetNewSongPtrs
	ldx SongIdx

	lda SongsSLOPtrs,x
	sta LZS.SongStartPtr
	lda SongsSHIPtrs,x
	sta LZS.SongStartPtr+1

	lda SongsELOPtrs,x
	sta LZS.SongEndPtr
	lda SongsEHIPtrs,x
	sta LZS.SongEndPtr+1

	rts
	.endp

/*
play routine
	-call this inside VBI or DLI
*/
	.proc play_song
	jsr setpokeyfull		; update the POKEY registers first, for both the SFX and LZSS music driver 
	lda tmucke	;1 := nur sfx
	bne w_back
	jsr LZSSPlayFrame		; Play 1 LZSS frame
 
;	lda LZS.stereo
;	beq mono
;stereo
	jsr LZSSUpdatePokeyRegisters

w_back	jsr play_sfx			; process the SFX data, if an index is queued and ready to play for this frame
	jsr LZSSCheckEndOfSong
	bne Continue
	lda #0
	sta LZS.Initialized
	jsr SetNewSongPtrs
Continue
	rts
/*		not needed anymore with new update routine
mono
	jsr LZSSUpdatePokeyRegisters_mono
	jmp w_back
*/
	.endp
;-----------------
;* Stop/Pause the player and reset the POKEY registers, a RTS will be found at the end of setpokeyfull further below 

	.proc stop_music
	lda #0			; default values
	ldy #8
stop_pause_reset_a 
	sta SDWPOK1,y
	sta SDWPOK0,y		; clear the POKEY values in memory 
	dey 
	bpl stop_pause_reset_a	; repeat until all channels were cleared	lda LZS.stereo
	.endp
;-----------------
* Setpokey, intended for double buffering the decompressed LZSS bytes as fast as possible for timing and cosmetic purpose

	.proc setpokeyfull
	lda POKSKC0 
	sta $D20F 
	ldy POKCTL0
	lda POKF0
	ldx POKC0
	sta $D200
	stx $D201
	lda POKF1
	ldx POKC1
	sta $D202
	stx $D203
	lda POKF2
	ldx POKC2
	sta $D204
	stx $D205
	lda POKF3
	ldx POKC3
	sta $D206
	stx $D207
	sty $D208

;* 0 == Mono, FF == Stereo, 1 == Dual Mono (only SwapBuffer is necessary for it) 
	lda LZS.stereo
	bne setpokeyfullstereo
	rts
	.endp
;------------
	.proc setpokeyfullstereo
	lda POKSKC1 
	sta $D21F 
	ldy POKCTL1
	lda POKF4
	ldx POKC4
	sta $D210
	stx $D211
	lda POKF5
	ldx POKC5
	sta $D212
	stx $D213
	lda POKF6
	ldx POKC6
	sta $D214
	stx $D215
	lda POKF7
	ldx POKC7
	sta $D216
	stx $D217
	sty $D218
	rts
	.endp
;-----------------
;* Left POKEY

SDWPOK0 
POKF0	dta $00
POKC0	dta $00
POKF1	dta $00
POKC1	dta $00
POKF2	dta $00
POKC2	dta $00
POKF3	dta $00
POKC3	dta $00
POKCTL0	dta $00
POKSKC0	dta $03	

;* Right POKEY

SDWPOK1	
POKF4	dta $00
POKC4	dta $00
POKF5	dta $00
POKC5	dta $00
POKF6	dta $00
POKC6	dta $00
POKF7	dta $00
POKC7	dta $00
POKCTL1	dta $00
POKSKC1	dta $03
;-----------------
/*
needed player routine
*/
	icl "playlzs16u_sfx.asm"