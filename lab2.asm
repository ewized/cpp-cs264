# Joshua Rodriguez
# Lab 2
# Due Date:  April 24, 2017
#


    .data
array:
    .space 80
prompt:
    .asciiz "Enter 20 integers: \n"
prompt2:
    .asciiz "Numbers that are x % 4 ==0: \n"
p_small:
    .asciiz "Smallest: "
p_large:
    .asciiz "Largest: "
nl:
    .asciiz "\n"

    .globl main
    .text

main:
    li $t0, 20 # Counter for reading in values
    la $t1, array # tmp register for the array location
    la $a0, prompt
    jal p_str

numbers:
    li $v0, 5
    syscall
    sw $v0, 0($t1)
    addi $t1, $t1, 4 # Increment the index
    addi $t0, $t0, -1 # Decrement the counter
    bnez $t0, numbers

    # Call the function
    addi $t1, $t1, -80 # sub to reset back to initial index
    move $a0, $t1
    li $a1, 20
    jal smallestLargest
    # Copy the return values into tmp as they will be overwritten with the print
    move $t2, $v0
    #move $t3, $v1 # Apperently you cant you $v1 for some reason

    # Print the smallest value returned from the function
    la $a0, p_small
    jal p_str
    move $a0, $t2
    jal p_int

    la $a0, nl
    jal p_str

    # Print the largest value returned from the function
    la $a0, p_large
    jal p_str
    move $a0, $t3
    jal p_int

    la $a0, nl
    jal p_str
    la $a0, prompt2
    jal p_str

    # Print all x % 4 == 0
    move $a0, $t1
    li $a1, 20
    jal divisible

    # End the program
    li $v0, 10
    syscall

p_str:
    li $v0, 4
    syscall
    jr $ra

p_int:
    li $v0, 1
    syscall
    jr $ra

smallestLargest:
    lw $v0, 0($a0) # Smallest value
    move $t3, $v0 # Largest value
    move $t6, $a0 # Copy array
    addi $t7, $a1, -1 # Copy array length so we can loop with out changing the args
sl_loop:
    addi $t6, $t6, 4
    lw $t5, 0($t6)
    bgt $t5, $t3, sl_great
    blt $t5, $v0, sl_less
    j sl_next
sl_great:
    move $t3, $t5
    j sl_next
sl_less:
    move $v0, $t5
sl_next:
    addi $t7, $t7, -1
    bnez $t7, sl_loop
    jr $ra

divisible:
    li $t6, 4 # Constant to divide with
    move $t8, $a0 # Copy array
    move $t9, $a1 # Copy array length so we can loop with out changing the args
d_loop:
    beqz $t9, d_next
    lw $t7, 0($t8)
    div $t7, $t6
    mfhi $t7
    beqz $t7, d_print
d_else:
    addi $t9, $t9, -1
    addi $t8, $t8, 4
    j d_loop
d_print:
    lw $a0, 0($t8)
    li $v0, 1
    syscall
    la $a0, nl
    li $v0, 4
    syscall
    j d_else
d_next:
    jr $ra
