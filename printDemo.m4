##
## Program name: printDemo.m4
##
## This program demonstrates how to include and use m4 macros
##
## Several strings are printed to the console
##

include(printLib.m4)		#include a needed macro library

	.text
	.globl __start
__start:

	printStrLit("I'm a literal string.\n")
				#the next will be labeled str2
	printStr("I am too.\n\n\n")

	printStrLab(myStr)
	printStr(str2)

	printStr("Registers can be  used to point to different parts of strings\n")
	la $t1, myStr
	addi $t1, $t1, 13	#Point somewhere else in the string
	printStrReg($t1)
	addi $t1, 11 		#Point a little farther in the same string
	printStr($t1)
	
	li $v0, 10
	syscall

	.data
myStr: .asciiz "I'm a string defined in the data section\n"