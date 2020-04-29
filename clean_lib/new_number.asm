include(basic.asm)

divert(-1) #Prevent output
changecom(//)

#Number manipulation

## Print



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












## Arithmetic


#add
# sum label, label ---> label
# ex: num_add_label_label_label(dest, origin_1, origin_2)

define(num_add_var_var_var,
	`# $1 = $2 + $3 
	_push_reg($t2)
	_push_reg($t3)
	_push_reg($t1)

	lw $t2, num_name($2)
	lw $t3, num_name($3)
	add $t1, $t2, $t3
	sw $t1, num_name($1)

	_pop_reg($t1)
	_pop_reg($t2)
	_pop_reg($t3)
	')



# sum var, lit ---> var
# ex: num_add_var_var_lit(dest, origin, 1)

define(num_add_var_var_lit,
	`# $1 = $2 + $3 
	_push_reg($t0)

	lw $t0, num_name($2)
	addi $t0, $t0, $3
	sw $t0, num_name($1)

	_pop_reg($t0)
	')



define(num_add_var_var_reg,
	`#$1 = $2 + $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)
	_push_reg($3)

	move $t3,$3
	lw $t2, num_name($2)
	add $t1, $t2, $t3
	sw $t1, num_name($1)

	_pop_reg($3)
	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)
	')


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


# div:

define(num_div_var_var_var,
	`#$1 = $2 / $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)

	lw $t2, num_name($2)
	lw $t3, num_name($3)
	div $t1,$t2,$t3
	sw $t1, num_name($1)

	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)
	')


define(num_div_var_var_lit,
	`#$1 = $2 / $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)

	li $t3, $3
	lw $t2, num_name($2)
	div $t1, $t2, $t3
	sw $t1, num_name($1)

	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)
	')


define(num_div_var_var_reg,
	`#$1 = $2 / $3
	_push_reg($t1)
	_push_reg($t2)
	_push_reg($t3)
	_push_reg($3)

	move $t3,$3
	lw $t2, num_name($2)
	div $t1, $t2, $t3
	sw $t1, num_name($1)

	_pop_reg($3)
	_pop_reg($t3)
	_pop_reg($t2)
	_pop_reg($t1)

	')




#Logic

#<

# num_less_than_reg_reg
# 	$3 = int( $1 < $2)

# Ex: num_less_than_reg_reg( $v0, $v3)

define(num_less_than_reg_reg,
	`# Assign $v0 = ( $1 < $2)
	slt $v0, $1, $2
	')



# num_less_than_var_reg
# 	$v0 = int( $1 < $2)

# Ex: num_less_than_var_reg( i, $v3)

define(num_less_than_var_reg,
	`# $v0 = ( $1 < $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	slt $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_less_than_var_var
# 	$v0 = int( $1 < $2)

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
	lw $v0, num_name($1)
	slti $v0, $v0, $2
	')


define(num_less_than_reg_lit,
	`# $v0 = $2 < $3
	slti $v0, $1, $2
	')




#>


define(num_greater_than_reg_reg,
	`# Assign $v0 = ( $1 > $2)
	sgt $v0, $1, $2
	')



# num_greater_than_var_reg
# 	$v0 = int( $1 > $2)

# Ex: num_greater_than_var_reg( i, $v3)

define(num_greater_than_var_reg,
	`# $v0 = ( $1 > $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	sgt $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_greater_than_var_var
# 	$v0 = int( $1 > $2)

# Ex: num_greater_than_var_var( i, j)

define(num_greater_than_var_var,
	`# $v0 = ( $1 > $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	sgt $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_greater_than_var_lit(i, 10)
define(num_greater_than_var_lit,
	`# $v0 = $1 > $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	sgt $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_greater_than_reg_lit,
	`#$1 = $2 > $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	sgt $v0, $v0, $t0
	_pop_reg($t0)
	')



# >=

define(num_greater_equal_reg_reg,
	`# Assign $v0 = ( $1 >= $2)
	sge $v0, $1, $2
	')



# num_greater_equal_var_reg
# 	$v0 = int( $1 >= $2)

# Ex: num_greater_equal_var_reg( i, $v3)

define(num_greater_equal_var_reg,
	`# $v0 = ( $1 >= $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	sge $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_greater_equal_var_var
# 	$v0 = int( $1 >= $2)

# Ex: num_greater_equal_var_var( i, j)

define(num_greater_equal_var_var,
	`# $v0 = ( $1 >= $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	sge $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_greater_equal_var_lit(i, 10)
define(num_greater_equal_var_lit,
	`# $v0 = $1 >= $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	sge $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_greater_equal_reg_lit,
	`#$1 = $2 >= $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	sge $v0, $v0, $t0
	_pop_reg($t0)
	')


# <=


define(num_less_equal_reg_reg,
	`# Assign $v0 = ( $1 <= $2)
	sle $v0, $1, $2
	')



# num_less_equal_var_reg
# 	$v0 = int( $1 <= $2)

# Ex: num_less_equal_var_reg( i, $v3)

define(num_less_equal_var_reg,
	`# $v0 = ( $1 <= $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	sle $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_less_equal_var_var
# 	$v0 = int( $1 <= $2)

# Ex: num_less_equal_var_var( i, j)

define(num_less_equal_var_var,
	`# $v0 = ( $1 <= $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	sle $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_less_equal_var_lit(i, 10)
define(num_less_equal_var_lit,
	`# $v0 = $1 <= $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	sle $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_less_equal_reg_lit,
	`#$1 = $2 <= $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	sle $v0, $v0, $t0
	_pop_reg($t0)
	')


# And

define(num_and_reg_reg,
	`# Assign $v0 = ( $1 AND $2)
	and $v0, $1, $2
	')



# num_and_var_reg
# 	$v0 = int( $1 AND $2)

# Ex: num_and_var_reg( i, $v3)

define(num_and_var_reg,
	`# $v0 = ( $1 AND $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	and $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_and_var_var
# 	$v0 = int( $1 AND $2)

# Ex: num_and_var_var( i, j)

define(num_and_var_var,
	`# $v0 = ( $1 AND $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	and $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_and_var_lit(i, 10)
define(num_and_var_lit,
	`# $v0 = $1 AND $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	and $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_and_reg_lit,
	`#$1 = $2 AND $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	and $v0, $v0, $t0
	_pop_reg($t0)
	')


#or 

define(num_or_reg_reg,
	`# Assign $v0 = ( $1 or $2)
	or $v0, $1, $2
	')



# num_or_var_reg
# 	$v0 = int( $1 or $2)

# Ex: num_or_var_reg( i, $v3)

define(num_or_var_reg,
	`# $v0 = ( $1 or $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	or $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_or_var_var
# 	$v0 = int( $1 or $2)

# Ex: num_or_var_var( i, j)

define(num_or_var_var,
	`# $v0 = ( $1 or $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	or $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_or_var_lit(i, 10)
define(num_or_var_lit,
	`# $v0 = $1 or $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	or $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_or_reg_lit,
	`#$1 = $2 or $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	or $v0, $v0, $t0
	_pop_reg($t0)
	')


# Xor


define(num_xor_reg_reg,
	`# Assign $v0 = ( $1 xor $2)
	xor $v0, $1, $2
	')



# num_xor_var_reg
# 	$v0 = int( $1 xor $2)

# Ex: num_xor_var_reg( i, $v3)

define(num_xor_var_reg,
	`# $v0 = ( $1 xor $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	xor $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_xor_var_var
# 	$v0 = int( $1 xor $2)

# Ex: num_xor_var_var( i, j)

define(num_xor_var_var,
	`# $v0 = ( $1 xor $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	xor $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_xor_var_lit(i, 10)
define(num_xor_var_lit,
	`# $v0 = $1 xor $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	xor $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_xor_reg_lit,
	`#$1 = $2 xor $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	xor $v0, $v0, $t0
	_pop_reg($t0)
	')


# =


define(num_equal_reg_reg,
	`# Assign $v0 = ( $1 = $2)
	seq $v0, $1, $2
	')



# num_equal_var_reg
# 	$v0 = int( $1 = $2)

# Ex: num_equal_var_reg( i, $v3)

define(num_equal_var_reg,
	`# $v0 = ( $1 = $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	seq $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_equal_var_var
# 	$v0 = int( $1 = $2)

# Ex: num_equal_var_var( i, j)

define(num_equal_var_var,
	`# $v0 = ( $1 = $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	seq $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_equal_var_lit(i, 10)
define(num_equal_var_lit,
	`# $v0 = $1 = $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	seq $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_equal_reg_lit,
	`#$1 = $2 = $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	seq $v0, $v0, $t0
	_pop_reg($t0)
	')


# !=


define(num_not_equal_reg_reg,
	`# Assign $v0 = ( $1 != $2)
	sne $v0, $1, $2
	')



# num_not_equal_var_reg
# 	$v0 = int( $1 != $2)

# Ex: num_not_equal_var_reg( i, $v3)

define(num_not_equal_var_reg,
	`# $v0 = ( $1 != $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	sne $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_not_equal_var_var
# 	$v0 = int( $1 != $2)

# Ex: num_not_equal_var_var( i, j)

define(num_not_equal_var_var,
	`# $v0 = ( $1 != $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	sne $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_not_equal_var_lit(i, 10)
define(num_not_equal_var_lit,
	`# $v0 = $1 != $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	sne $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_not_equal_reg_lit,
	`#$1 = $2 != $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	sne $v0, $v0, $t0
	_pop_reg($t0)
	')


#nor 


define(num_nor_reg_reg,
	`# Assign $v0 = ( $1 nor $2)
	nor $v0, $1, $2
	')



# num_nor_var_reg
# 	$v0 = int( $1 nor $2)

# Ex: num_nor_var_reg( i, $v3)

define(num_nor_var_reg,
	`# $v0 = ( $1 nor $2)
	#Load
	_push_reg($t1)
	addi $t1, $2, 0
	lw $v0, num_name($1)

	nor $v0, $v0, $t1

	_pop_reg($t1)
	')


# num_nor_var_var
# 	$v0 = int( $1 nor $2)

# Ex: num_nor_var_var( i, j)

define(num_nor_var_var,
	`# $v0 = ( $1 nor $2)+
	_push_reg($t1)
	_push_reg($t2)

	lw $t1, num_name($1)
	lw $t2, num_name($2)

	nor $v0, $t1, $t2
	_pop_reg($t2)
	_pop_reg($t1)
	')


#ex: num_nor_var_lit(i, 10)
define(num_nor_var_lit,
	`# $v0 = $1 nor $2
	_push_reg($t0)

	lw $v0, num_name($1)
	li $t0, $2
	nor $v0, $v0, $t0
	_pop_reg($t0)
	')


define(num_nor_reg_lit,
	`#$1 = $2 nor $3
	_push_reg($t0)
	move $v0,$1
	li $t0,$2
	nor $v0, $v0, $t0
	_pop_reg($t0)
	')


#abs

define(num_abs_reg,
	`# $v0 = |$1|
	abs $v0, $1
	')

define(num_abs_label,
	`# $v0 = |$1|
	lw $v0, $1
	abs $v0, $v0
	')

define(num_abs_lit,
	`# $v0 = |$1|
	li $v0, $1
	abs $v0, $v0
	')



#not

define(num_not_reg,
	`# $v0 = not $1
	not $v0, $1
	')

define(num_not_label,
	`# $v0 = not $1
	lw $v0, $1
	not $v0, $v0
	')

define(num_not_lit,
	`# $v0 = not $1
	li $v0, $1
	not $v0, $v0
	')




changecom()
divert(0)dnl