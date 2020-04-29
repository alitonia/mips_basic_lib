include(basic.asm)
divert(-1) #Prevent output
changecom(//)


# Ex: num_less_than_var_reg( i, $v3)

define(num_less_than_var_reg,
	`# $v0 = ( $1 < $2)
	#Load
	_push_reg($t0)
	_push_reg($t1)
	addi $t1, $2, 0
	lw $t0, num_name($1)

	slt $v0, $t0, $t1

	_pop_reg($t1)
	_pop_reg($t0)
	')

define(num_less_than_reg_reg,
	`# Assign $v0 = ( $1 < $2)
	slt $v0, $1, $2
	')


# Ex: num_less_than_var_var( i, j)

define(num_less_than_var_var,
	`# $v0 = ( $1 < $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	slt $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_less_than_var_lit(i, 10)
define(num_less_than_var_lit,
	`# $v0 = $1 < $2
	_push_reg($t0)
	lw $t0, $1
	slti $v0, $t0, $2
	_pop_reg($t0)
	')


define(num_less_than_reg_lit,
	`#$1 = $2 < $3
	slti $v0, $2, $3
	')




changecom()
divert(0)dnl