/*
mytris by pps

tiles shapes
*/
;	@com.wudsn.ide.asm.mainsourcefile=../mytris.asm
;------------
	.proc shape
one	;3x2	-> red
	.he 03 02
	.he 01 01 00
	.he 00 01 01
one1	;2x3	-> red
	.he 02 03
	.he 00 01
	.he 01 01
	.he 01 00
;---
two	;3x2	-> purple
	.he 03 02
	.he 00 02 00
	.he 02 02 02
two1	;2x3	-> purple
	.he 02 03
	.he 02 00
	.he 02 02
	.he 02 00
two2	;3x2	-> purple
	.he 03 02
	.he 02 02 02
	.he 00 02 00
two3	;2x3	-> purple
	.he 02 03
	.he 00 02
	.he 02 02
	.he 00 02
;---
three	;3x2	-> blue
	.he 03 02
	.he 03 00 00
	.he 03 03 03
three1	;2x3	-> blue
	.he 02 03
	.he 03 03
	.he 03 00
	.he 03 00
three2	;3x2	-> blue
	.he 03 02
	.he 03 03 03
	.he 00 00 03
three3	;2x3	-> blue
	.he 02 03
	.he 00 03
	.he 00 03
	.he 03 03
;---
four	;4x1	-> blue2
	.he 04 01
	.he 04 04 04 04
four1	;1x4	-> blue2
	.he 01 04
	.he 04
	.he 04
	.he 04
	.he 04
;---
five	;3x2	-> green
	.he 03 02
	.he 00 05 05
	.he 05 05 00
five1	;2x3	-> green
	.he 02 03
	.he 05 00
	.he 05 05
	.he 00 05
;---
six	;3x2	-> orange
	.he 03 02
	.he 00 00 06
	.he 06 06 06
six1	;2x3	-> orange
	.he 02 03
	.he 06 00
	.he 06 00
	.he 06 06
six2	;3x2	-> orange
	.he 03 02
	.he 06 06 06
	.he 06 00 00
six3	;2x3	-> orange
	.he 02 03
	.he 06 06
	.he 00 06
	.he 00 06
;---
seven	;2x2	-> yellow
	.he 02 02
	.he 07 07
	.he 07 07
;---
eight	;3x3
	.he 03 03
	.he fd fd fd
	.he fd 00 00
	.he fd 00 00
eight1	;3x3
	.he 03 03
	.he fd fd fd
	.he 00 00 fd
	.he 00 00 fd
eight2	;3x3
	.he 03 03
	.he 00 00 fd
	.he 00 00 fd
	.he fd fd fd
eight3	;3x3
	.he 03 03
	.he fd 00 00
	.he fd 00 00
	.he fd fd fd
;---
nine	;3x3
	.he 03 03
:3	.he fe fe fe
;---
ten	;3x3
	.he 03 03
	.he 00 00 ff
	.he ff ff ff
	.he 00 00 ff
ten1	.he 03 03
	.he 00 ff 00
	.he 00 ff 00
	.he ff ff ff
ten2	.he 03 03
	.he ff 00 00
	.he ff ff ff
	.he ff 00 00
ten3	.he 03 03
	.he ff ff ff
	.he 00 ff 00
	.he 00 ff 00
;---
eleven	;4x2
	.he 04 02
	.he 7d 7d 7d 7d
	.he 7d 00 00 00
eleven1	;2x4
	.he 02 04
	.he 7d 7d
	.he 00 7d
	.he 00 7d
	.he 00 7d
eleven2	;4x2
	.he 04 02
	.he 00 00 00 7d
	.he 7d 7d 7d 7d
eleven3	;2x4
	.he 02 04
	.he 7d 00
	.he 7d 00
	.he 7d 00
	.he 7d 7d
;---
twelve	;4x2
	.he 04 02
	.he 7f 00 00 00
	.he 7f 7f 7f 7f
twelve1	;2x4
	.he 02 04
	.he 7f 7f
	.he 7f 00
	.he 7f 00
	.he 7f 00
twelve2	;4x2
	.he 04 02
	.he 7f 7f 7f 7f
	.he 00 00 00 7f
twelve3	;2x4
	.he 02 04
	.he 00 7f
	.he 00 7f
	.he 00 7f
	.he 7f 7f
;---
thirteen	;3x3
	.he 03 03
	.he 7e 7e 00
	.he 00 7e 00
	.he 00 7e 7e
thirteen1	;3x3
	.he 03 03
	.he 00 00 7e
	.he 7e 7e 7e
	.he 7e 00 00
	.endp
;------------