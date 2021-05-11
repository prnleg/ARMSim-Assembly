@ Just some codes with store applications
@ Also using Left/Right Button and showing on display

.equ PrintS,0x204                       @ Bind to print a String on the LCD
.equ Print,0x205                        @ Bind to print an Integer on the LCD
.equ Clear,0x206                        @ Bind to clear the LCD
.equ Butt, 0x202                        @ Bind for the Black Buttons


.text                                   

                                        @ 'str_' is the variable, asciz is the type and
                                        @ the "Text Inside" is the value that variable has

    str_ini: .asciz "Block 1:"
    str_fin: .asciz "Block 2:"

.data                                   @ Setting up a loop to change from Block1 to Block2

    BLOCK1  DCB 0x01, 0x02, 0x03, 0x04, 0x05
    BLOCK2  DCB 0x00, 0x00, 0x00, 0x00, 0x00

.align

mov r0, #0                              @ Position 'x' to 0 in LCD
mov r1, #0                              @ Position 'y' to 0 in LCD
ldr r2, =str_ini                        @ The Value of r2 is the first phrase
swi PrintS                              @ Print
mov r1, #2                              @ Move 'y' to the position 2 in LCD
ldr r2, =str_fin                        @ The value of r2 is the second phrase
swi PrintS                              @ Print

ldr r3, =BLOCK1                         @ Load in r0 the array Block1
ldr r4, =BLOCK2                         @ Load in r0 the array Block2
mov r5, #5                              @ The Number of elements on the Blocks
mov r6, #0
mov r9, #0
mov r8, #0

Check:
    mov r0, #0
    swi Butt
    cmp r0, 0x01
    beq Alr
    cmp r0, 0x02
    beq All
    b   Check


Alr:
    mov r8, #0
    cmp r9, #1
    beq Check
    bne RightLeft


All:
    mov r9, #0
    cmp r8, #1
    beq Check
    bne LeftRight


LeftRight:
    mov     r8, #1
    mov     r1, #1
    ldrb    r6, [r3], #1                @ Puts in r6 the value of the r3 position
                                        @ and sum #1 for the next position
    strb    r6, [r4], #1                @ Store in r6 the value of r3 and sum
                                        @ #1 gor the next position
    
    ldr     r2, [r6]
    swi     Print
    add     r0, r0, #3
    add     r7, r7, #1
    subs    r5, #1                      @ Sub from r5 #1 and checks if it's igual to 0
    bne     LeftRight
    beq     Check

RightLeft:
    mov     r9, #1
    mov     r1, #3
    ldrb    r6, [r4], #1
    strb    r6, [r3], #1
    ldr     r2, [r6]
    swi     Print
    add     r0, r0, #1
    add     r5, r5, #1
    subs    r7, #1
    bne     RightLeft
    beq     Check
