@ Projeto 2
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

Digits:

    .word SEG_A|SEG_G|SEG_B|SEG_F|SEG_E|SEG_C       @ [A] Alarme
    .word SEG_A|SEG_G|SEG_E|SEG_D                   @ [C] Clock


.align

mov r9, #0                                  @ Inicia Segundos com 0
mov r8, #0                                  @ Inicia Minutos com 0
mov r7, #12                                 @ Inicia Horas com 12

mov r6, #1                                  @ Inicia Dia com 1
mov r5, #1                                  @ Inicia Mes com 1
mov r4, #0x7D0                              @ Inicia Ano com 2000
mov r3, #0                                  @ Variavel auxiliar para Clock/Alarm (0/1)

mov r0, #3                                  @ Inicia com 3 para uso do LCD em 'x'
mov r1, #1                                  @ Inicia com 1 para uso do LCD em 'y'
mov r2, #0                                  @ Inicia com 0 para uso do LCD com o conteúdo sendo 0




PrintEsqueleto:
    swi Clear
    ldr r2, =str_barra
    swi PrintS
    mov r0, #14
    ldr r2, =str_ponto
    swi PrintS



Start:
    ldr r1, =Digits
    ldr r0, [r1, #0, lsl#2]
    swi Segm
    swi Ticks
    mov r2, r0
    bal LoopBotao


LoopBotao:
    swi Botao
    cmp r0, #0x8000
    beq switchBotao
    bne LoopRelo


switchBotao:
    cmp r3, #0
    beq
    mov r3, #1
    b AlarmTime
    bne LoopRelo


AlartTime:
    swi Ticks
    b Alarm


Alarm:
    cmp r0, #0x2710
    beq 

    b LoopRelo


LoopRelo:
    swi Ticks
    sub r0, r0, r2
    cmp r0, #1000
    bne LoopRelo
    beq Relo


Relo:
    cmp r9, #59
    beq AddMin
    bne Printar


AddMin:
    mov r9, #0
    cmp r8, #59
    beq AddHora
    bne Printar


AddHora:
    mov r8, #0
    cmp r7, #23
    beq AddDia
    bne Printar


AddDia:
    mov r7, #1
    cmp r6, #29
    beq AddMes
    bne Printar


AddMes:
    mov r6, #1
    cmp r5, #11
    beq AddAno
    bne Printar


AddAno:
    add r4, r4, #1
    b Printar


Printar:
    mov r0, #1
    mov r1, #1
    mov r2, r6
    swi Print
    mov r0, #4
    mov r2, r5
    swi Print
    mov r0, #7
    mov r2, r4
    swi Print
    mov r0, #12
    mov r2, r7
    swi Print
    mov r0, #15
    mov r2, r8
    swi Print
    mov r0, #18
    mov r2, r9
    swi Print
    b Start
