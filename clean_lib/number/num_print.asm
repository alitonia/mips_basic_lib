include(basic.asm)
divert(-1) #Prevent output
changecom(//)



# Print number in label to console
# Ex: num_print_label( label)

define(num_print_label,
	`#print number in label $1
	_push_reg($v0)

	lw $v0, $1
	num_print_reg($v0)

	_pop_reg($v0)
	')




define(num_print_var,
	`#print number in label $1
	_push_reg($v0)

	lw $v0, num_name($1)
	num_print_reg($v0)

	_pop_reg($v0)
	')



define(num_print_lit,
	`#print literal value $1
	_push_reg($a0)

	li $a0,$1
	num_print_reg($a0)

	_push_reg($a0)
	')


# print number in register to console
# ex: num_print_reg( $v0)

define(num_print_reg,
	`#Print number in $1)
	_push_reg($v0)
	_push_reg($a0)
	_push_reg($1)

	li $v0, 1
	_pop_reg($a0)		# $a0 = $1
	syscall

	_pop_reg($a0)
	_pop_reg($v0)
	')


changecom()
divert(0)dnl