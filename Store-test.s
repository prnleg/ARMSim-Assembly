@ Just a code that read and write in memory

.equ Clear, 0x206                       @ Bind to clear the LCD
.equ Print, 0x205                       @ Bind to print an Integer on the LCD
.equ PrintS,0x204                       @ Bind to print a String on the LCD

.text

    str_an: .asciz  "Data in memory:"
    str_dn: .asciz  "Data written in memory:"


.align
swi Clear                               @ Clear de LCD

mov r0, #1                              @ Postioning the 'x' and 'y' to print the
mov r1, #1                              @ Strings defined as 'str_an' and 'str_dn'
ldr r2, =str_an
swi PrintS
mov r1, #6
ldr r2, =str_dn
swi PrintS


mov r0, #1                              @ Positioning 'x' for 'print'
mov r1, #2                              @ Positioning 'y' for 'print'

ldr r3, =BLOCK1                         @ Reading in r3 the data present in 'BLOCK1'
ldr r4, =BLOCK2                         @ Reading in r3 the data present in 'BLOCK1'
mov r5, #3                              @ The number of variables in 'BLOCK'


Prt:                                    @ Printing the BLOCK1
    ldr r2, [r3], #0x04                 @ Puting in r2 the value in r3, and jumping one 4 bytes
    swi Print                           @ (It's jumping 4 bytes becuse the array present in .data is
    add r1, r1, #1                      @ a .word type, which is 32 bits, but there're halfword and bytes)
    subs r5, r5, #1                     @ Subs, besides sub, do a comparation with #0, so you can use 'batch'
    bne Prt                             @ for it, the bne represents "Batch not equal"

ldr r3, =BLOCK1                         @ Loads again to reset the positions
add r1, r1, #2                          @ For print
mov r5, #3                              @ Setting the loop again

Write:                                  @ This will read and write in memory
    ldr r2, [r3], #0x4                  @ Read
    str r2, [r4], #0x4                  @ This one will write in [r4] (value) the r2, and will walk 4 bytes
    subs r5, r5, #1                     
    bne Write

mov r2, #0                              @ Just to erase the trash inside
mov r5, #3

ldr r4, =BLOCK2                         @ Loads again to reset the positions

Read:
    ldr r2, [r4], #0x4                  @ This one will read in r2 the value in [r4], walking 4 bytes
                                        @ If you want the expecific position use "ldr r2, [r4, #0x0]"
                                        @ where the #0x0 is the position, so can be #0x0, #0x4, #0x8 so on
                                        @ knowing that you're using .word as array of 32 bits (can be .hword or .byte)
    swi Print
    add r1, r1, #1
    subs r5, r5, #1                     @ Do a sub and make a comparation with 0, until that still on the loop
    bne Read


.data                                   @ They need to be in hex if you use the .word (32 bits)
    BLOCK1: .word 0x01, 0x01, 0x7D0     @ The 'read' memory
    BLOCK2: .word 0, 0, 0               @ The 'write' memory

.end