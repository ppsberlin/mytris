/*
mytris by pps

nmi
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm

;------------
	.proc dli
	sta regA
	mva >fnt chbase
	lda #@gtictl(mode10)
	sta wsync
	sta gtictl
	lda #white
	sta colbak
	lda orange
	sta color2
	lda regA
	rti
	.endp
;------------
	.proc vbi
	mwa #dli 512
	inc main.ttris_mode.ps		;"clock" for 1 vbi delay in tetris alike mode
	lda main.ttris_mode.ps
	bmi @+
	mva #0 main.ttris_mode.ps
@	lda #black
	sta colpm0
	sta colbak
	lda red
	sta colpm1
	lda purple
	sta colpm2
	lda blue
	sta colpm3
	lda blue2
	sta color0
	lda green
	sta color1
	lda orange
	sta color2
	lda yellow
	sta color3
	lda last		;game over?
	beq @+
	lda red
	and #$f2
	sta colpm0
@	lda paused		;game paused?
	beq @+
	lda #4
	sta colpm0
@	lda playmus
	beq nomus
	jsr mukke
nomus	lda eingabe
	cmp #keyb
	beq key			;keyboard
	jsr joytest
	jmp w_
key	jsr keytest
w_	lda joy0
	cmp #5
	bne ww
	mva #1 drop
	mva #0 joy0
ww	jmp xitvbv
	.endp
;------------
	.proc mukke
	lda sixtyhz
	beq itspal
*------ ntsc, so we have to use the counter
	lda count_s
	beq reset_count
	dec count_s
itspal
; go for the music
	jsr play_song	;play the song
	rts
reset_count
	mva #5 count_s
	rts
	.endp
;------------