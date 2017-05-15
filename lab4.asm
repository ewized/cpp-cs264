# Joshua Rodriguez
# Lab 4
# Due 5/15/2017
#

  .data
records: # This contains the data of the records and the address of the array index
  .space 800
enter_name:
  .asciiz "Enter name: "
enter_age:
  .asciiz "Enter age: "
enter_salary:
  .asciiz "Enter salary: "
view_salary:
  .asciiz " salary: "
view_name:
  .asciiz "name: "
view_age:
  .asciiz " age: "
nl:
  .asciiz "\n"
swap_a:
  .asciiz "swap record: "
swap_b:
  .asciiz "with record: "

  .globl main
  .text

main:
  jal set_starting
store:
  addi $s0, $s0, -1
  move $a0, $s1
  jal store_record
  addi $s1, $s1, 48
  addi $s2, $s2, 4
  la $a0, nl
  jal p_str
  bgtz $s0, store

  # Print the origial records
  jal print_records

  # get the record to swap
  la $a0, nl
  jal p_str
  la $a0, swap_a
  jal p_str
  li $v0, 5
  syscall
  addi $v0, $v0, -1
  mul $s5, $v0, 48

  # Get the other record to swap with
  la $a0, swap_b
  jal p_str
  li $v0, 5
  syscall
  addi $v0, $v0, -1
  mul $s6, $v0, 48

  # Swap the two records
  jal set_starting
  add $a0, $s5, $s1
  add $a1, $s6, $s1
  jal swap_records

  # Print the records again with swapped records
  la $a0, nl
  jal p_str
  jal print_records

  li $v0, 10
  syscall

set_starting:
  la $s1, records # the raw storage of the records
  li $s0, 10 # number of records
  jr $ra

print_records: # prints all the records calling the print_record function
  addi $sp, $sp, 4 # Push $ra to stack
  sw $ra, 0($sp)
  jal set_starting
print:
  addi $s0, $s0, -1
  la $a0, 0($s1)
  jal print_record
  addi $s1, $s1, 48
  bgtz $s0, print
  lw $ra, 0($sp) # Pop $ra from stack
  addi $sp, $sp, -4
  jr $ra

store_record: # Store the record at the address $a0
  addi $sp, $sp, 4 # Push $ra to stack
  sw $ra, 0($sp)
  move $t9, $a0 # Copy the address to store the data

  # Read and store the name
  la $a0, enter_name
  jal p_str
  li $v0, 8
  move $a0, $t9
  li $a1, 40
  syscall

  # Read and store the age
  la $a0, enter_age
  jal p_str
  li $v0, 5
  syscall
  sw $v0, 40($t9)

  # Read and store the salary
  la $a0, enter_salary
  jal p_str
  li $v0, 5
  syscall
  sw $v0, 44($t9)

  move $a0, $t9 # Reset the argument
  lw $ra, 0($sp) # Pop $ra from stack
  addi $sp, $sp, -4
  jr $ra

print_record: # Print the record at the given address at a0
  addi $sp, $sp, 4 # Push $ra to stack
  sw $ra, 0($sp)

  move $t9, $a0 # Copy the address to store the data
  la $a0, view_name # view the name
  jal p_str

  # Print out the string and remove the new line char
  move $t7, $t9
loop:
  lb $t8, 0($t7)
  beq $t8, 10, next
  li $v0, 11
  move $a0, $t8
  syscall
  addi $t7, $t7, 1
  j loop
next:
  la $a0, view_age # print the age
  jal p_str
  lw $a0, 40($t9)
  jal p_int

  la $a0, view_salary # print the salary
  jal p_str
  lw $a0, 44($t9)
  jal p_int

  la $a0, nl # Print the new line
  jal p_str

  lw $ra, 0($sp) # Pop $ra from stack
  addi $sp, $sp, -4
  jr $ra

swap_records: # swap the record at address $a0 with the address of $a1
  li $t6, 12 # Have to run lw 10 times to copy the entire record string
copy:
  lw $t5, 0($a0)
  lw $t4, 0($a1)
  sw $t5, 0($a1)
  sw $t4, 0($a0)
  addi $a0, $a0, 4
  addi $a1, $a1, 4
  addi $t6, $t6, -1
  bgtz $t6, copy
  jr $ra

p_str:
  addi $sp, $sp, 4 # Push $ra to stack
  sw $ra, 0($sp)
  li $v0, 4
  syscall
  lw $ra, 0($sp) # Pop $ra from stack
  addi $sp, $sp, -4
  jr $ra

p_int:
  addi $sp, $sp, 4 # Push $ra to stack
  sw $ra, 0($sp)
  li $v0, 1
  syscall
  lw $ra, 0($sp) # Pop $ra from stack
  addi $sp, $sp, -4
  jr $ra
