@ Just a code to use the buttons 'Left' and 'Right'
@ and the 0.0 to 3.3


@ Those are binds for each one on 8 segment display 
.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_P,0x10
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01

Digits:                                             @ Those are the value for r0:
                                                    @ that will also be on display
    .word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G       @ 0
    .word SEG_B|SEG_C                               @ 1
    .word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D             @ 2
    .word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D             @ 3
    .word SEG_G|SEG_F|SEG_B|SEG_C                   @ 4
    .word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D             @ 5
    .word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C       @ 6
    .word SEG_A|SEG_B|SEG_C                         @ 7
    .word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @ 8
    .word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C             @ 9
    .word SEG_A|SEG_G|SEG_B|SEG_F|SEG_E|SEG_C       @ A [10]
    .word SEG_G|SEG_E|SEG_F|SEG_D|SEG_C             @ B [11]
    .word SEG_A|SEG_G|SEG_E|SEG_D                   @ C [12]
    .word SEG_B|SEG_E|SEG_F|SEG_D|SEG_C             @ D [13]
    .word SEG_A|SEG_D|SEG_E|SEG_F|SEG_G             @ E [14]
    .word SEG_A|SEG_E|SEG_F|SEG_G                   @ F [15]
    .word 0                                         @ 'empty'

.text

Digits:
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
.word SEG_B|SEG_C @1
.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
.word SEG_G|SEG_F|SEG_B|SEG_C @4
.word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
.word SEG_A|SEG_B|SEG_C @7
.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
.word 0 @Blank display