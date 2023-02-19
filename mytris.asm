/*
mytris by pps
started:	05.01.2023
v1.01:		04.02.2023
*/

;	@com.wudsn.ide.asm.hardware=ATARI8BIT

	icl 'atari.hea'				;OS headers and others

BEGIN	equ $2000				;address of first bytes
PLAYER	equ $7daf				;address of LZSS player
;------------
	icl 'loader.asm'			;org $0600 -> game loader
;------------
white = 14
black = 0
joyb = 3
keyb = 2
	.zpvar	.byte	sixtyhz,regA,regX,regY,count_s,ingame,playmus,tmucke,retard,lcount,maxspeed,actlevel,gamemode,eingabe,maxteile,paused
	.zpvar	.byte	red,purple,blue,blue2,green,orange,yellow,y,stop,m,m_shape,ypos,joy0,pause,last,next,first,drop,direction,input
	.zpvar	.word	copyto,copyfrom,test,x,xmax,xmin,xpos,teildelay
;------------
	org BEGIN
;------------
	icl 'display/ant.asm'			;ant
;------------
	icl 'main.asm'				;main
;------------
	.proc tshift	;test if shift is pressed
	lda $d20f
	and #8
	bne no
lp	lda $d20f
	and #8
	beq lp
	lda paused
	bne zero
	mva #1 paused
	rts
zero	mva #0 paused
no	rts
	.endp
;------------
	icl 'display/numbers.asm'		;paint_eins, paint_zwei, paint_drei, paint_vier, paint_fuenf, paint_sechs
						;paint_sieben, paint_acht, paint_neun, paint_null, paint_levelx, do_paint
;------------
	.proc next_song	; changes the song
	mva #0 playmus
	jsr stop_music
	lda ingame
	bne @+
	sta SongIdx
	jmp w
@	mva #1 SongIdx
w	lda #0
	sta LZS.Initialized
	jsr SetNewSongPtrs
	mva #1 playmus
	rts
	.endp
;------------
	icl 'gamemenu.asm'		;mainmenu, paint_input, detect_joy2b, vbi_menu, ant_menu, dli_menu..dli_menu5
;------------
	icl 'gameover.asm'		;spielende & clear_screen
;------------
	icl 'testrows.asm'		;test_rows
;------------
	icl 'display/preview.asm'	;set_preview
;------------
	icl 'display/tiles.asm'		;get_tile, tbl_shape_l, tbl_shape_h, tbl_shape_l1, tbl_shape_h1, tbl_shape_l2
					;tbl_shape_h2, tbl_shape_l3, tbl_shape_h3, set_shape, clear_shape
;------------
	icl 'input.asm'			;keytest, joytest
;------------
	icl 'display/nmi.asm'		;dli, vbi, mukke
;------------
	.proc hz_test
	mva #0 559
	sta count_s
	lda #7				;VBI
	ldx >xitvbv			;wird
	ldy <xitvbv			;jetzt
	jsr setvbv			;initialisiert
	mva #34 559
	mva #$40 nmien			;VBI an
;50Hz or 60 Hz?
	mva #0 vcount
@	lda vcount
	cmp #0
	beq w
	sta count_s
	jmp @-
w
	lda count_s
	cmp #$9b
	bmi ntsc
;PAL
	mva #0 sixtyhz
	sta count_s
	rts
ntsc
	mva #1 sixtyhz
	mva #0 count_s
	rts
;--------
	.endp
;------------
	icl 'display/points.asm'		;show_punkte, tbl_tahl_l, tbl_zahl_h, show_best
;------------
        ;converts to 10 digits (32 bit values have max. 10 decimal digits)
	.proc hex2dec32	;result is low-high
        ldx #0
l3      jsr div10
        sta result,x
        inx
        cpx #10
        bne l3
        rts
        ; divides a 32 bit value by 10
        ; remainder is returned in accu
div10
        ldy #32         ; 32 bits
        lda #0
        clc
l4      rol
        cmp #10
        bcc skip
        sbc #10
skip    rol value
        rol value+1
        rol value+2
        rol value+3
        dey
        bpl l4
        rts
;---
value   .he 00 00 00 00
result  .byte 0,0,0,0,0,0,0,0,0,0
	.endp
;------------
	.proc set_col
	lda pal
	cmp #1
	beq no_ntsc
;ntsc
	mva #$44 red
	mva #$64 purple
	mva #$84 blue
	mva #$a8 blue2
	mva #$c6 green
	mva #$28 orange
	mva #$1c yellow
	jmp w
no_ntsc	mva #$24 red
	mva #$54 purple
	mva #$74 blue
	mva #$98 blue2
	mva #$b6 green
	mva #$18 orange
	mva #$ec yellow
w	rts
	.endp
;------------
	.align $1000
	icl 'display/screen.asm'		;screen
;------------
	.align $0400
	.proc fnt
	ins 'gfx/mytris_tiles_n.fnt'
	.endp
;------------
	icl 'gfx/tiles_shapes.asm'		;shape
;------------
	icl 'gfx/other_shapes.asm'		;mytris, pps, jahr, g_over, level, points, lines, eins, zwei, drei
						;vier, fuenf, sechs, sieben, acht, neun, null, levelx
;------------
	.align $1000
	icl 'display/menu_screen.asm'		;scr_menu
;------------
linien	.he 00 00
punkte	.he 00 00 00 00
tetris	.he 00 00
bonuspunkte
	.he 00 00
reihenbonus
	.he 00 00
today	.he 00 00 00 00
most	.he 00 00
mttris	.he 00 00
today2	.he 00 00 00 00
most2	.he 00 00
mttris2	.he 00 00
;------------
	.align $0c00
	icl 'pmg.asm'				;pmg
;------------
mainend
	icl 'sound/sfx.asm'
	icl 'sound/play_rmt2lzss_sfx.asm'
endplay
	run main