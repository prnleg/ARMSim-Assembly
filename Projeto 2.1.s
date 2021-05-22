@ Projeto 2 v1.1
@ André L. G. Santos, Erick H. Dircksen
@
@ Disclaimer:
@ O código e os comentários estão em ingles porque eu os postei no github para que
@ possa ser usado por outra pessoa, assim como o repositório inteiro.

@ O
@
@
@
@
@
@
@
@
@
@

.equ RedLed, 0x201                          @ Bind for the Red LED's
.equ Segm,   0x200                          @ Bind to print 8-Seg
.equ PrintS, 0x204                          @ Bind to print a String on the LCD
.equ Print,  0x205                          @ Bind to print an Integer on the LCD
.equ Clear,  0x206                          @ Bind to clear the LCD
.equ Ticks,  0x6d                           @ Bind to get time in r0, but in miliseconds
.equ BlueB,  0x203                          @ Bind to get Blue Button pressed number
.equ BlackB, 0x202                          @ Bind to get Black Button pressed number
.equ ClearL, 0x208                          @ Bind to Clear the entire line

@ Bind for each segment of the 8 segments display
.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01
.equ SEG_P,0x10

@ Where the Strings are setted
.text

    @ Bind the strings that will be used "name: .format "String""
    str_barra: .asciz   "-  -"
    str_ponto: .asciz   ":  :"
    str_pont:  .asciz   ":"
    str_alarm: .asciz   "<- 3.3 Ajuste"
    str_ajust: .asciz   "<- 2.3 Alarme/Clock"
    str_bar:   .asciz   "-"
    str_blank: .asciz   " "

@ Where the 8 segment digits are defined
Digits:

    .word SEG_A|SEG_G|SEG_B|SEG_F|SEG_E|SEG_C       @ [A] Alarme #1
    .word SEG_A|SEG_G|SEG_E|SEG_D                   @ [C] Clock  #2


.align

swi Clear                                           @ Clear the Display, if it's anything left there
mov r0, #0x00
swi RedLed


mov r0, #0                                          @ Starting with #0 so it won't take any trash
mov r1, #1
mov r2, #0

mov r3, #0                                          @ =DATA
mov r4, #0                                          @ Blue Button index/Tick Counter
mov r5, #1                                          @ "-" for the edit
mov r7, #0                                          @ Alarm compare


mov r9, #0                                          @ Timer counter

@    |0|1|-|0|1|-|2|0|0|0 |  | 1| 2| :| 0| 0| :| 0| 0| Position for r0 in Print
@  |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19| 


mov r0, #3                                          @ Setting the - on LCD
ldr r2, =str_barra
swi PrintS

mov r0, #14                                         @ Setting the : on LCD
ldr r2, =str_ponto
swi PrintS

mov r0, #0                                          @ Showing the button that need
mov r1, #7                                          @ to be pressed
ldr r2, =str_ajust
swi PrintS
mov r1, #10
ldr r2, =str_alarm
swi PrintS

mov r0, #3
mov r1, #1


