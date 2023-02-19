/*
mytris by pps

main game DL
*/
;	@com.wudsn.ide.asm.mainsourcefile=mytris.asm
;------------
	* --- Loading
	org $600

ldg	dta d'           mytris is loading            '
	.proc antl
:2	.he 70 70 70 70 70 70 70 70 70 70
	.he 70 70 70 42
chg	.wo ldg
	.he 41
	dta a(antl)
	.endp
;------------
	.proc loader
	mva #$ff portb		;basic off
	mwa #antl 560
	mva #0 710
	rts
	.endp
;------------
	ini loader
;------------