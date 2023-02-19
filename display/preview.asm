/*
mytris by pps

show preview
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm
;------------
	.proc set_preview
	.local nextframe
	mva #13 screen+403
	lda #10
	sta screen+404
	sta screen+405
	sta screen+406
	sta screen+407
	mva #15 screen+408
	lda #9
	sta screen+443
	sta screen+483
	sta screen+523
	lda #8
	sta screen+448
	sta screen+488
	sta screen+528
	mva #16 screen+563
	lda #14
	sta screen+564
	sta screen+565
	sta screen+566
	sta screen+567
	mva #17 screen+568
	.endl
	.local clear
	mwa #screen+444 copyto
;clear preview first
	ldx #2
lx	ldy #3
ly	lda #0
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	dex
	bpl lx
	.endl

	mwa #screen+444 copyto
	ldy next
	lda tbl_shape_l,y
	sta copyfrom
	lda tbl_shape_h,y
	sta copyfrom+1
los
;get x- and y-dimension
	ldy #0
	lda (copyfrom),y
	sta x
	iny
	lda (copyfrom),y
	sta y
	adw copyfrom #2

	ldx y			;height of shape
lx	ldy #0			;width of shape
ly	lda (copyfrom),y
	bne @+
	sta m
	eor (copyto),y
@	sta (copyto),y
	iny
	cpy x
	bcc ly
	adw copyto #40 copyto
	adw copyfrom x copyfrom
	dex
	bne lx

	rts
	.endp
;------------