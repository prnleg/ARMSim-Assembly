@ Projeto 2 v1.1
@ André L. G. Santos, Erick H. Dircksen

.equ Segm,0x200                             @ Bind to print 8-Seg
.equ PrintS,0x204                           @ Bind to print a String on the LCD
.equ Print,0x205                            @ Bind to print an Integer on the LCD
.equ Clear,0x206                            @ Bind to clear the LCD
.equ Ticks,0x6d                             @ Bind to get time in r0, but in miliseconds
.equ Botao,0x202                            @ Bind to get Blue Button press number

.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01
.equ SEG_P,0x10

.text

    str_barra: .asciz   "-  -"
    str_ponto: .asciz   ":  :"
    str_alarm: .asciz   "<- Alarme/Clock"
    str_ajust: .asciz   "<- Ajuste"

Digits:

    .word SEG_A|SEG_G|SEG_B|SEG_F|SEG_E|SEG_C       @ [A] Alarme
    .word SEG_A|SEG_G|SEG_E|SEG_D                   @ [C] Clock


.align

swi Clear                                           @ Clear the Display, if it's anything left there

mov r0, #0                                          @ Starting with #0 so it won't take any trash
mov r1, #1
mov r2, #0

mov r9, #0                                          @ The seconds counter
mov r8, #0                                          @ The minutes counter
mov r7, #0                                          @ The hours counter

mov r4, #0                                          @ Tick counter

@    |0|1|-|0|1|-|2|0|0|0 |  | 1| 2| :| 0| 0| :| 0| 0| Position for r0 in Print
@  |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19| 


mov r0, #3
ldr r2, =str_barra
swi PrintS

mov r0, #14
ldr r2, =str_ponto
swi PrintS

mov r0, #0
mov r1, #7
ldr r2, =str_ajust
swi PrintS
mov r1, #10
ldr r2, =str_alarm
swi PrintS

mov r0, #3
mov r1, #1

