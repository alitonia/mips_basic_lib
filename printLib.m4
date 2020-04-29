divert(-1) #redirect output to prevent cluttering up the assembly code

#change comment
#This is a nicety that allows argements to be substituted in
#comments added to code by the macro processor
changecom(//)

#global variable - used by printStrLit
define(strnum,1)

###############
#incVar
#
#Used to increment number valued macros by one.
#Input:  macro name with number value 
#Output: macro value is incremented by one.
###############
define(incVar,
`define(`$1',incr($1))')


###############
#printStrLit
#
#Used to define a string then print it
#Input:  A quoted string "like this one"
#Output: The string is printed to the console
#        A string with the value passed in is added to the data segment
#        That string has the name strn where n is the number of strings
#          previously define by this function + 1
#Side effects: $v0 $a0 are modified.
###############
define(printStrLit,
       `
	li	$v0, 4
	.data
	str`'strnum:	.asciiz	$1
	.text
	la	$a0, str`'strnum
	syscall
incVar(`strnum')')

###############
#printStrReg
#
#Used to print a string pointed to by a register
#Input:  A register
#Output: The string pointed to is printed on the console
#Side effects: $v0 and $a0 are modified
###############
define(printStrReg, 
       `#Print the string pointed to by $1
	li	$v0, 4
	move	$a0, $1
	syscall
')



###############
#printStrLab
#
#Used to print a string from a label
#Input:  A valid data label
#Output: The string the label represented.
#Side Effects: $v0 and $a0 are modified
###############
define(printStrLab,
       `#Print the string from label $1
	li	$v0, 4
	la	$a0, $1
	syscall
')

###############
#printStr
#
#Used to automatically choose how to print a string
#Input:  A valid data label, a string in "quotes", or a register
#Output: The indicated string will be printed
#Side Effects: $v0 and $a0 are modified
#              If a quoted string is sent it will be added to the idata segment
#                as indicated in printStrLit
###############
define(printStr, `divert(-1)
   ifelse(substr($1,0,1), $,`
      divert(0)printStrReg($1)divert(-1)',`
      ifelse(substr($1,0,1), ",`
         divert(0)printStrLit($1)divert(-1)',`
         divert(0)printStrLab($1)divert(-1)
      ')
   ')
divert(0)')

changecom()	#change comments back so we don't confuse anyone
divert(0)dnl	#set output back to default so we see something

