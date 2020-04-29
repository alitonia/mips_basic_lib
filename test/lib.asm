include(poppush.asm)
divert(-1)
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
    _push($v0)
    _push($a0)
    
	li	$v0, 4
	.data
	str`'strnum:	.asciiz	$1
	.text

	
	la	$a0, str`'strnum
	syscall

	_pop($a0)
	_pop($v0)

incVar(`strnum')')
divert(0)dnl 
