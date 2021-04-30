@ Just some codes with sum, sub, multiply and function uses
@ Also showing in display

.equ PrintS,0x204                       @ Bind to print a String on the LCD
.equ Print,0x205                        @ Bind to print an Integer on the LCD
.equ Clear,0x206                        @ Bind to clear the LCD

.text                                   

                                        @ 'str_' is the variable, asciz is the type and
                                        @ the "Text Inside" is the value that variable has

    str_ini: .asciz "Arithmetic functions:"
    str_sum: .asciz "Addiction of 1 and 2 is: "
    str_sub: .asciz "Subtraction of 2 and 1 is: "
    str_mul: .asciz "Multiplication of 1 and 2 is: "

.align                                  

@ Setting up some Integers to use on functions
swi Clear                               @ This will clear the LCD
mov r9, #1                              @ Set as value of 1 (r9 = 1)
mov r8, #2                              @ Set as value of 2 (r9 = 2)


Start:
    mov r0, #0                          @ Alloc r0 to position 'x' 0, or variable r0 recive 0 (r0 = 0)
    mov r1, #0                          @ Alloc r1 to position 'y' 0, or variable r1 recive 0 (r1 = 0)
    ldr r2, =str_ini                    @ Alloc a string value to r2 (exclusivelly for string))
    swi PrintS                          @ Will use r0, r1 and r2 as info to print

Sum:
    mov r0, #0                          @ Alloc r0 to position 'x' 0, or variable r0 recive 0 (r0 = 0)
                                        @ In this case you don't need to set 0 on r0, it's already in it from 'Start'
    mov r1, #1                          @ Alloc r1 to position 'y' 0, or variable r1 recive 0 (r1 = 1)
    ldr r2, =str_sum                    @ Setting the string "str_sum" in r2 (r2 = str_sum)
    swi PrintS                          @ Values set on those lines above

    mov r1, #2                          @ Moving 'y' to position 2 (y = 2)
    add r7, r8, r9                      @ 'add' in r7 the sum os r8 and r9 (r7 = r8 + r9)
                                        @ can use numbers as second argument as well

    mov r2, r7                          @ Putting in r2 the value of r7, will be used to print
    swi Print                           @ Print the integer in r2


Sub:
    mov r0, #0                          @ Alloc r0 to position 'x' 0, or variable r0 recive 0 (r0 = 0)
                                        @ In this case you don't need to set 0 on r0, it's already in it from 'Start'
    mov r1, #3                          @ Alloc r1 to position 'y' 3, or variable r1 recive 0 (r1 = 3)
    ldr r2, =str_sub                    @ Setting the string "str_sub" in r2 (r2 = str_sub)
    swi PrintS                          @ Values set on those lines above

    mov r1, #4                          @ Moving 'y' to position 4 (y = 4)
    sub r7, r8, r9                      @ 'sub' the r8 from r9 and putting in r7 (r7 = r9 - r8)
                                        @ can use numbers as second argument as well

    mov r2, r7                          @ Putting in r2 the value os r7, will be used to print
    swi Print                           @ Print the integer in r2


Mult:
    mov r0, #0                          @ Alloc r0 to position 'x' 0, or variable r0 recive 0 (r0 = 0)
                                        @ In this case you don't need to set 0 on r0, it's already in it from 'Start'
    mov r1, #5                          @ Alloc r1 to position 'y' 5, or variable r1 recive 0 (r1 = 5)
    ldr r2, =str_mul                    @ Setting the string "str_mul" in r2 (r2 = str_sub)
    swi PrintS                          @ Values set on those lines above

    mov r1, #6                          @ Moving 'y' to position 6 (y = 6)
    mul r7, r9, r8                      @ 'mul' the r8 from r9 and putting in r7 (r7 = r9 * r8)
                                        @ can use numbers as second argument as well
                                        
    mov r2, r7                          @ Putting in r2 the value os r7, will be used to print
    swi Print                           @ Print the integer in r2


.end