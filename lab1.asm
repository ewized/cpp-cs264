# Joshua Rodriguez
# Lab 1
# Due Date:  April 17, 2017
#
# Write a program that reads an array of 20 integers with an appropriate prompt,
# stores it, and then prints in three formats:
# 	- One integer per line;
# 	- All integers in a single line separated by spaces;
# 	- All in integers in a single line in the reverse order separated by spaces,
# 	- You program requests entering a positive integer n <=20 and then prints the 20 integers,
#		 n integers (separated by space) per line.
#
# Test your program for one set of 20 integers and for n= 5 and n= 6 Submit a
# hardcopy of your programs and their outputs.
#


	.data
ram:	.space 80 			# 4 * 20
spc:	.asciiz " "
nl:	.asciiz "\n"
prmt:	.asciiz "Enter 20 numbers\n"
prmt2:	.asciiz "Enter a number: "
done:	.asciiz "Done\n"
	.globl main
	.text


main:	li $t1, 20			# Counter at $t1
	la $t2, ram			# Array Index a $t2
	li $v0, 4 			# Print prompt
	la $a0, prmt
	syscall

aary:	li $v0, 5			# Set register to read value
	syscall
	sw $v0, 0($t2)			# copy add to ram
	addi $t2, $t2, 4		# Increment index counter
	sub $t1, $t1, 1
	bne $t1, $0, aary		# Branch to aary to keep reading ints

	li $v0, 4			# Print the new line
	la $a0, nl
	syscall

	li $t1, 20			# Set counter back to 20 and loop
	sub $t2, $t2, 80		# Reset ram position
print1:	li $v0, 1
	lw $a0, 0($t2)			# Print the number
	syscall
	li $v0, 4
	la $a0, nl
	syscall
	addi $t2, $t2, 4		# Increment the ram counter
	sub $t1, $t1, 1
	bne $t1, $0, print1

	li $t1, 20			# Set counter back to 20 and loop
	sub $t2, $t2, 80		# Reset ram position
print2:	li $v0, 1
	lw $a0, 0($t2)			# Print the number
	syscall
	li $v0, 4
	la $a0, spc
	syscall
	addi $t2, $t2, 4		# Increment the ram counter
	sub $t1, $t1, 1
	bne $t1, $0, print2

	li $v0, 4			# Print the new line
	la $a0, nl
	syscall

	li $t1, 20			# Set counter back to 20 and loop
	sub $t2, $t2, 4
print3:	li $v0, 1
	lw $a0, 0($t2)			# Print the number
	syscall
	li $v0, 4
	la $a0, spc
	syscall
	sub $t2, $t2, 4			# Decincrement the ram counter
	sub $t1, $t1, 1
	bne $t1, $0, print3

	li $v0, 4			# Print the new line
	la $a0, nl
	syscall

	li $v0, 4 			# Print prompt
	la $a0, prmt2
	syscall
	li $v0, 5
	syscall
	move $t3, $v0			# Keep track of sub loop


	li $t1, 20			# Set counter back to 20 and loop
	addi $t2, $t2, 4
print4:	move $t4, $t3			# Temp counter of sub loop
print5:	blez $t4, next			# Go to the next when sub counter is <= 0
	li $v0, 4
	la $a0, spc
	syscall
	li $v0, 1
	lw $a0, 0($t2)
	syscall
	sub $t4, $t4, 1
	j print5
next:	li $v0, 4
	la $a0, nl
	syscall
	addi $t2, $t2, 4		# Increment the ram counter
	sub $t1, $t1, 1
	bne $t1, $0, print4


stop: 	li $v0, 4
	la $a0, done
	syscall
	li $v0, 10
	syscall
