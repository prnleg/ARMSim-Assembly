@ Just a code to use the buttons 'Left' and 'Right'
@ and the 0.0 to 3.3
@ Are there better solutions for this use in specific, just use as example

@ Those are bind to use the Software Interuptions Quickier
.equ Seg8, 0x200                                    @ Display on the 8 Segments the value in r0
.equ Print, 0x205                                   @ Display on the LCD the value in r2
.equ Buttn, 0x202                                   @ Put in r0 the button pressed (left/right)
.equ BlueB, 0x203                                   @ Put in r0 the button pressed (0-15)
.equ Clear,0x206                        @ Bind to clear the LCD

@ Those are binds for each one on 8 segment display 
.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_P,0x10
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01

.text

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


.align

mov r0, #0                                          @ Starting the variable with 0
mov r1, #0                                          @ Starting the variable with 0
mov r2, #0                                          @ Starting the variable with 0

swi Clear                                           @ This will clear the LCD

@ This will create a loop where it compares if any Blue Button was pressed or not
Start:
    swi BlueB                                       @ Puts in r0 the value of the button pressed
    cmp r0, #0
    bne Display
    beq Start                                       @ Here's where the loop starts again


@ This is where it compares with each specific buttton, there are better ways to do that
@ Use this just as an example
Display:
                                                    @ As the macro runs, it will pull the position. '0' in this case
    cmp r0, #0x01                                   @ This represent the value of the Blue Button
    mov r3, #0
    beq Dig
    cmp r0, #0x02
    mov r3, #1
    beq Dig
    cmp r0, #0x04
    mov r3, #2
    beq Dig
    cmp r0, #0x08
    mov r3, #3
    beq Dig
    cmp r0, #0x10
    mov r3, #4
    beq Dig
    cmp r0, #0x20
    mov r3, #5
    beq Dig
    cmp r0, #0x40
    mov r3, #6
    beq Dig
    cmp r0, #0x80
    mov r3, #7
    beq Dig
    cmp r0, #0x100
    mov r3, #8
    beq Dig
    cmp r0, #0x200
    mov r3, #9
    beq Dig
    cmp r0, #0x400
    mov r3, #10
    beq Dig
    cmp r0, #0x800
    mov r3, #11
    beq Dig
    cmp r0, #0x1000
    mov r3, #12
    beq Dig
    cmp r0, #0x2000
    mov r3, #13
    beq Dig
    cmp r0, #0x4000
    mov r3, #14
    beq Dig
    cmp r0, #0x8000
    mov r3, #15
    beq Dig


@ Each function is printing a number (in hexa) on the 8 Segment Display
Dig:
    ldr r1, =Digits                                 @ Load the macros on r1
    ldr r0, [r1, r3, lsl#2]                         @ Puts on r0 the digits and the position you choose
    swi Seg8                                        @ Print on the Display
    b Start                                         @ Return to the code loop

.end