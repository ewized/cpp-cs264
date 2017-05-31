# Joshua Rodriguez
# Lab 5
# Due 5/31/2017
#

  .data
array:
  .space 20
prompt_array:
  .asciiz "Enter 5 numbers to check smallest value: \n"
prompt_min:
  .asciiz "Min value: "
prompt_c:
  .asciiz "Enter c value: "
prompt_r:
  .asciiz "Enter r value: "
prompt_combo:
  .asciiz "Combo value: "
nl:
  .asciiz "\n"
  .globl main
  .text

main:
  # Test Min Value
  li $t0, 5
  la $t1, array
  la $a0, prompt_array
  jal p_str
read:
  li $v0, 5
  syscall
  sw $v0, 0($t1)
  addi $t1, $t1, 4
  addi $t0, $t0, -1
  bnez $t0, read
  addi $a0, $t1, -20
  li $a1, 0
  li $a2, 4
  jal min
  move $t0, $v0
  la $a0, prompt_min
  jal p_str
  move $a0, $t0
  li $v0, 1
  syscall

  # Print Extra Spaces
  la $a0, nl
  jal p_str
  jal p_str

  # Test Combo Function
  la $a0, prompt_c
  jal p_str
  li $v0, 5
  syscall
  move $t0, $v0
  la $a0, prompt_r
  jal p_str
  li $v0, 5
  syscall
  move $a1, $v0
  move $a0, $t0
  jal combo
  move $t0, $v0
  la $a0, prompt_combo
  jal p_str
  move $a0, $t0
  jal p_int

  # End Program
  li $v0, 10
  syscall


# $a0 = array
# $a1 = low
# $a2 = high
# $t9 = mid
min:
  # Base Case
  bne $a1, $a2, min_rec
  mul $t0, $a1, 4
  add $t0, $a0, $t0
  lw $v0, 0($t0)
  jr $ra
min_rec:
  addiu $sp, $sp, -16 # ra, a1, a2, min, v0
  sw $ra, 0($sp) # Push $ra to stack
  add $t9, $a1, $a2 # low + high
  sra $t9, $t9, 1 # /= 2
  sw $t9, 4($sp) # push mid
  sw $a2, 8($sp) # push max
  move $a2, $t9
  jal min
  sw $v0, 12($sp)
  lw $a2, 8($sp) # pop max
  lw $a1, 4($sp) # pop mid
  addi $a1, $a1, 1
  jal min
  lw $t1, 12($sp) # pop
  blt $v0, $t1, min_else
  move $v0, $t1
min_else:
  lw $ra, 0($sp) # Pop $ra from stack
  addiu $sp, $sp, 16
  jr $ra


# a0 = n
# a1 = r
combo:
  beq $a0, $a1, combo_or
  beqz $a1, combo_or
  j combo_rec
combo_or:
  li $v0, 1
  jr $ra
combo_rec:
  addiu $sp, $sp, -16
  sw $ra, 0($sp) # push address
  addi $a0, $a0, -1
  sw $a0, 4($sp) # push n - 1
  sw $a1, 8($sp) # push r
  jal combo
  sw $v0, 12($sp) # push return
  lw $a0, 4($sp) # pop n - 1
  lw $a1, 8($sp) # pop r
  addi $a1, $a1, -1
  jal combo
  lw $t0, 12($sp) # pop return
  add $v0, $v0, $t0
  lw $ra, 0($sp) # pop address
  addiu $sp, $sp, 16
  jr $ra


p_str:
  li $v0, 4
  syscall
  jr $ra


p_int:
  li $v0, 1
  syscall
  jr $ra