PrDate:
    ldr r3, =DATA
    mov r0, #1
    ldr r2, [r3, #0x0]
    swi Print
    mov r0, #2
    ldr r2, [r3, #0x4]
    swi Print
    mov r0, #4
    ldr r2, [r3, #0x8]
    swi Print
    mov r0, #5
    ldr r2, [r3, #0xC]
    swi Print
    mov r0, #7
    ldr r2, [r3, #0x10]
    swi Print
    mov r0, #8
    ldr r2, [r3, #0x14]
    swi Print
    mov r0, #9
    ldr r2, [r3, #0x18]
    swi Print
    mov r0, #10
    ldr r2, [r3, #0x1C]
    swi Print
    b   PrTime

PrTime:
    mov r0, #12
    ldr r2, [r3, #0x20]
    swi Print
    mov r0, #13
    ldr r2, [r3, #0x24]
    swi Print
    mov r0, #15
    ldr r2, [r3, #0x28]
    swi Print
    mov r0, #16
    ldr r2, [r3, #0x2C]
    swi Print
    mov r0, #18
    ldr r2, [r3, #0x30]
    swi Print
    mov r0, #19
    ldr r2, [r3, #0x34]
    swi Print
    b   Start

Start:
    swi Ticks                                       @ Puts on r0 the first value of Tick
    mov r4, r0                                      @ Moves to r8
    bal Clock

Clock:
    swi Ticks                                       @ Puts on r0 the first value of Tick
    sub r0, r0, r4                                  @ Subtract from the first tick
    cmp r0, #1000                                   @ Compares with 1000ms (1sec)
    bgt Count                                       @ If true goes to 'Counter'
    bne Clock                                       @ If false return to the loop until complete 1 second

Count:
    ldr r9, [r3, #0x34]
    cmp r9, #9                                     @ Compare if it's the last number
    bge Seconds                                    @ If True goes to Minute
    add r9, r9, #1                                 @ Else r9++ and goes
    str r9, [r3, #0x34]
    b   PrTime

Seconds:
    mov r9, #0
    str r9, [r3, #0x34]
    ldr r9, [r3, #0x30] 
    cmp r9, #5                                     @ Compare if it's the last number
    bge Minutes1                                   @ If True goes to Minute
    add r9, r9, #1                                 @ Else r9++ and goes
    str r9, [r3, #0x30]
    mov r9, #0
    b   PrTime

Minutes1:
    mov r9, #0
    str r9, [r3, #0x30]
    ldr r9, [r3, #0x2C]
    cmp r9, #9
    bge Minutes2
    add r9, r9, #1
    str r9, [r3, #0x2C]
    mov r9, #0
    b   PrTime

Minutes2:
    mov r9, #0
    str r9, [r3, #0x2C]
    ldr r9, [r3, #0x28]
    cmp r9, #5
    bge Hours1
    add r9, r9, #1
    str r9, [r3, #0x28]
    mov r9, #0
    b   PrTime

Hours1:
    ldr r9, [r3, #0x20]                             @ Load Second counter for hour
    cmp r9, #2                                      @ If it's 20:00:00
    bge Hours2                                      @ Goes to Hour2
    mov r9, #0
    str r9, [r3, #0x28]                             @ Store 0 in Second counter for minute
    ldr r9, [r3, #0x24]                             @ Load First counter for Hour
    cmp r9, #9                                      @ If it's 9, like 9:00:00 or 19:00:00
    bge Hours3                                      @ Goes to Hour 3
    add r9, r9, #1                                  @ Else, r9++
    str r9, [r3, #0x24]                             @ Store in the First counter for Hour
    mov r9, #0                                      @ Goes to 0
    b   PrTime

Hours2:
    mov r9, #0
    str r9, [r3, #0x28]
    ldr r9, [r3, #0x24]
    cmp r9, #3
    bge Hours3
    add r9, r9, #1
    str r9, [r3, #0x24]
    mov r9, #0
    b   PrTime
    

Hours3:
    mov r9, #0
    str r9, [r3, #0x24]
    ldr r9, [r3, #0x20]
    cmp r9, #2
    bge Days1
    add r9, r9, #1
    str r9, [r3, #0x20]
    mov r9, #0
    b   PrDate

Days1:
    mov r9, #0
    str r9, [r3, #0x20]
    ldr r9, [r3, #0x04]
    cmp r9, #9
    bge Days2
    add r9, r9, #1
    str r9, [r3, #0x04]
    mov r9, #0
    b   PrDate

Days2:
    mov r9, #1
    str r9, [r3, #0x04]
    ldr r9, [r3, #0x00]
    cmp r9, #2
    bge Month1
    add r9, r9, #1
    str r9, [r3, #0x0]
    mov r9, #0
    b   PrDate

Month1:
    ldr r9, [r3, #0x08]                             @ Load Second counter for month 00:10:2000
    cmp r9, #1                                      @ If it's 1
    bge Month2                                      @ Goes to Month2
    mov r9, #0                                      
    str r9, [r3, #0x00]                             @ Store 0 in the First Counter of Days
    ldr r9, [r3, #0x0C]                             @ Load the Second counter for the month
    cmp r9, #9                                      @ Compraes if it's 9, like 01-09-2000
    bge Month3                                      @ If true, goes to Month3
    add r9, r9, #1                                  @ Else r9++
    str r9, [r3, #0x0C]
    mov r9, #0
    b   PrDate

Month2:
    mov r9, #0
    str r9, [r3, #0x00]
    ldr r9, [r3, #0x0C]
    cmp r9, #2
    bge Month3
    add r9, r9, #1
    str r9, [r3, #0x0C]
    mov r9, #0
    b   PrDate

Month3:
    mov r9, #1
    str r9, [r3, #0x0C]
    ldr r9, [r3, #0x08]
    cmp r9, #1
    bge Year1
    add r9, r9, #1
    str r9, [r3, #0x08]
    mov r9, #0
    b   PrDate


Year1:
    mov r9, #0
    str r9, [r3, #0x08]
    ldr r9, [r3, #0x1C]
    cmp r9, #9
    bge Year2
    add r9, r9, #1
    str r9, [r3, #0x1C]
    mov r9, #0
    b   PrDate

Year2:
    mov r9, #0
    str r9, [r3, #0x1C]
    ldr r9, [r3, #0x18]
    cmp r9, #9
    bge Year3
    add r9, r9, #1
    str r9, [r3, #0x18]
    mov r9, #0
    b   PrDate

Year3:
    mov r9, #0
    str r9, [r3, #0x18]
    ldr r9, [r3, #0x14]
    cmp r9, #9
    bge Year4
    add r9, r9, #1
    str r9, [r3, #0x14]
    mov r9, #0
    b   PrDate

Year4:
    mov r9, #0
    str r9, [r3, #0x14]
    ldr r9, [r3, #0x10]
    cmp r9, #9
    bge Zero
    add r9, r9, #1
    str r9, [r3, #0x10]
    mov r9, #0
    b   PrDate

Zero:
    mov r9, #0
    str r9, [r3, #0x10]
    b PrDate

BlueButt:


Ajust:



.data @ .word represents 4 bytes of memory storage. This one Starts with 01-01-2000 12:00:00 if it can't pick it up from the system

    DATA:  .word    0x02, 0x09, 0x01, 0x02, 0x09, 0x09, 0x09, 0x09, 0x02, 0x03, 0x05, 0x09, 0x05, 0x05
@                       2    9  -  1     2  -  2     0     0     0     2     3  :  5     9  :  5     5
@                   0x00 |0x04 |0x08 |0x0C |0x10 |0x14 |0x18 |0x1C |0x20 |0x24 |0x28 |0x2C |0x30 |0x34
.end