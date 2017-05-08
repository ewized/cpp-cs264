.data
a_str:
.asciiz "A\n"
b_str:
.asciiz "B\n"
.globl main
.text

main:
jal func_a
jal func_b

li $v0, 10
syscall

func_a:
addi $sp, $sp, 4
sw $ra, 0($sp)

li $v0, 4
la $a0, a_str
syscall

lw $ra, 0($sp)
addi $sp, $sp, -4
jr $ra

func_b:
addi $sp, $sp, 4
sw $ra, 0($sp)

li $v0, 4
la $a0, b_str
syscall

lw $ra, 0($sp)
addi $sp, $sp, -4
jr $ra
