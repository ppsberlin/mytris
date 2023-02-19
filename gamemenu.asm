/*
mytris by pps

game menu
*/
;	@com.wudsn.ide.asm.mainsourcefile=mytris.asm
;------------
	.proc mainmenu
	lda:cmp:req $14		;wait 1 frame
	mva #0 559
	sta 732			;reset help key flag
	mva >pmg pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles

	jsr detect_joy2b	;have correct input @menu start
	jsr paint_input

s_ant	mwa #ant_menu 560
	jsr show_punkte
	jsr show_best
	lda #7			;VBI
	ldx >vbi_menu		;wird
	ldy <vbi_menu		;jetzt
	jsr setvbv		;initialisiert
	mva #$c0 nmien		;VBI an
	mva #34 559

menuloop
t_trig	jsr menuteil
	jsr detect_joy2b
	jsr paint_input
	lda consol
	tax
	and #1			;START?
	beq tstrt
	txa
	and #2			;SELECT?
	beq toggle_mucke
	txa
	and #4			;OPTION
	beq toggle_mode
	lda 732			;HELP?
	jne toggle_input
@	lda trig0
	bne t_trig
tstrt	jsr toggle_start
l_t0	jsr menuteil
	lda consol
	and #1			;START
	beq l_t0
	lda trig0		;Trigger erst wieder loslassen
	beq l_t0
	jsr toggle_start
	mva #0 pmcntl		;disable players and missiles
	rts			;start the game
;---
	.local toggle_mucke
	jsr toggle_sel
@	jsr menuteil
	lda consol
	and #2
	beq @-
	jsr toggle_sel
	mva #0 playmus
	jsr stop_music
	lda tmucke
	eor #1
	sta tmucke
	mva #1 playmus
	lda tmucke
	bne cmus
;cmfx
	ldy #8
@	lda mus,y
	sta scr_menu.sfx,y
	dey
	bpl @-
	jmp menuloop
cmus
	ldy #8
@	lda mfx,y
	sta scr_menu.sfx,y
	dey
	bpl @-
	jmp menuloop
	.endl
;---
	.local toggle_mode
	jsr toggle_opt
@	jsr menuteil
	lda consol
	and #4
	beq @-
	jsr toggle_opt
	lda gamemode
	beq cttris
;cmytris
	mva #0 gamemode
	ldy #11
@	lda mytris,y
	sta scr_menu.gmode,y
	dey
	bpl @-
	jmp menuloop
cttris
	mva #1 gamemode
	ldy #11
@	lda ttris,y
	sta scr_menu.gmode,y
	dey
	bpl @-
	jmp menuloop
	.endl
;---
	.local toggle_input
	jsr toggle_help
	jsr menuteil
	mva #0 732			;reset help key flag
	jsr toggle_help
	lda input
	cmp #joyb
	beq inp_joy2b
;standard joystick
	lda eingabe
	beq set_joy1
	cmp #1
	beq set_key
;joy0
	mva #0 eingabe
	jmp menuloop
set_joy1
	mva #1 eingabe
	jmp menuloop
set_key
	mva #keyb eingabe
	jmp menuloop
;---
	.local inp_joy2b
	lda eingabe
	cmp #joyb
	beq set_key
;set_joy2b
	mva #joyb eingabe
	jmp menuloop
set_key
	mva #keyb eingabe
	jmp menuloop
	.endl
;---
	.endl
;------------
	.local toggle_help
	ldy #5
@	lda scr_menu.help,y
	add #$80
	sta scr_menu.help,y
	dey
	bpl @-
	rts
	.endl
;------------
	.local toggle_sel
	ldy #7
@	lda scr_menu.sel,y
	add #$80
	sta scr_menu.sel,y
	dey
	bpl @-
	rts
	.endl
;------------
	.local toggle_opt
	ldy #7
@	lda scr_menu.opt,y
	add #$80
	sta scr_menu.opt,y
	dey
	bpl @-
	rts
	.endl
;------------
	.local toggle_start
	ldy #6
@	lda scr_menu.start,y
	add #$80
	sta scr_menu.start,y
	dey
	bpl @-
	rts
	.endl
;------------
mus	dta d'music+sfx'
mfx	dta d'sfx only '
mytris	dta d'mytris      '
ttris	dta d'tetris alike'
	.endp
;------------
hpl		;table of stars
:33	.he 00
;------------
	.proc paint_input
	lda input
	cmp #joyb
	beq inp_joy2b
;standard joystick
	lda eingabe
	cmp #1
	beq p_joy1
	cmp #keyb
	beq p_key
;joy0
	mva #$68 dli_menu1.chg+1
	mva #1 dli_menu1.chg1+1
	mva #blue2 dli_menu1.chg2+1
	rts
p_joy1
	mva #$7c dli_menu1.chg+1
	mva #1 dli_menu1.chg1+1
	mva #red dli_menu1.chg2+1
	rts
p_key
	mva #$90 dli_menu1.chg+1
	mva #3 dli_menu1.chg1+1
	mva #orange dli_menu1.chg2+1
	rts
;---
	.local inp_joy2b
	lda eingabe
	cmp #keyb
	beq p_key
;p_joy2b
	mva #$6c dli_menu1.chg+1
	mva #3 dli_menu1.chg1+1
	mva #green dli_menu1.chg2+1
	rts
p_key
	mva #$90 dli_menu1.chg+1
	mva #3 dli_menu1.chg1+1
	mva #orange dli_menu1.chg2+1
	rts
	.endl
;---
	.endp
