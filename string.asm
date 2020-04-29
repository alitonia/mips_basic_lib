divert(-1) #Prevent output
changecom(//)
#define str name as str_x, x:= 1->...
define(_strnum, 1)

#increment strnum
define(inc_str,
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

define( _push,
	`
	addi $sp, $sp, -4
    sw $1, 0($sp)
	')

define(_pop,
	`
	lw $1, ($sp)
	addi $sp, $sp, 4
	')

define(printStrLit,
    `
    _push($v0)
    _push($a0)

	li	$v0, 4
	.data
	str`'_strnum:	.asciiz	$1
	.text

	
	la	$a0, str`'_strnum
	syscall

	_pop($a0)
	_pop($v0)

inc_str(`_strnum')')
changecom()
divert(0)dnl 