@ The Date print and the Time print
PrDate:
    ldr r1, =Digits                                 @ Loads in 'r1' the array of Digits
    mov r0, #1                                      @ Select the first (C)
    ldr r0, [r1, r0, lsl#2]                         @ Loads in 'r0' the array 'r1' with 
    swi Segm                                        @ the 'r0' position of the array
    mov r1, #1
    ldr r3, =DATA                                   @ Loads in 'r3' the memory of the
    mov r0, #1                                      @ Date and Hour
    ldr r2, [r3, #0x00]                             @ From here the [] represents the 
    swi Print                                       @ value in 'r3' and the hex number
    mov r0, #2                                      @ is the position of the array
    ldr r2, [r3, #0x04]
    swi Print
    mov r0, #4
    ldr r2, [r3, #0x08]
    swi Print
    mov r0, #5
    ldr r2, [r3, #0x0C]
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
    mov r1, #1
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

@ The Alarm print
PrAlar:
    mov r0, #1
    swi ClearL                                      @ Clear the line
    mov r0, #14                                     @ Set the : on LCD
    ldr r2, =str_pont
    swi PrintS
    mov r0, #0                                      @ Select the first (A)
    ldr r1, =Digits                                 @ Loads in 'r1' the array of Digits
    ldr r0, [r1, r0, lsl#2]                         @ Loads in 'r0' the array 'r1' with 
    swi Segm                                        @ the 'r0' position of the array
    mov r1, #1
    mov r0, #12
    ldr r2, [r3, #0x38]
    swi Print
    mov r0, #13
    ldr r2, [r3, #0x3C]
    swi Print
    mov r0, #15
    ldr r2, [r3, #0x40]
    swi Print
    mov r0, #16
    ldr r2, [r3, #0x44]
    swi Print
    bal Alarm

Start:
    swi Ticks                                       @ Puts on r0 the first value of Tick
    mov r4, r0                                      @ Moves to r9
    bal Ini

Ini:
    mov r7, #0
    mov r0, #0x00
    swi RedLed
    swi BlueB                                       @ Check if the Bluebutton was pressed
    cmp r0, #0x8000                                 @ Compare with '3.3'
    beq PrintData                                   @ Goes to Button Ajust
    cmp r0, #0x800                                  @ Compare with '2.3'
    beq PrAlar                                      @ Goes to Alarm
    ldr r0, [r3, #0x44]
    ldr r1, [r3, #0x2C]
    cmp r0, r1
    beq Comp1
    cmp r7, #0
    bne Blink                                       @ If not, just continue with the clock

Comp1:
    ldr r0, [r3, #0x40]
    ldr r1, [r3, #0x28]
    cmp r0, r1
    beq Comp2
    bne Clock

Comp2:
    ldr r0, [r3, #0x3C]
    ldr r1, [r3, #0x24]
    cmp r0, r1
    beq Comp3
    bne Clock
    
Comp3:
    ldr r0, [r3, #0x38]
    ldr r1, [r3, #0x20]
    cmp r0, r1
    beq Blink
    bne Clock

Blink:
    ldr r0, [r3, #0x30]
    cmp r0, #0
    bgt Clock
    mov r0, #0x03
    swi RedLed
    add r7, r7, #1
    cmp r7, #10
    ble Clock
    bgt Clock

Alarm:
    swi BlueB                                       @ Check if the Bluebutton was pressed
    cmp r0, #0x800                                  @ Compare with '2.3'
    beq Out                                         @ If true goes out of Clock
    bne Alarm                                       @ If false will stay in loop

Clock:
    swi Ticks                                       @ Puts on r0 the first value of Tick
    sub r0, r0, r4                                  @ Subtract from the first tick
    cmp r0, #1000                                   @ Compares with 1000ms (1sec)
    bgt Count                                       @ If true goes to 'Counter'
    bne Clock                                       @ If false return to the loop until complete 1 second

Count:
    ldr r9, [r3, #0x34]
    cmp r9, #9                                      @ Compare if it's the last number
    bge Seconds                                     @ If True goes to Minute
    add r9, r9, #1                                  @ Else r9++ and goes
    str r9, [r3, #0x34]
    bal PrDate

Seconds:
    mov r9, #0
    str r9, [r3, #0x34]
    ldr r9, [r3, #0x30] 
    cmp r9, #5                                      @ Compare if it's the last number
    bge Minutes1                                    @ If True goes to Minute
    add r9, r9, #1                                  @ Else r9++ and goes
    str r9, [r3, #0x30]
    mov r9, #0
    bal PrDate

Minutes1:
    mov r9, #0
    str r9, [r3, #0x30]
    ldr r9, [r3, #0x2C]
    cmp r9, #9
    bge Minutes2
    add r9, r9, #1
    str r9, [r3, #0x2C]
    mov r9, #0
    bal PrDate

Minutes2:
    mov r9, #0
    str r9, [r3, #0x2C]
    ldr r9, [r3, #0x28]
    cmp r9, #5
    bge Hours1
    add r9, r9, #1
    str r9, [r3, #0x28]
    mov r9, #0
    bal PrDate

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
    bal PrDate

Hours2:
    mov r9, #0
    str r9, [r3, #0x28]
    ldr r9, [r3, #0x24]
    cmp r9, #3
    bge Hours3
    add r9, r9, #1
    str r9, [r3, #0x24]
    mov r9, #0
    bal PrDate
    

Hours3:
    mov r9, #0
    str r9, [r3, #0x24]
    ldr r9, [r3, #0x20]
    cmp r9, #2
    bge Days1
    add r9, r9, #1
    str r9, [r3, #0x20]
    mov r9, #0
    bal PrDate

Days1:
    mov r9, #0
    str r9, [r3, #0x20]
    ldr r9, [r3, #0x04]
    cmp r9, #9
    bge Days2
    add r9, r9, #1
    str r9, [r3, #0x04]
    mov r9, #0
    bal PrDate

Days2:
    mov r9, #1
    str r9, [r3, #0x04]
    ldr r9, [r3, #0x00]
    cmp r9, #2
    bge Month1
    add r9, r9, #1
    str r9, [r3, #0x0]
    mov r9, #0
    bal PrDate

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
    bal PrDate

Month2:
    mov r9, #0
    str r9, [r3, #0x00]
    ldr r9, [r3, #0x0C]
    cmp r9, #2
    bge Month3
    add r9, r9, #1
    str r9, [r3, #0x0C]
    mov r9, #0
    bal PrDate

Month3:
    mov r9, #1
    str r9, [r3, #0x0C]
    ldr r9, [r3, #0x08]
    cmp r9, #1
    bge Year1
    add r9, r9, #1
    str r9, [r3, #0x08]
    mov r9, #0
    bal PrDate


Year1:
    mov r9, #0
    str r9, [r3, #0x08]
    ldr r9, [r3, #0x1C]
    cmp r9, #9
    bge Year2
    add r9, r9, #1
    str r9, [r3, #0x1C]
    mov r9, #0
    bal PrDate

Year2:
    mov r9, #0
    str r9, [r3, #0x1C]
    ldr r9, [r3, #0x18]
    cmp r9, #9
    bge Year3
    add r9, r9, #1
    str r9, [r3, #0x18]
    mov r9, #0
    bal PrDate

Year3:
    mov r9, #0
    str r9, [r3, #0x18]
    ldr r9, [r3, #0x14]
    cmp r9, #9
    bge Year4
    add r9, r9, #1
    str r9, [r3, #0x14]
    mov r9, #0
    bal PrDate

Year4:
    mov r9, #0
    str r9, [r3, #0x14]
    ldr r9, [r3, #0x10]
    cmp r9, #9
    bge Zero
    add r9, r9, #1
    str r9, [r3, #0x10]
    mov r9, #0
    bal PrDate

Zero:
    mov r9, #0
    str r9, [r3, #0x10]
    bal PrDate


Black:
    mov r0, r5
    mov r1, #2
    ldr r2, =str_bar
    swi PrintS
    swi BlackB
    cmp r0, #0x02
    beq BlackD
    cmp r0, #0x01
    beq BlackE
    swi BlueB
    cmp r0, #0
    beq Black
    bne BlueButton

BlueButton:
    cmp r0, #0x01
    mov r9, #0x01
    beq Store
    cmp r0, #0x02
    mov r9, #0x02
    beq Store
    cmp r0, #0x04
    mov r9, #0x03
    beq Store
    cmp r0, #0x10
    mov r9, #0x04
    beq Store
    cmp r0, #0x20
    mov r9, #0x05
    beq Store
    cmp r0, #0x40
    mov r9, #0x06
    beq Store
    cmp r0, #0x100
    mov r9, #0x07
    beq Store
    cmp r0, #0x200
    mov r9, #0x08
    beq Store
    cmp r0, #0x400
    mov r9, #0x09
    beq Store
    cmp r0, #0x2000
    mov r9, #0x0
    beq Store
    cmp r0, #0x8000
    beq Out
    bne Black

Out:
    mov r0, #1
    swi ClearL
    mov r0, #2
    swi ClearL
    mov r0, #3
    mov r1, #1
    ldr r2, =str_barra
    swi PrintS
    mov r0, #14
    ldr r2, =str_ponto
    swi PrintS
    bal Ini

Store:
    cmp r5, #1
    mov r6, #0x00
    beq StoreVer
    cmp r5, #2
    mov r6, #0x04
    beq StoreVer
    cmp r5, #4
    mov r6, #0x08
    beq StoreVer
    cmp r5, #5
    mov r6, #0x0C
    beq StoreVer
    cmp r5, #7
    mov r6, #0x10
    beq StoreVer
    cmp r5, #8
    mov r6, #0x14
    beq StoreVer
    cmp r5, #9
    mov r6, #0x18
    beq StoreVer
    cmp r5, #10
    mov r6, #0x1C
    beq StoreVer
    cmp r5, #12
    mov r6, #0x20
    beq StoreVer
    cmp r5, #13
    mov r6, #0x24
    beq StoreVer
    cmp r5, #15
    mov r6, #0x28
    beq StoreVer
    cmp r5, #16
    mov r6, #0x02C
    beq StoreVer
    cmp r5, #18
    mov r6, #0x30
    beq StoreVer
    cmp r5, #19
    mov r6, #0x034
    beq StoreVer
    cmp r5, #21
    mov r6, #0x38
    beq StoreVer
    cmp r5, #22
    mov r6, #0x3C
    beq StoreVer
    cmp r5, #24
    mov r6, #0x40
    beq StoreVer
    cmp r5, #25
    mov r6, #0x44
    beq StoreVer

StoreVer:
    str r9, [r3, r6]
    bal PrintData

BlackD:
    cmp r5, #1
    blt AddMM
    cmp r5, #25  @ Trocar dps pra posição do 'y'
    bge Black
    bal ClearD

BlackE:
    cmp r5, #26  @ Trocar dps pra posição do 'y'
    bgt SubMM
    cmp r5, #1
    ble Black
    bal ClearE

AddMM:
    add r5, r5, #1
    cmp r5, #3
    beq AddMM
    cmp r5, #6
    beq AddMM
    cmp r5, #11
    beq AddMM
    cmp r5, #14
    beq AddMM
    cmp r5, #17
    beq AddMM
    cmp r5, #20
    beq AddMM
    cmp r5, #23
    beq AddMM
    bal PrtD

SubMM:
    sub r5, r5, #1
    cmp r5, #23
    beq SubMM
    cmp r5, #20
    beq SubMM
    cmp r5, #17
    beq SubMM
    cmp r5, #14
    beq SubMM
    cmp r5, #11
    beq SubMM
    cmp r5, #6
    beq SubMM
    cmp r5, #3
    beq SubMM
    bal PrtE

ClearD:
    mov r0, r5
    mov r1, #2
    ldr r2, =str_blank
    swi PrintS
    bal AddMM

ClearE:
    mov r0, r5
    mov r1, #2
    ldr r2, =str_blank
    swi PrintS
    bal SubMM

PrtD:
    mov r0, r5
    ldr r2, =str_bar
    swi PrintS
    bal Black

PrtE:
    mov r0, r5
    ldr r2, =str_bar
    swi PrintS
    bal Black

PrintData:
    mov r1, #1
    mov r0, #1
    ldr r2, [r3, #0x00]
    swi Print
    mov r0, #2
    ldr r2, [r3, #0x04]
    swi Print
    mov r0, #4
    ldr r2, [r3, #0x08]
    swi Print
    mov r0, #5
    ldr r2, [r3, #0x0C]
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
    mov r0, #21
    ldr r2, [r3, #0x38]
    swi Print
    mov r0, #22
    ldr r2, [r3, #0x3C]
    swi Print
    mov r0, #23
    ldr r2, =str_pont
    swi PrintS
    mov r0, #24
    ldr r2, [r3, #0x40]
    swi Print
    mov r0, #25
    ldr r2, [r3, #0x44]
    swi Print
    mov r1, #2
    bal Black


.data @ .word represents 4 bytes of memory storage. This one Starts with 01-01-2000 12:00:00 if it can't pick it up from the system

    DATA:  .word    0x02, 0x09, 0x01, 0x02, 0x09, 0x09, 0x09, 0x09, 0x02, 0x03, 0x05, 0x09, 0x05, 0x05, 0x00, 0x00, 0x00, 0x00
@                       2    9  -  1     2  -  2     0     0     0     2     3  :  5     9  :  5     5     0     6:    0     0
@                   0x00 |0x04 |0x08 |0x0C |0x10 |0x14 |0x18 |0x1C |0x20 |0x24 |0x28 |0x2C |0x30 |0x34  | 0x38| 0x3C| 0x40| 0x44
.end