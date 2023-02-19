/*
mytris by pps

game over + clear screen
*/
;	@com.wudsn.ide.asm.mainsourcefile=mytris.asm
;------------
	.proc spielende
	mwa #screen+2*40+14 copyto
	mwa #g_over copyfrom
	ldx #22
lx	ldy #11
ly	lda (copyfrom),y
	beq @+
	sta (copyto),y
@	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #12 copyfrom
	dex
	bpl lx

	lda gamemode
	beq mytris
;tetris alike mode
	cpw most2 linien
	bcs w
	mwa linien most2
w	cpd today2 punkte
	bcs w0
	mwa punkte today2
	mwa punkte+2 today2+2
w0	cpw mttris2 tetris
	bcs w_
	mwa tetris mttris2
	jmp w_
mytris
;--- best of today?
	cpw most linien
	bcs w1
	mwa linien most
w1	cpd today punkte
	bcs w2
	mwa punkte today
	mwa punkte+2 today+2
w2	cpw mttris tetris
	bcs w_
	mwa tetris mttris
w_
	mva #0 19
	sta 20
@	lda trig0
	beq pressed
	lda 19
	cmp #3
	bne @-
ww	jsr clear_screen
	jmp main.spielbeginn
pressed
l_t0	lda trig0	;Trigger erst wieder loslassen
	beq l_t0
	jmp ww
	.endp
;------------
	.proc clear_screen
	mwa #screen+26*40+13 test
	ldx #26
lx	ldy #13
ly	lda #0
	sta (test),y
	dey
	bpl ly
	sbw test #40 test
	dex
	bpl lx
	rts
	.endp
;------------