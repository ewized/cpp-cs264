  .data
arr:
  .word 4, 0, -4, 2, -8
  .globl main
  .text

main:
  la $a0, arr
  li $a1, 5
  jal func

  move $a0, $v0
  li $v0, 1
  syscall

  li $v0, 10
  syscall

func: # Return the number of numbers that are even and negative
  move $t8, $a0 # Address
  move $t9, $a1 # Length
  li $v0, 0
f_loop:
  beq $t9, $0, f_return
  lw $t1, 0($t8)
  bgez $t1, f_next
  rem $t2, $t1, 2
  bnez $t2, f_next
  addi $v0, $v0, 1
f_next:
  addi $t8, $t8, 4
  addi $t9, $t9, -1
  j f_loop
f_return:
  jr $ra
