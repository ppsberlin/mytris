/*
mytris by pps

main proc -> init everything, show game menu and mainloop of game
*/
;	@com.wudsn.ide.asm.mainsourcefile=mytris.asm
;------------
	.proc main
	mva #0 559
	sta x+1
	sta xmax+1
	sta xmin+1
	sta xpos+1
	sta ZPLZS.SongPtr
	sta ZPLZS.SongPtr+1
	sta ZPLZS.bit_data
	sta playmus
	sta tmucke		;0:= both, 1 := just sfx play
	sta gamemode		;0 := mytris, 1 := tetris alike
	sta eingabe		;0 -> standard joystick input
	jsr hz_test
	sei
	jsr init_song
	cli

	mva #13 xmin		;set xmin (leftmost x position)
	jsr set_col		;set correct colors
;------------------------------------ insert some of the gfx into game screen
	.local paint_logo
;mytris logo
	mwa #screen+4*40+30 copyto
	mwa #mytris copyfrom
	ldx #5
lx	ldy #6
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #7 copyfrom
	dex
	bpl lx
	.endl
;---
	.local paint_pps
	mwa #screen+14*40+32 copyto
	mwa #pps copyfrom
	ldx #2
lx	ldy #3
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #4 copyfrom
	dex
	bpl lx
	.endl
;---
	.local paint_jahr
	mwa #screen+17*40+30 copyto
	mwa #jahr copyfrom
	ldx #2
lx	ldy #7
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #8 copyfrom
	dex
	bpl lx
	.endl
;---
	.local paint_level
	mwa #screen+23*40+28 copyto
	mwa #level copyfrom
	ldx #1
lx	ldy #8
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #9 copyfrom
	dex
	bpl lx
	.endl
;---
	.local paint_points
	mwa #screen+41 copyto
	mwa #points copyfrom
	ldx #1
lx	ldy #10
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #11 copyfrom
	dex
	bpl lx
	.endl
;---
	.local paint_lines
	mwa #screen+2+20*40 copyto
	mwa #lines copyfrom
	ldx #1
lx	ldy #8
ly	lda (copyfrom),y
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	adw copyfrom #9 copyfrom
	dex
	bpl lx
	.endl
;---
	.local zufallssterne		;create some random stars
	ldx #32
lx	lda random
	sta hpl,x
	dex
	bpl lx
	.endl
;------------------------- different delay for mytris color change in game menu
	lda sixtyhz
	beq pal
;ntsc
	mwa #1000 teildelay
	jmp spielbeginn
pal	mwa #1200 teildelay
;-------------------------------------------- first init finished
spielbeginn
	mva #0 ingame		;song for menu should be played
	jsr next_song
	jsr mainmenu		;show game menu

	lda:cmp:req $14		;wait 1 frame
	mva #0 559

	mva #1 ingame		;ingame song is wanted
	jsr next_song

	mwa #screen+23*40+37 copyto
	jsr paint_eins

	mwa #ant 560
	mwa #dli 512
	lda #7			;VBI
	ldx >vbi		;wird
	ldy <vbi		;jetzt
	jsr setvbv		;initialisiert
	mva #$c0 nmien		;VBI an
	mva #34 559

;spielbeginn			-> last inits for the new game
	mva #7 maxteile		;nur die Standard Teile (0-7) am Anfang
	mva #1 actlevel
	mva #30 retard
	mva #14 reihenbonus
	lda #0
	sta reihenbonus+1	;High Byte auch löschen
	sta last
	sta first
	sta drop
	sta bonuspunkte
	sta bonuspunkte+1
	sta lcount
	sta maxspeed
	sta punkte
	sta punkte+1
	sta punkte+2
	sta punkte+3
	sta linien
	sta linien+1
	sta tetris
	sta tetris+1
	sta paused		;no pause atm
	jsr show_punkte
;Zufallsteil
@	lda random
	and #$f
	cmp maxteile
	bcs @-
	sta m_shape
;-------------------------------------------------------	game starts here
mainloop
	lda first
	bne not_first
;firstturn
	sta direction
	mva #1 first
not_first
	mva next m_shape	;preview -> actual
;Zufallsteil
@	lda random
	and #$f
	cmp maxteile
	bcs @-
	sta next
	tay
	lda tbl_shape_l,y
	sta copyfrom
	lda tbl_shape_h,y
	sta copyfrom+1

	jsr set_preview

	jsr get_tile
	lda xmax
	sta m
	inc m
;Zufallsposition
@	lda random
	cmp m
	bcs @-
	cmp xmin
	bcc @-
	sta xpos
	mva #$ff ypos
	mva retard pause
;--- maxspeed?
	lda maxspeed
	beq whatmode
@	lda random
	and #$f
	cmp #4
	bcs @-
	sta direction
whatmode
	lda gamemode
	jne ttris_mode
;----------
	.local mytris_mode
	jsr set_shape
spielloop
	lda stop
	beq @+
	jsr test_rows
	jmp mainloop
@	inc ypos
	lda joy0
	beq s			;0 -> nichts oder "falsche" Richtung
	lda joy0
	cmp #1			;links
	bne t2
	lda xpos
	cmp xmin
	beq s
	dec xpos
	jmp s
t2	cmp #2			;rechts
	bne ho_ru
	lda xpos
	cmp xmax
	beq s
	inc xpos
	jmp s
ho_ru	;hoch oder runter -> drehen
	cmp #3
	bne dreh_links
;dreh_rechts
	inc direction
	lda direction
	cmp #4
	bne s
	mva #0 direction
	jmp s
dreh_links
	dec direction
	lda direction
	bpl s
	mva #3 direction
s	jsr clear_shape
	jsr set_shape
	lda last
	beq kein_ende
	jmp spielende
kein_ende
	lda #$ff
	ldx drop
	bne @+
	sub pause
@	sta 20
verzoegerung
	lda 20
	bne verzoegerung
pauseloop
	jsr tshift		;test shift for pause toggle
	lda paused
	bne pauseloop
	jmp spielloop
	.endl
;-----------
	.local ttris_mode
	jsr set_shape
spielloop
	lda stop
	beq @+
	jsr test_rows
	jmp mainloop
@	inc ypos
	lda last
	beq kein_ende
	jmp spielende
kein_ende
	lda #$ff
	ldx drop
	bne @+
	sub pause
@	sta ps
	mwa #2000 wt
verzoegerung
	lda drop
	bne s
	dew wt
	cpw wt #0
	bne nix
	mwa #2000 wt
	lda joy0
	beq s			;0 -> nichts oder "falsche" Richtung
	lda joy0
	cmp #1			;links
	bne t2
	lda xpos
	cmp xmin
	beq s
	dec xpos
	jmp s
t2	cmp #2			;rechts
	bne ho_ru
	lda xpos
	cmp xmax
	beq s
	inc xpos
	jmp s
ho_ru	;hoch oder runter -> drehen
	cmp #3
	bne links
;rechts
	inc direction
	lda direction
	cmp #4
	bne cl
	mva #0 direction
	jmp cl
links
	dec direction
	lda direction
	bpl cl
	mva #3 direction
	jmp cl
s	lda xpos
	cmp clear_shape.lastx
	bne cl
	lda ypos
	cmp clear_shape.lasty
	beq nix
cl	jsr clear_shape
	jsr set_shape
nix	lda ps
	jne verzoegerung
pauseloop
	jsr tshift		;test shift for pause toggle
	lda paused
	bne pauseloop
	jmp spielloop
;---
ps	.he 00
wt	.he 00 00
	.endl
	.endp
;------------