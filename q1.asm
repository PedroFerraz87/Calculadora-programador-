#---------------------------------------------------------------
# Autor: Pedro Valença Ferraz
# Data: 07/11/2025 - 20:55
# Programa: Conversão de número decimal para bases 2, 8, 16 e BCD
#---------------------------------------------------------------

.data
msg:        .asciiz "\nDigite um número decimal: "
bin_msg:    .asciiz "\nBase 2: "
oct_msg:    .asciiz "\nBase 8: "
hex_msg:    .asciiz "\nBase 16: "
bcd_msg:    .asciiz "\nBCD: "

.text
.globl main

main:
    # Entrada do número decimal
    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 5
    syscall
    move $t0, $v0       # t0 = número decimal

    # --- Base 2 ---
    li $v0, 4
    la $a0, bin_msg
    syscall
    move $a0, $t0
    jal dec_to_bin

    # --- Base 8 ---
    li $v0, 4
    la $a0, oct_msg
    syscall
    move $a0, $t0
    jal dec_to_oct

    # --- Base 16 ---
    li $v0, 4
    la $a0, hex_msg
    syscall
    move $a0, $t0
    jal dec_to_hex

    # --- BCD ---
    li $v0, 4
    la $a0, bcd_msg
    syscall
    move $a0, $t0
    jal dec_to_bcd

    li $v0, 10
    syscall

#-------------------------------------
# Função dec_to_bin
#-------------------------------------
dec_to_bin:
    move $t1, $a0
    li $t2, 0
    li $t3, 1

print_bits:
    bge $t3, 32768, end_bin
    sll $t4, $t1, 1
    bltz $t4, print1
    li $v0, 11
    li $a0, '0'
    syscall
    j next_bit
print1:
    li $v0, 11
    li $a0, '1'
    syscall
next_bit:
    sll $t1, $t1, 1
    sll $t3, $t3, 1
    j print_bits
end_bin:
    jr $ra

#-------------------------------------
# Função dec_to_oct
#-------------------------------------
dec_to_oct:
    move $t1, $a0
    li $t2, 8
    li $sp, 0x7ffffffc
    move $t3, $sp
oct_loop:
    beqz $t1, oct_print
    divu $t1, $t2
    mfhi $t4
    addiu $sp, $sp, -4
    sw $t4, 0($sp)
    mflo $t1
    j oct_loop
oct_print:
    beq $sp, $t3, end_oct
    lw $t5, 0($sp)
    addiu $sp, $sp, 4
    li $v0, 1
    move $a0, $t5
    syscall
    j oct_print
end_oct:
    jr $ra

#-------------------------------------
# Função dec_to_hex
#-------------------------------------
dec_to_hex:
    move $t1, $a0
    li $t2, 16
    li $sp, 0x7ffffffc
    move $t3, $sp
hex_loop:
    beqz $t1, hex_print
    divu $t1, $t2
    mfhi $t4
    addiu $sp, $sp, -4
    sw $t4, 0($sp)
    mflo $t1
    j hex_loop
hex_print:
    beq $sp, $t3, end_hex
    lw $t5, 0($sp)
    addiu $sp, $sp, 4
    blt $t5, 10, hex_num
    addi $t5, $t5, 55
    li $v0, 11
    move $a0, $t5
    syscall
    j hex_print
hex_num:
    addi $t5, $t5, 48
    li $v0, 11
    move $a0, $t5
    syscall
    j hex_print
end_hex:
    jr $ra

#-------------------------------------
# Função dec_to_bcd
#-------------------------------------
dec_to_bcd:
    move $t1, $a0
    beqz $t1, end_bcd
bcd_loop:
    rem $t2, $t1, 10
    li $v0, 1
    move $a0, $t2
    syscall
    div $t1, $t1, 10
    bnez $t1, bcd_loop
end_bcd:
    jr $ra