;------------
	.proc detect_joy2b
	lda paddl0
	cmp #1
	bne out
	lda paddle1
	cmp #1
	bne out
	lda #joyb
out	cmp input
	beq raus
	sta input
	cmp #joyb
	bne t_joy
	mwa #txt_j2b lx+1
	mva #joyb eingabe
	jmp do
t_joy	mwa #txt_joy lx+1
	mva #0 eingabe
do	ldx #8
lx	lda txt_joy,x
	sta scr_menu.input,x
	dex
	bpl lx
raus	rts
;---
txt_joy	dta d'JOY1 JOY2'
txt_j2b dta d'  JOY2B+ '
	.endp
;------------
	.proc vbi_menu
	mwa #dli_menu 512
	mva #0 hposp0
	sta hposp1
	sta hposp2
	sta hposp3
	sta hposm0
	mva #@dmactl(standard|dma) dmactl
	lda #black
	sta colpm0
	sta colbak
	lda red
	sta colpm1
	lda purple
	sta colpm2
	lda blue
	sta colpm3
	lda blue2
	sta color0
	lda green
	sta color1
	lda orange
	sta color2
	lda yellow
	sta color3
	lda playmus
	beq nomus
	jsr mukke
nomus	jmp xitvbv
	.endp
;------------
	.proc ant_menu
	.he 10 f0 00 42
	.wo scr_menu
:5	.he 02
	.he 80 00 02
	.he 02 02
txt
:3	.he 02 00
	.he a0
	.he 82 02 02
	.he 90
	.he 82 02 02
	.he 70 82 10 42
	.wo scr_menu
:5	.he 02
	.he 41
	.wo ant_menu
	.endp
;------------
	.proc menuteil
	lda #$f0
	sta 20
l_tim	jsr menucolor
	lda 20
	bne l_tim
@	lda random
	and #$f
	cmp #7
	bcs @-
	sta next
	tay
	lda tbl_shape_l,y
	sta copyfrom
	lda tbl_shape_h,y
	sta copyfrom+1

	.local clear
	mwa #scr_menu+81 copyto
;clear preview first
	ldx #1
lx	ldy #3
ly	lda #0
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	dex
	bpl lx
	.endl

	mwa #scr_menu+81 copyto
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
;---
	.local teil2
@	lda random
	and #$f
	cmp #7
	bcs @-
	sta next
	tay
	lda tbl_shape_l,y
	sta copyfrom
	lda tbl_shape_h,y
	sta copyfrom+1

	.local clear
	mwa #scr_menu+115 copyto
;clear preview first
	ldx #1
lx	ldy #3
ly	lda #0
	sta (copyto),y
	dey
	bpl ly
	adw copyto #40 copyto
	dex
	bpl lx
	.endl

	mwa #scr_menu+115 copyto
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
	.endl
	rts
;----------
	.local menucolor
	inw toggl
	lda toggl
	cpw toggl teildelay
	beq w
	rts
w	mwa #0 toggl
	mwa #scr_menu+40+9 copyto

	ldx #3
lx	ldy #22
ly	lda (copyto),y
	beq @+
	sub #1
	bne set
	lda #6
set	sta (copyto),y
@	dey
	bpl ly
	adw copyto #40 copyto
	dex
	bpl lx
	rts
	.endl
;----
toggl	.he 00 00
	.endp
;------------
	.proc dli_menu
	sta regA
	stx regX
	mva #black colpm0
	sta wsync
	sta hposp0
	sta hposp1
	sta hposp2
	sta hposp3
	mva >fnt chbase
	mva #@gtictl(mode10|ply5|mlc) gtictl
	mva #@dmactl(standard|dma|missiles|lineX2) dmactl
	sta wsync
	mva #white colbak
	mva orange color2
	mva green color1
:8	sta wsync
	ldx #32
lx	lda hpl,x
	sta hposm0
	add #1
	sta hpl,x
	sta wsync
	dex
	bpl lx
	mwa #dli_menu1 512
	ldx regX
	lda regA
	rti
	.endp
;------------
	.proc dli_menu1
	sta regA
	mva yellow color1
	sta wsync
	mva #black color2
	sta colbak
	mva #$e0 chbase
	mva #@gtictl(prior1) gtictl
chg2	mva blue2 colpm0
	mva #@dmactl(standard|dma|players|lineX2) dmactl
	mva #3 sizep2
	sta sizep3
chg1	mva #1 sizep0
	mva #1 sizep1
	sta wsync
chg	mva #$6c hposp0			;$6c := joy, $90 := key
	lda gamemode
	bne @+
	sta hposp3
	mva #$8c hposp2
	mwa #dli_menu2 512
	lda regA
	rti
@	sta hposp2
	mva #$8c hposp3
	mwa #dli_menu2 512
	lda regA
	rti
	.endp
;------------
	.proc dli_menu2
	sta regA
	mva #3 sizep0
	mva green colpm0
	mva #$80 hposp2
	mwa #dli_menu3 512
	lda regA
	rti
	.endp
;------------
	.proc dli_menu3
	sta regA
	mva #$64 hposp0
	mva #$98 hposp1
	mva #$a8 hposp2
	mwa #dli_menu4 512
	lda regA
	rti
	.endp
;------------
	.proc dli_menu4
	sta regA
	mva #$70 hposp3
	mwa #dli_menu5 512
	lda regA
	rti
	.endp
;------------
	.proc dli_menu5
	sta regA
	mva #$a8 hposp3
	mwa #dli_menu 512
	lda regA
	rti
	.endp
;------------