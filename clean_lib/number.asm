include(stack.asm)


divert(-1) #Prevent output
changecom(//)

# A library for manipulation of numbers and number arrays

# Done:
 #	print
 #	abs


 # Pending:

 # xor
 # and
 # or 
 # not 
 # nor 
 # xnor
 # equal
 
 # 
 # calculate
 # compare
 # 
 # sort
 # min, max, avg
 # 
# Pending: 
#	Make a bunch of useless function to use in conditional branching


define(inc_var,
`define(`$1',incr($1))')

define(_num_compare_instance, 1)
define(_num_data_instance, 1)


# Assign value to label:
# assign_num_label_lit( label, value)
define(assign_num,
	`
.data
	_num_
	')



###############
# num_abs
# 	Get absolute value of $1

# Input:  Register with value
# Output: v0 = |$1|

# Side effect: Loss old value at $v0

# Ex: num_abs($v1)
###############

define(num_abs,
	`# Return |$1| to $v0
	abs $v0, $1
	')




###############
# num_compare
# 	Compare $1 and $2

# Input:  2 registers with number value
# Output:  	$1 > $2: v0 = 1
#		  	$1 = $2: v0 = 0
#			$1 < $2: v0 = -1

# Side effect: Loss old value at $v0

# Ex: num_compare( $v0, $v1)
###############

define(num_compare,
	`# Compare $1 and $2
	 #  $1 > $2: v0 = 1
	 #  $1 = $2: v0 = 0
	 #  $1 < $2: v0 = -1
	 _push($t0)
	 _push($t1)
	 _push($t2)

	 # t1 = $1
	 # t2 = $2
	 _push($1)
	 _push($2)
	 _pop($t2)
	 _pop($t1)

	sgt $t0, $t1, $t2
	beq $t0, 1, _greater_case_`'_num_compare_instance
	seq $t0, $t1, $t2
	beq $t0, 1, _equal_case_`'_num_compare_instance
	j _lesser_case_`'_num_compare_instance

_greater_case_`'_num_compare_instance:
	li $v0, 1
	j _end_compare_`'_num_compare_instance

_equal_case_`'_num_compare_instance:
	li $v0, 0
	j _end_compare_`'_num_compare_instance

_lesser_case_`'_num_compare_instance:
	li $v0, -1
	j _end_compare_`'_num_compare_instance

_end_compare_`'_num_compare_instance:
	_pop($t2)
	_pop($t1)
	_pop($t0)
inc_var(`_num_compare_instance')')




###############
# num_print_reg
# 	Print number in register to console

# Input:  Register with value
# Output: Value in register printed to console

# Side effect: None

# Ex: num_print_reg($v0)
###############

define(num_print_reg,
	`#Print number in $1)
	_push($v0)
	_push($a0)
	_push($1)

	li $v0, 1
	_pop($a0)		# $a0 = $1
	syscall

	_pop($a0)
	_pop($v0)
	')



###############
# num_print_label
# 	Print number in label to console

# Input:  Label with value
# Output: Value in label printed to console

# Side effect: None

# Ex: num_print_label($v0)
###############

define(num_print_label,
	`#print number in label $1
	_push($v0)
	lw $v0, $1
	num_print_reg($v0)
	_pop($v0)
	')




###############
# num_print_lit
# 	Print literal number to console

# Input:  literal number
# Output: number printed to console

# Side effect: None

# Ex: num_print_lit($v0)
###############
define(num_print_lit, 
	`#Print literal number

.data 
	_num_`'_num_data_instance: .word $1
.text
	num_print_label(_num_`'_num_data_instance)
inc_var(`_num_data_instance')')



###############
# num_sum_reg_reg
# 	Give sum of 2 registers

# Input:  2 registers with number, 1 destination register
# Output: sum to $v0, if $3 is passed, $3 = value instead

# Side effect: Loss value of $3( default $v0)

# Ex: num_sum_reg_reg($t0, $t1, $v1)
###############

define(num_sum_reg_reg,
	`#Sum value at $1 and $2 to ifelse($3,,$v0,$3)
	add ifelse($3,,$v0,$3), $1, $2
	')



###############
# num_sum_reg_lit
# 	Give sum of 1 register and 1 number

# Input:  1 registers with number, 1 number, 
# Output: sum to $3

# Side effect: Loss value of $3( default $v0)

# Ex: num_sum_reg_lit($t0, 1, $v1)
###############

define(num_sum_reg_lit,
	`#Sum value at $1 and $2 to ifelse($3,,$v0,$3)
	addi ifelse($3,,$v0,$3), $1, $2
	')




###############
# num_sum_label_lit
# 	Give sum of 1 register and 1 number

# Input:  1 label with number, 1 number
# Output: sum to $3

# Side effect: Loss value of $3( default $v0)

# Ex: num_sum_label_lit($t0, 1, $v1)
###############

define(num_sum_label_lit,
	`#Sum value at $1 and $2 to ifelse($3,,$v0,$3)
	_push($v0)
	_push($v1)
	_push($2)
	lw $v1, $1
	_pop($v0)
	addi ifelse($3,,$v0,$3), $v0, $v1
	_pop($v1)
	_pop($v0)
	')





###############
# num_assign_reg_reg
# 	Assign value of register $2 to register $1

# Input:  2 registers 
# Output: assign $1 = $2

# Side effect: Loss value of $1

# Ex: num_assign_reg_reg($v0, $t1)
###############

define(num_assign_reg_reg,
	`# Assign $1 = $2
	move $1,$2
	')


###############
# num_assign_reg_label
# 	Assign value of label $2 to register $1

# Input:  1 register, 1 label
# Output: assign $1 = $2

# Side effect: Loss value of $1

# Ex: num_assign_reg_label($v0, label)
###############

define(num_assign_reg_label,
	`# Assign $1 = $2
	lw $1, $2
	')



###############
# num_assign_label_reg
# 	Assign value of register $2 to label $1

# Input:  1 label, 1 register
# Output: assign $1 = $2

# Side effect: Loss value of $1

# Ex: num_assign_label_reg(label, register)
###############

define(num_assign_label_reg,
	`# Assign $1 = $2
	sw $2, $1
	')



###############
# num_assign_label_label
# 	Assign value of label $2 to label $1

# Input:  2 labels
# Output: assign $1 = $2

# Side effect: Loss value of $1

# Ex: num_assign_label_label(label_1, label_2)
###############

define(num_assign_label_label,
	`# Assign $1 = $2
	_push($t0)
	lw $t0, $2
	sw $t0, $1
	_pop($t0)
	')



###############
# num_assign_label_lit
# 	Assign value of literal $2 to label $1

# Input:  1 label, 1 literal
# Output: assign $1 = $2

# Side effect: Loss value of $1

# Ex: num_assign_label_lit(label, 3)
###############

define(num_assign_label_lit,
	`# Assign $1 = $2
	_push($t0)
	li $t0, $2
	sw $t0, $1
	_pop($t0)
	')



# num_assign_reg_lit
# 	Assign value of literal $2 to register $1

# Input:  1 register, 1 literal
# Output: assign $1 = $2

# Side effect: Loss value of $1

# Ex: num_assign_reg_lit( $v0, 3)
###############

define(num_assign_reg_lit,
	`# Assign $1 = $2
	li $1,$2
	')


# num_less_than_reg_reg
# 	$v0 = 1 if $1 < $2
#   else $v0 = 0

# Input:  2 registers
# Output: $v0 = int( $1 < $2)

# Side effect: Loss value of $v0

# Ex: num_less_than_reg_reg( $v0, $v3)
###############

define(num_less_than_reg_reg,
	`# Assign $1 = $2
	slt $v0, $1, $2
	')



# num_less_than_label_reg
# 	$v0 = 1 if $1 < $2
#   else $v0 = 0

# Input:  1 label, 1 register
# Output: $v0 = int( $1 < $2)

# Side effect: Loss value of $v0

# Ex: num_less_than_label_reg( $v0, $v3)
###############

define(num_less_than_label_reg,
	`# Assign $1 = $2 to $v0
	_push($t0)
	lw $t0, $1
	slt $v0, $t0, $2
	_pop($t0)
	')


changecom()
divert(0)dnl