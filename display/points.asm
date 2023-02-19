/*
mytris by pps

paint points
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm
;------------
	.proc show_punkte
	lda gamemode
	beq mytris
;tetris alike
	mwa #scr_menu.linien2 show_punkte.lines.lin+1
	mwa #scr_menu.punkte2 show_punkte.points.pkt+1
	mwa #scr_menu.tetris2 show_punkte.tetris_.ttr+1
	jmp points
mytris
	mwa #scr_menu.linien show_punkte.lines.lin+1
	mwa #scr_menu.punkte show_punkte.points.pkt+1
	mwa #scr_menu.tetris show_punkte.tetris_.ttr+1
	.local points
	lda punkte
	sta hex2dec32.value
	lda punkte+1
	sta hex2dec32.value+1
	lda punkte+2
	sta hex2dec32.value+2
	lda punkte+3
	sta hex2dec32.value+3
	jsr hex2dec32
	mwa #screen+170 copyto
	ldy #5
	ldx #0
ly	sty myy
	stx mxx
	lda hex2dec32.result,x
	tay
;-> change jsr @ chg+1 to point to correct number paint routine
	lda tbl_zahl_l,y
	sta chg+1
	lda tbl_zahl_h,y
	sta chg+2
	tya
	add #$10
	ldy myy
pkt	sta scr_menu.punkte,y
chg	jsr $FFFF		;self modifying -> paint_null...neun
	ldy myy
	ldx mxx
	sbw copyto #82
	inx
	dey
	bpl ly
	.endl
	.local lines
	lda linien
	sta hex2dec32.value
	lda linien+1
	sta hex2dec32.value+1
	lda #0
	sta hex2dec32.value+2
	sta hex2dec32.value+3
	jsr hex2dec32
	mwa #screen+7+23*40 copyto
	ldy #2
	ldx #0
ly	sty myy
	stx mxx
	lda hex2dec32.result,x
	tay
	lda tbl_zahl_l,y
	sta chg+1
	lda tbl_zahl_h,y
	sta chg+2	
	tya
	add #$10
	ldy myy
lin	sta scr_menu.linien,y
chg	jsr $FFFF		;self modifying -> paint_null...neun
	ldy myy
	ldx mxx
	sbw copyto #82
	inx
	dey
	bpl ly
	.endl
	.local tetris_
	lda tetris
	sta hex2dec32.value
	lda tetris+1
	sta hex2dec32.value+1
	lda #0
	sta hex2dec32.value+2
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #2
	ldx #0
ly	lda hex2dec32.result,x
	add #$10
ttr	sta scr_menu.tetris,y
	sbw copyto #82
	inx
	dey
	bpl ly
	.endl
	rts
;----------
myy	.he 00
mxx	.he 00
	.endp
;------------
tbl_zahl_l
	dta <paint_null,<paint_eins,<paint_zwei,<paint_drei,<paint_vier,<paint_fuenf,<paint_sechs,<paint_sieben,<paint_acht,<paint_neun
;------------
tbl_zahl_h
	dta >paint_null,>paint_eins,>paint_zwei,>paint_drei,>paint_vier,>paint_fuenf,>paint_sechs,>paint_sieben,>paint_acht,>paint_neun
;------------
	.proc show_best		;highscores in mainmenu
	lda gamemode
	beq mytris
;tetris alike
	.local ttris		;tetris alike mode points for mainmenu
	.local points
	lda today2
	sta hex2dec32.value
	lda today2+1
	sta hex2dec32.value+1
	lda today2+2
	sta hex2dec32.value+2
	lda today2+3
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #5
	ldx #0
ly	lda hex2dec32.result,x
	add #$10
	sta scr_menu.today2,y
	inx
	dey
	bpl ly
	.endl
	.local lines
	lda most2
	sta hex2dec32.value
	lda most2+1
	sta hex2dec32.value+1
	lda #0
	sta hex2dec32.value+2
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #2
	ldx #0
ly	lda hex2dec32.result,x
	add #$90
	sta scr_menu.most2,y
	inx
	dey
	bpl ly
	.endl
	.local tetris_
	lda mttris2
	sta hex2dec32.value
	lda mttris2+1
	sta hex2dec32.value+1
	lda #0
	sta hex2dec32.value+2
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #2
	ldx #0
ly	lda hex2dec32.result,x
	add #$90
	sta scr_menu.mttris2,y
	inx
	dey
	bpl ly
	.endl
	rts
	.endl
;------------
	.local mytris		;mytris mode points for mainmenu
	.local points
	lda today
	sta hex2dec32.value
	lda today+1
	sta hex2dec32.value+1
	lda today+2
	sta hex2dec32.value+2
	lda today+3
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #5
	ldx #0
ly	lda hex2dec32.result,x
	add #$10
	sta scr_menu.today,y
	inx
	dey
	bpl ly
	.endl
	.local lines
	lda most
	sta hex2dec32.value
	lda most+1
	sta hex2dec32.value+1
	lda #0
	sta hex2dec32.value+2
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #2
	ldx #0
ly	lda hex2dec32.result,x
	add #$90
	sta scr_menu.most,y
	inx
	dey
	bpl ly
	.endl
	.local tetris_
	lda mttris
	sta hex2dec32.value
	lda mttris+1
	sta hex2dec32.value+1
	lda #0
	sta hex2dec32.value+2
	sta hex2dec32.value+3
	jsr hex2dec32
	ldy #2
	ldx #0
ly	lda hex2dec32.result,x
	add #$90
	sta scr_menu.mttris,y
	inx
	dey
	bpl ly
	.endl
	rts
	.endl
	.endp
;------------