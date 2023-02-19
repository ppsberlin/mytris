/*
mytris by pps

paint big numbers on game screen
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm
;------------
	.proc paint_eins
	mwa #eins copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_zwei
	mwa #zwei copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_drei
	mwa #drei copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_vier
	mwa #vier copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_fuenf
	mwa #fuenf copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_sechs
	mwa #sechs copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_sieben
	mwa #sieben copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_acht
	mwa #acht copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_neun
	mwa #neun copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_null
	mwa #null copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc paint_levelx
	mwa #levelx copyfrom
	jsr do_paint
	rts
	.endp
;------------
	.proc do_paint
	ldx #1
lx	ldy #1
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #2 copyfrom
	dex
	bpl lx
	rts
	.endp
;------------