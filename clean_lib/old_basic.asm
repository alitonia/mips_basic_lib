include(stack.asm)
include(number.asm)

divert(-1) #Prevent output
changecom(//)

# A library for manipulation of basic operation

# Done:


 # Pending:
  # ifelse
  # multiply 
  # loop 
  # exit
  # )

# $1 ++
define(inc_var,
`define(`$1',incr($1))')

# $1 --
define(decr_var,
`define(`$1',decr($1))')

define(_for_initialize_instance, 1)
define(_for_depth, 0)




###############
# for_initialize
# 	initialize variable for for loop

# Input:  variable name, initial value
# Output: a label with name = for_appendage + name, 
# 						type = word, value = initial value

# Side effect: Pending

# Ex: for_initialize(i, 0)
###############

define(for_initialize,
	`# initialize label as variable $1 for for loop 
	 # with initial value $1 = $2
.data 
	_for_variable_`'$1`'_`'_for_initialize_instance`'_`'eval(_for_depth+1)`': .word $2
.text
	')



###############
# _for_name
# 	Get for name of 

# Input:  variable name, value, depth ( default = 1)
# Output: name

# Side effect: Pending

# Ex: _for_name(i, 0)
###############

define(_for_name,`_for_variable_`'$1`'_for_initialize_instance`'_`'$2')




###############
# for_loop
# 	Run C style for loop

# Input:  initialize, condition, next_action, actions
# Output: loop

# Side effect: $t9 value unknown

# Ex: for_loop( for_initialize(i, 0), num_less_than( _for_name(i), n),
# 				num_sum( _for_name(i), 1, _for_name(i)), 
# 				num_print_label(_for_name(i) ) 
# 				)
###############

define(for_loop,
	`#In for loop
	#increase depth
	inc_var(`_for_depth')
	$1
_start_for_`'_for_initialize_instance:
	_push($v0)
	$2

	num_assign_reg_reg($t9, $v0)
	_pop($v0)

	#condition in $t9
	beqz $t9, _out_for_`'_for_initialize_instance
	#to do in for loop
	$4

_end_for_`'_for_initialize_instance:
	$3

_out_for_`'_for_initialize_instance:
	decr_var(`_for_depth')
	ifelse(_for_depth,0,inc_var(`_for_initialize_instance'),)
	')






















changecom()
divert(0)dnl