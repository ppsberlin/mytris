/*
mytris by pps

tile is down and we test, if rows are finished and points are added
*/
;	@com.wudsn.ide.asm.mainsourcefile=mytris.asm
;------------
	.proc test_rows
	mwa #screen+26*40+13 test
	mva #0 reihen
	ldx #26
lx	mva #0 zaehl
	ldy #13
ly	lda (test),y
	beq @+		;-> 0 := empty char
	inc zaehl
@	dey
	bpl ly
	lda zaehl
	cmp #14		;-> 14 := row is full
	bne nix
	inc reihen	;-> count up rows
	mwa test copyto
	dew copyto
	sty my
	ldy #0
	mva #18 (copyto),y	;-> mark leftmost part of border
	ldy #15
	mva #19 (copyto),y	;-> mark rightmost part of border
	dey
ly_	lda #20		;-> mark all tiles of this line with full rainbow char
	sta (copyto),y
	lda 20
@	cmp 20
	beq @-
	dey
	bne ly_
	ldy my
nix	sbw test #40 test
	dex
	bpl lx
	.local points
	ldy reihen
	jeq add_one	;no line, so just tile is down
	lda drop	;give more points when speed dropped
	beq ly
	add reihen
	adc reihen
	tay
	mva #0 drop	;reset drop
ly	adw punkte reihenbonus punkte	;add points
	lda punkte+2
	adc #0
	sta punkte+2
	lda punkte+3
	adc #0
	sta punkte+3
	dey
	bpl ly
	.endl
	.local tetrisbonus	;extro points when we had a tetris
	lda reihen
	cmp #4
	bne @+
	ldy reihen
ly	adw punkte reihenbonus punkte
	lda punkte+2
	adc #0
	sta punkte+2
	lda punkte+3
	adc #0
	sta punkte+3
	dey
	bpl ly
	inw tetris
	cpw #999 tetris		;maximum of possible tetris is 999 (display has just 3 chars ;) )
	bcs w___
	mwa #999 tetris
w___
	.endl
	mva #2 SfxIdx
	bne w
@	mva #0 SfxIdx
w	jsr set_sfx_to_play	;some sound please
	.local clear_row	;clear marked rows on screen
	mwa #screen+26*40+12 test
	mwa #screen+25*40+12 copyfrom
	ldx #25
lx	ldy #0
	lda (test),y 
	cmp #18			;leftmost tile of a marked row
	bne ngef
	.local clear_line
	ldy #14
ly	lda #0
	sta (test),y
	lda 20
@	cmp 20
	beq @-
	dey
	bpl ly
	.endl
	jmp copy_from_above	;now we have to copy screen parts above cleared line
ngef	sbw test #40 test
	sbw copyfrom #40 copyfrom
	dex
	bpl lx
	.endl
	lda linien		;count lines up for highscore
	add reihen
	sta linien
	lda linien+1
	adc #0
	sta linien+1
	cpw #999 linien		;maximum of possible lines is 999 (display has just 3 chars ;) )
	bcs w__
	mwa #999 linien
w__
	jsr show_punkte
;---				every 20 cleared lines we will get faster and give more points -> level up
	lda lcount
	add reihen
	sta lcount
	lda lcount
	cmp #10
	jcc raus		;-> less than 10 lines cleared since last level up
	sbb lcount #10
	inc actlevel
	mwa #screen+23*40+37 copyto
	lda actlevel
	cmp #7			;-> max level is still level 7
	bcc @+
	mva #7 actlevel
@	cmp #7
	bne @+
	jsr paint_levelx	;-> level 7, now even direction will be changed randomly
	jmp sret
@	cmp #6
	bne @+
	jsr paint_sechs
	mva #13 maxteile	;2 new tiles added
	adw reihenbonus #216 reihenbonus
	jmp sret
@	cmp #5
	bne @+
	jsr paint_fuenf
	mva #11 maxteile	;2 new tiles added
	adw reihenbonus #108 reihenbonus
	jmp sret
@	cmp #4
	bne @+
	jsr paint_vier
	mva #9 maxteile		;1 new tile added
	adw reihenbonus #54 reihenbonus
	jmp sret
@	cmp #3
	bne @+
	jsr paint_drei
	mva #8 maxteile		;1 new tile added
	adw reihenbonus #28 reihenbonus
	jmp sret
@	cmp #2
	bne @+
	adw reihenbonus #14 reihenbonus
	jsr paint_zwei
sret	sbb retard #5 retard	;speed increase
	lda retard
	cmp #5
	bcs @+
	mva #1 maxspeed		;maxspeed reached
	mva #5 retard
@	inw bonuspunkte
	adw reihenbonus #14 reihenbonus
;---
raus	rts
;---
add_one	mva #1 SfxIdx		;-> just tile got down and no full line created
	jsr set_sfx_to_play
	ind punkte
	lda drop		;give more points when speed dropped
	beq @+
	ind punkte
	mva #0 drop	;reset drop 
@	adw punkte bonuspunkte punkte
	lda punkte+2
	adc #0
	sta punkte+2
	lda punkte+3
	adc #0
	sta punkte+3
	jsr show_punkte
	rts
;---
	.local copy_from_above	;x is set from last loop
lx	ldy #15
ly	lda (copyfrom),y
	sta (test),y
	dey
	bpl ly
	sbw test #40 test
	sbw copyfrom #40 copyfrom
	dex
	bpl lx
	.endl
	jmp clear_row
;----------
reihen	.ds 1
zaehl	.ds 1
my	.ds 1
	.endp
;------------