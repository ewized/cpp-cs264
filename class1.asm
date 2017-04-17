  .data
str:
  .asciiz "JoshuaDanielRodriguez"
nl:
  .asciiz "\n"
  .globl main
  .text

main:
  la $a0, str
  jal func

  move $a0, $v0
  li $v0, 1
  syscall

  la $a0, nl
  li $v0, 4
  syscall

  move $a0, $v1
  li $v0, 1
  syscall

  li $v0, 10
  syscall


func:
  li $v0, 0 # upper
  li $v1, 0 # lower
loop:
  lb $t0, 0($a0)
  bne $t0, $0, next
  jr $ra
next:
  addi $a0 $a0, 1
  addi $t1, $t0, -96
  bltz $t1, upper
lower:
  addi $v1, $v1, 1
  j loop
upper:
  addi $v0, $v0, 1
  j loop
