SFX_START
;* Sound effects index  

sfx_data
	dta a(sfx_00)
	dta a(sfx_01)
	.wo sfx_02

;* Sound effects data 

sfx_00	ins 'menu-code_accepted.sfx'
sfx_01	ins 'game-select_unselect.sfx'
sfx_02	ins 'game-in_hole.sfx'

;* Initialise the SFX to play in memory once the joystick button is pressed, using the SFX index number

set_sfx_to_play
	lda #0
SfxIdx equ *-1
set_sfx_to_play_immediate
	asl @
	tax
	lda sfx_data,x
	sta sfx_src
	lda sfx_data+1,x
	sta sfx_src+1
	inc is_playing_sfx 
	lda #3
	sta sfx_channel
	lda #0
	sta sfx_offset
	rts

;-----------------

;* Play the SFX currently set in memory, one frame every VBI

play_sfx
	lda #$FF		; #$00 -> Play SFX until it's ended, #$FF -> SFX has finished playing and is stopped
is_playing_sfx equ *-1
	bmi play_sfx_done
	lda #2			; 2 frames
	sta is_playing_sfx
	lda #0
sfx_offset equ *-1
	asl @
	tax
	inc sfx_offset
	lda #0
sfx_channel equ *-1
	asl @
	tay
	bpl begin_play_sfx
play_sfx_loop
	inx
	iny
begin_play_sfx
        lda $ffff,x
sfx_src equ *-2
	sta SDWPOK0,y
	lda LZS.stereo
	beq mono
;---stereo
	lda SDWPOK0,y
	sta SDWPOK1,y
mono	dec is_playing_sfx
	bne play_sfx_loop
	lda SDWPOK0,y
	bne play_sfx_done
	dec is_playing_sfx
play_sfx_done
	rts
SFX_END