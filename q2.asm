#---------------------------------------------------------------
# Autor: Pedro Valença Ferraz
# Data: 07/11/2025 - 21:03
# Programa: Conversão decimal para binário com sinal (16 bits)
#---------------------------------------------------------------

.data
msg:    .asciiz "\nDigite um número decimal (-32768 a 32767): "
res:    .asciiz "\nRepresentação em complemento a 2 (16 bits): "

.text
.globl main

main:
    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    li $v0, 4
    la $a0, res
    syscall

    andi $t1, $t0, 0xFFFF   # garante 16 bits

    li $t2, 15
print_loop:
    bltz $t2, end_prog
    srl $t3, $t1, $t2
    andi $t3, $t3, 1
    li $v0, 11
    add $a0, $t3, 48
    syscall
    addi $t2, $t2, -1
    j print_loop

end_prog:
    li $v0, 10
    syscall
