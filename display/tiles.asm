/*
mytris by pps

paint tiles
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm
;------------
	.proc get_tile
	ldy m_shape
	lda direction
	cmp #3
	bne td2
;direction 3
	lda tbl_shape_l3,y
	sta copyfrom
	lda tbl_shape_h3,y
	sta copyfrom+1
	jmp los
td2	cmp #2
	bne td1
;direction 2
	lda tbl_shape_l2,y
	sta copyfrom
	lda tbl_shape_h2,y
	sta copyfrom+1
	jmp los
td1	cmp #1
	bne dir0
	lda tbl_shape_l1,y
	sta copyfrom
	lda tbl_shape_h1,y
	sta copyfrom+1
	jmp los
dir0	;direction 0
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

;xmax
	lda #27
	sub x
	sta xmax

;correct xpos
	lda xpos
	cmp xmax
	bcc @+
	mva xmax xpos
@
	rts
	.endp
;------------
	.proc tbl_shape_l
	dta <shape.one,<shape.two,<shape.three,<shape.four,<shape.five,<shape.six,<shape.seven,<shape.eight,<shape.nine,<shape.ten,<shape.eleven,<shape.twelve,<shape.thirteen
	.endp
;------------
	.proc tbl_shape_h
	dta >shape.one,>shape.two,>shape.three,>shape.four,>shape.five,>shape.six,>shape.seven,>shape.eight,>shape.nine,>shape.ten,>shape.eleven,>shape.twelve,>shape.thirteen
	.endp
;------------
	.proc tbl_shape_l1
	dta <shape.one1,<shape.two1,<shape.three1,<shape.four1,<shape.five1,<shape.six1,<shape.seven,<shape.eight1,<shape.nine,<shape.ten1,<shape.eleven1,<shape.twelve1,<shape.thirteen1
	.endp
;------------
	.proc tbl_shape_h1
	dta >shape.one1,>shape.two1,>shape.three1,>shape.four1,>shape.five1,>shape.six1,>shape.seven,>shape.eight1,>shape.nine,>shape.ten1,>shape.eleven1,>shape.twelve1,>shape.thirteen1
	.endp
;------------
	.proc tbl_shape_l2
	dta <shape.one,<shape.two2,<shape.three2,<shape.four,<shape.five,<shape.six2,<shape.seven,<shape.eight2,<shape.nine,<shape.ten2,<shape.eleven2,<shape.twelve2,<shape.thirteen
	.endp
;------------
	.proc tbl_shape_h2
	dta >shape.one,>shape.two2,>shape.three2,>shape.four,>shape.five,>shape.six2,>shape.seven,>shape.eight2,>shape.nine,>shape.ten2,>shape.eleven2,>shape.twelve2,>shape.thirteen
	.endp
;------------
	.proc tbl_shape_l3
	dta <shape.one1,<shape.two3,<shape.three3,<shape.four1,<shape.five1,<shape.six3,<shape.seven,<shape.eight3,<shape.nine,<shape.ten3,<shape.eleven3,<shape.twelve3,<shape.thirteen1
	.endp
;------------
	.proc tbl_shape_h3
	dta >shape.one1,>shape.two3,>shape.three3,>shape.four1,>shape.five1,>shape.six3,>shape.seven,>shape.eight3,>shape.nine,>shape.ten3,>shape.eleven3,>shape.twelve3,>shape.thirteen1
	.endp
;------------
	.proc set_shape	;+test below
	mva #0 stop
	mwa #screen copyto

	jsr get_tile

	mva xpos clear_shape.lastx
	mva ypos clear_shape.lasty
	mva direction clear_shape.lastdir

	ldy ypos
	beq w
@	adw copyto #40 copyto
	dey
	bne @-
w	adw copyto xpos copyto

	.local test_last
;test last	-> Ist da wo ich hinmalen will schon was?
	mwa copyto test
	lda ypos
	bne keinEnde
	ldx #0
lx	ldy #0
ly	lda (test),y
	beq @+
;	cmp #8		;7 war größtes Zeichen vom Teil
;	bcs @+
	mva #1 last
@	iny
	cpy x
	bcc ly
	adw test #40 test
	inx
	cpx y
	bcc lx
	.endl
keinEnde

	mwa copyfrom mfrom
	mwa copyto mto

	.local test_ohne_malen
	ldx y			;height of shape
lx	ldy #0			;width of shape
ly	lda (copyfrom),y
	beq w_
	sta m
	eor (copyto),y
	cmp m
	beq w_
	lda ypos		;wenn wir noch oben sind, ist game over
	beq w__			;so wird noch gemalt (war jeq spielende)
	jmp undo
w_	iny
	cpy x
	bcc ly
	adw copyto #40 copyto
	adw copyfrom x copyfrom
	dex
	bne lx
	.endl
w__	
	mwa mfrom copyfrom
	mwa mto copyto
	adw copyto #40 test

	ldx y			;height of shape
lx	ldy #0			;width of shape
ly	lda (copyfrom),y
	beq w_
	sta (copyto),y
	lda (test),y
	beq w_			;hier ist nichts
	inc stop
w_	iny
	cpy x
	bcc ly
	adw copyto #40 copyto
	adw test #40 test
	adw copyfrom x copyfrom
	dex
	bne lx
	lda last
	beq @+
	jmp spielende
@	mva #0 joy0		;reset joy0 for keyboard
	rts
;----------
	.local undo
	lda joy0
	cmp #1
	bne re
;li
	inc xpos
	dec y
	jmp set_shape
re	cmp #2
	bne dreh
	dec xpos
	jmp set_shape
dreh
	cmp #3
	bne links
;rechts
	dec direction
	lda direction
	bpl @+
	mva #3 direction
@	jmp set_shape
links
	inc direction
	lda direction
	cmp #4
	bne @+
	mva #0 direction
@	jmp set_shape
	.endl
;----------
mfrom	.he 00 00
mto	.he 00 00
	.endp
;------------
	.proc clear_shape
	mwa #screen copyto
	ldy lasty
	beq w
lp	adw copyto #40 copyto
	dey
	bne lp
w	adw copyto lastx copyto

;---
	ldy m_shape
	lda lastdir
	cmp #3
	bne td2
;direction 3
	lda tbl_shape_l3,y
	sta copyfrom
	lda tbl_shape_h3,y
	sta copyfrom+1
	jmp los
td2	cmp #2
	bne td1
;direction 2
	lda tbl_shape_l2,y
	sta copyfrom
	lda tbl_shape_h2,y
	sta copyfrom+1
	jmp los
td1	cmp #1
	bne dir0
	lda tbl_shape_l1,y
	sta copyfrom
	lda tbl_shape_h1,y
	sta copyfrom+1
	jmp los
dir0	;direction 0
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
;---
	ldx y
lx	ldy #0
ly	lda (copyfrom),y
	beq @+
	lda #0
	sta (copyto),y
@	iny
	cpy x
	bcc ly
	adw copyto #40 copyto
	adw copyfrom x copyfrom
	dex
	bne lx
	rts
;---
lasty	.he 00
lastx	.he 00 00
lastdir	.he 00
	.endp
;------------