/*
mytris by pps

game menu screen
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm
;------------
	.proc scr_menu
	dta d'******/''-***********************/''-*****'
	dta d'      (4) ! !  " " ### $$  %  &&(4)     '
	dta d'      (4)! ! ! " "  #  $ $ % && (4)     '
	dta d'      (4)! ! !  "   #  $$  %  &&(4)     '
	dta d'      (4)!   !  "   #  $ $ % && (4)     '
	dta d'......1''0.......................1''0.....'
	dta d'        coded by PPs January 2023       '
	dta d'       music by Buddy - sfx by PG       '
	dta d'                -v1.01-                 '
	dta d'         '
sel	dta 'H',d'SELECT'*,'H'*,d' '
sfx	dta d'music+sfx             '
	dta d'    '
opt	dta 'H',d'OPTION'*,'H'*,d' gamemode: '
gmode	dta d'mytris           '
	dta d'       '
help	dta 'H',d'HELP'*,'H'*,d' '
input	dta d'JOY1 JOY2 KEYBOARD        '
	dta d'__________scores of mytris mode_________'
	dta d' last score: '
punkte	dta d'000000 '
	dta d'lines:'
linien	dta d'000 '
	dta d'tetris:'
tetris	dta d'000'
	dta d'todays best: '
today	dta d'000000 '
	dta d'lines:'
most	dta d'000'*,d' '
	dta d'tetris:'
mttris	dta d'000'*
	dta d'______scores of tetris alike mode_______'
	dta d' last score: '
punkte2	dta d'000000 '
	dta d'lines:'
linien2	dta d'000 '
	dta d'tetris:'
tetris2	dta d'000'
	dta d'todays best: '
today2	dta d'000000 '
	dta d'lines:'
most2	dta d'000'*,d' '
	dta d'tetris:'
mttris2	dta d'000'*
	dta d'  press'
start	dta 'H',d'START'*,'H'*,d'or fire button to begin   '
	.endp
;------------