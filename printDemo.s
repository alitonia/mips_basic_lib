##
## Program name: printDemo.m4
##
## This program demonstrates how to include and use m4 macros
##
## Several strings are printed to the console
##


		#include a needed macro library

	.text
	.globl __start
__start:
				#this string will be labeled str1
	#Print the literal string "I'm a literal string.\n". 
	#Its symbol is str2
	li	$v0, 4
	.data
str2:	.asciiz	"I'm a literal string.\n"
	.text
	la	$a0, str2
	syscall

				#the next will be labeled str2
	#Print the literal string "I am too.\n\n\n". 
	#Its symbol is str3
	li	$v0, 4
	.data
str3:	.asciiz	"I am too.\n\n\n"
	.text
	la	$a0, str3
	syscall


	#Print the string from label myStr
	li	$v0, 4
	la	$a0, myStr
	syscall

	#Print the string from label str2
	li	$v0, 4
	la	$a0, str2
	syscall


	#Print the literal string "Registers can be  used to point to different parts of strings\n". 
	#Its symbol is str4
	li	$v0, 4
	.data
str4:	.asciiz	"Registers can be  used to point to different parts of strings\n"
	.text
	la	$a0, str4
	syscall

	la $t1, myStr
	addi $t1, $t1, 13	#Point somewhere else in the string
	#Print the string pointed to by $t1
	li	$v0, 4
	move	$a0, $t1
	syscall

	addi $t1, $t1, 11 		#Point a little farther in the same string
	#Print the string pointed to by $t1
	li	$v0, 4
	move	$a0, $t1
	syscall

	
	li $v0, 10
	syscall

	.data
myStr: .asciiz "I'm a string defined in the data section\n"
