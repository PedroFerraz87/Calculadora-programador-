#---------------------------------------------------------------
# Autor: Pedro Valença Ferraz
# Data: 07/11/2025 - 21:05
# Programa: Converter número real em float e double (IEEE 754)
# Mostra sinal, expoente, expoente com viés e fração
#---------------------------------------------------------------

.data
msg:       .asciiz "\nDigite um número real: "
float_msg: .asciiz "\nRepresentação em FLOAT (32 bits): "
double_msg:.asciiz "\nRepresentação em DOUBLE (64 bits): "

.text
.globl main

main:
    # Entrada real
    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 6
    syscall
    mov.s $f0, $f0  # f0 = número real

    # FLOAT
    li $v0, 4
    la $a0, float_msg
    syscall

    mfc1 $t0, $f0
    jal print_32bits

    # DOUBLE
    cvt.d.s $f2, $f0
    li $v0, 4
    la $a0, double_msg
    syscall
    mfc1.d $t0, $f2
    jal print_64bits

    li $v0, 10
    syscall

#----------------------------------
# Função para exibir 32 bits
#----------------------------------
print_32bits:
    li $t1, 31
bit_loop:
    bltz $t1, end32
    srl $t2, $t0, $t1
    andi $t2, $t2, 1
    li $v0, 11
    add $a0, $t2, 48
    syscall
    addi $t1, $t1, -1
    j bit_loop
end32:
    jr $ra

#----------------------------------
# Função para exibir 64 bits
#----------------------------------
print_64bits:
    li $t1, 63
bit64_loop:
    bltz $t1, end64
    dsrl $t2, $t0, $t1
    andi $t2, $t2, 1
    li $v0, 11
    add $a0, $t2, 48
    syscall
    addi $t1, $t1, -1
    j bit64_loop
end64:
    jr $ra
