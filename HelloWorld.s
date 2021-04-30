@ Just a simple text printer
@ It will print the "Hello World" in the LC Display

.equ Print,0x204                        @ This is a bind for a swi (Software Instruction),
                                        @ this instruction basically print a String in the LCD

.text                                   @ This specify where the texts are

    str_hello: .asciz "Hello World"     @ 'str_hello' is the variable, asciz is the type and
                                        @ the "Hello World" is the value that variable has

.align                                  @ This specify where the code is

start:                                  @ This is a "Function", you can name it what ever you want

            @ #Number means a Integer value
    mov r0, #0                          @ Alloc r0 to position 'x' 0, or variable r0 recive 0 (r0 = 0)
    mov r1, #0                          @ Alloc r1 to position 'y' 0, or variable r1 recive 0 (r1 = 0)
    ldr r2, =str_hello                  @ Alloc a string value to r2
    swi Print                           @ Will use r0, r1 and r2 as info to print

.end                                    @ You don't actually need to close the program