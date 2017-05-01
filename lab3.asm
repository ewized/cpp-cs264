# Joshua Rodriguez
# Lab 3
# Due 5/1/2017
#
  .data
mem:
  .space 100
freq:
  .asciiz "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ"
prompt:
  .asciiz "Enter a string up to 80 chars: "
nl:
  .asciiz "\n"
space:
  .asciiz " "
is_p:
  .asciiz " is a Palindrome (1 = true, 0 = false)? "
p_1:
  .asciiz "asddsa"
p_2:
  .asciiz "qweqwe"
p_3:
  .asciiz "zxcvbn"
p_4:
  .asciiz "racecar"
  .globl main
  .text

main:
  # Print the prompt
  la $a0, prompt
  jal p_str

  # Read the string and store it in $t1
  li $v0, 8
  la $a0, mem
  li $a1, 80
  syscall
  move $t8, $a0

  # Print out what they wrote, note $a0 still contains the string
  #jal p_str


  # Loop through a-z A-Z
  # Temp char in $t6
  # Temp str char in $t7
  # Read the string in $t8
  # Count each char in $t9
  # Print out the letter and the frequency
  la $t5, freq
f_do:
  lb $t6, 0($t5)
  beq $t6, $0, f_next

  move $t4, $t8
  li $t9, 0
f_loop_str:
  lb $t7, 0($t4)
  addi $t4, $t4, 1

  beq $t6, $t7, f_add
  j f_loop_next
f_add:
  addi $t9, $t9, 1
f_loop_next:
  bne $t7, $0, f_loop_str


  # Only print if $t9 > 0
  bgtz $t9, f_output
  j f_while

f_output:
  # Print the char and the number of times it appears
  move $a0, $t6
  jal p_char
  la $a0, space
  jal p_str
  move $a0, $t9
  jal p_int
  la $a0, nl
  jal p_str

f_while:
  addi $t5, $t5, 1
  j f_do
f_next:
  nop

  # Check if the three strings are palindrome
  la $a0, p_1
  jal p_str
  jal palindrome
  move $t0, $v0
  la $a0, is_p
  jal p_str
  move $a0, $t0
  jal p_int
  la $a0, nl
  jal p_str

  la $a0, p_2
  jal p_str
  jal palindrome
  move $t0, $v0
  la $a0, is_p
  jal p_str
  move $a0, $t0
  jal p_int
  la $a0, nl
  jal p_str

  la $a0, p_3
  jal p_str
  jal palindrome
  move $t0, $v0
  la $a0, is_p
  jal p_str
  move $a0, $t0
  jal p_int
  la $a0, nl
  jal p_str

  la $a0, p_4
  jal p_str
  jal palindrome
  move $t0, $v0
  la $a0, is_p
  jal p_str
  move $a0, $t0
  jal p_int
  la $a0, nl
  jal p_str

  # End the program
  li $v0,10
  syscall


p_str: # Print a string from $a0
  li $v0, 4
  syscall
  jr $ra

p_char: # Print a string from $a0
  li $v0, 11
  syscall
  jr $ra

p_int: # Print a number from $a0
  li $v0, 1
  syscall
  jr $ra

palindrome: # Return 1 = true or 0 = false
  move $t1, $a0
  move $t2, $a0
  li $t6, 0
  li $v0, 1
p_loop: # Count the number of letters in the string
  lb $t7, 0($t1)
  beq $t7, $0, p_next
  addi $t1, $t1, 1
  addi $t6, $t6, 1
  j p_loop
p_next:
  addi $t1, $t1, -1
  srl $t6, $t6, 1 # Fast way to divide by 2
p_loop_2: # Check if each half of the string is a palindrome
  beq $t6, $0, p_true
  lb $t4, 0($t1)
  lb $t5, 0($t2)
  bne $t4, $t5, p_false
  addi $t1, $t1, -1
  addi $t2, $t2, 1
  addi $t6, $t6, -1
  j p_loop_2
p_true:
  jr $ra
p_false:
  li $v0, 0
  jr $ra
