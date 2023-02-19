/*
mytris by pps

input routines
*/
;	@com.wudsn.ide.asm.mainsourcefile=mytris.asm
;------------
	.proc keytest	; 1-links 2-rechts 3-hoch, 4-runter, 5-Feuerknopf
; keyboard -> keyb table contains key values
	lda 764
	cmp #$ff
	bne @+
	rts
@	sta mk
	mva #$ff 764
	ldx #5
lx	lda keyb,x
	cmp mk
	beq found
	dex
	bpl lx
	sta joy0	; -> last entry was 0
	rts
found	stx joy0
	rts
;---
mk	.he 00
keyb;	dta b(0,16,21,35,37,33)	;nichts,V,B,N,M,SPACE
	dta b(0,6,7,14,15,23)	;nichts,+,*,-,=,Z
	.endp
;------------
	.proc joytest	;joy0: 1-links 2-rechts 3-hoch, 4-runter, 5-Feuerknopf
			;joy1: 5 and 4 has to be changed
			;if joy2b+ rotating handled via 1st and 2nd button
	ldx input
	cpx #joyb
	beq joy2b
;stick0 is used
	ldy stick0
	ldx joy,y
	stx joy0
	ldx trig0
	bne ww
	mvx #5 joy0
ww	ldx eingabe
	beq raus
;joy1 mode
	ldx joy0
	cpx #4
	bcc raus
	bne five
	inc joy0
	rts
five	dec joy0
raus	rts
;---
joy
	dta b(0,0,0,0,0,0,0,2,0,0,0,1,0,4,3,0)
;---
	.local joy2b	;different joy routine for joy2B+ controller
;stick0 is used
	ldy stick0
	ldx joy2,y
	stx joy0
	ldx paddl0	;for joy2b+
	cpx #$e4
	bne w
	mvx #3 joy0
w	ldx paddl1
	ldx trig0
	bne raus
	mvx #4 joy0
raus	rts
	.endl
;---
joy2
	dta b(0,0,0,0,0,0,0,2,0,0,0,1,0,5,0,0)
	.endp
;------------