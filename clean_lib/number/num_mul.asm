include(basic.asm)
divert(-1) #Prevent output
changecom(//)


#Multiply
define(num_mul_var_var_var,
	`#$1 = $2 * $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)

	lw $t2, num_name($2)
	lw $t3, num_name($3)
	mul $t1,$t2,$t3
	sw $t1, num_name($1)

	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)
	')


define(num_mul_var_var_lit,
	`#$1 = $2 * $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)

	li $t3, $3
	lw $t2, num_name($2)
	mul $t1, $t2, $t3
	sw $t1, num_name($1)

	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)
	')


define(num_mul_var_var_reg,
	`#$1 = $2 * $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)
	_push_reg($3)

	move $t3,$3
	lw $t2, num_name($2)
	mul $t1, $t2, $t3
	sw $t1, num_name($1)

	_pop_reg($3)
	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)

	')



changecom()
divert(0)dnl