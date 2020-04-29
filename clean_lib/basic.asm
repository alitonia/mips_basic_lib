

divert(-1) #Prevent output
changecom(//)

#Note: all label is subtituted by variable :)


define(__scope__, 0)

# Make local variable by appending _x, 
# with x being the scope

#Variable not visible to users
define(__sneaky_num_instance__, 1)
define(__sneaky_str_instance__, 1)
define(__sneaky_space_instance__, 1)
define(__sneaky_condition_instance__, 1)

#If-else
define(__if_else_instance_scope_0__, 1)
define(__if_else_instance_scope_1__, 1)
define(__if_else_instance_scope_2__, 1)
define(__if_else_instance_scope_3__, 1)
define(__if_else_instance_scope_4__, 1)

#loop
define(__loop_instance_scope_0__, 1)
define(__loop_instance_scope_1__, 1)
define(__loop_instance_scope_2__, 1)
define(__loop_instance_scope_3__, 1)
define(__loop_instance_scope_4__, 1)
define(__loop_instance_scope_5__, 1)
define(__loop_instance_scope_6__, 1)

#switch 
define(__switch_instance__, 1)


define(num_name, `_num_prefix_`'$1`'_ ')
define(str_name, `_str_prefix_`'$1`'_ ')
define(space_name, `_space_prefix_`'$1`'_ ')


define(sneaky_num_name, `_num_prefix_`'$1`'_`'__sneaky_num_instance__ ')
define(sneaky_str_name, `_str_prefix_`'$1`'_`'__sneaky_str_instance__ ')
define(sneaky_condition_name, `_condition_prefix_`'$1`'_`'__sneaky_condition_instance__ ')


#shorthand if else name
define(sneaky_if_else_name, `_`'$1`'_`'ifelse(__scope__,0,__if_else_instance_scope_0__,ifelse(__scope__,1,__if_else_instance_scope_1__,ifelse(__scope__,2,__if_else_instance_scope_2__,ifelse(__scope__,3,__if_else_instance_scope_3__,ifelse(__scope__,4,__if_else_instance_scope_4__,ifelse(__scope__,5,__if_else_instance_scope_5__,ifelse(__scope__,6,__if_else_instance_scope_6__,1000)))))))`'_`'__scope__')


define(sneaky_get_if_else_instance, `__if_else_instance_scope_`'$1`'__')


# shorthand loop name
define(sneaky_loop_name, `_`'$1`'_`'ifelse(__scope__,0,__loop_instance_scope_0__,ifelse(__scope__,1,__loop_instance_scope_1__,ifelse(__scope__,2,__loop_instance_scope_2__,ifelse(__scope__,3,__loop_instance_scope_3__,ifelse(__scope__,4,__loop_instance_scope_4__,1000)))))`'_`'__scope__')


define(sneaky_get_loop_instance, `__loop_instance_scope_`'$1`'__')


# ++ and --
define(inc_var,
`define(`$1',incr($1))')


define(dec_var,
`define(`$1',decr($1))')



## Push, Pop 



# Push register value to stack
# ex: _push_reg( $a0)

define( _push_reg,
	`#Push $1 to stack
	addi $sp, $sp, -4
    sw $1, 0($sp)
	')


# Pop stack value to register
# ex: _pop_reg( $a0)

define(_pop_reg,
	`#Pop stack to $1
	lw $1, ($sp)
	addi $sp, $sp, 4
	')



# Push variable value to stack
# ex: _push_var_word( variable)
# Note: change $t9

define(_push_var_word,
	`#Push variable value to stack
	lw $t9, num_name($1)
	_push_reg($t9)
	li $t9,0
	')



# Pop stack value to variable
# ex: _pop_var_word( variable)
# Note: change $t9

define(_pop_var_word,
	`#Push variable value to stack
	_pop_reg($t9)
	sw $t9, num_name($1)
	li $t9, 0
	')



# Push literal number to stack
# ex: _push_lit_word( label)
# Note: change $t9

define(_push_lit_word,
	`#Push literal value to stack
	li $t9,$1
	_push_reg($t9)
	li $t9,0
	')


## Make number variable


# assign value from register $2 to variable $1
# ex: make_num_var_reg( x, $v0, 1)

define(make_num_var_reg,
	`#Assign variable $1 to value of $2
.data
	num_name($1)`': .word 0
.text
	sw $2, num_name($1)

	')



# assign value from literal to variable
# ex: make_num_var_lit( x, 6)

define(make_num_var_lit,
	`#Assign variable $1 to value of $2
.data
	num_name($1): .word $2
.text
	')




# assign value from variable to variable
# ex: make_num_var_var( x, $v0)

define(make_num_var_var,
	`#Assign variable $1 to value of $2
.data
	num_name($1)`': .word 0
.text
	_push_reg($t0)
	lw $t0, num_name($2)   # get value of $2
	sw $t0, num_name($1)	#push value to $1
	_pop_reg($t0)
	')



# assign value from label to variable
# ex: make_num_var_label( x, $v0)

define(make_num_var_label,
	`#Assign variable $1 to value of $2
.data
	num_name($1)`': .word 0
.text
	_push_reg($t0)
	lw $t0, $2				# get value of $2
	sw $t0, num_name($1)	#push value to $1
	_pop_reg($t0)

	')



# Assign value:


# ex: assign_num_var_lit(x, 16)
define(assign_num_var_lit,
	`#Assign value to $1 = $2
	_push_reg($t0)
	li $t0,$2
	sw $t0, num_name($1)

	_pop_reg($t0)
	')


# ex: assign_num_var_reg(x, $v0)
define(assign_num_var_reg,
	`# assign $1 = $2
	sw $2, $1
	')



#ex: assign_num_var_var(x, y)
define(assign_num_var_var,
	`# assign $1 = $2
	_push_reg($t0)
	lw $t0, $2
	sw $t0, $1
	_pop_reg($t0)
	')





## Branching

#if
#Note: change $t9

# ex:

#.text

#make_num_var_lit(x, 10)
#make_num_var_lit(y, 40)

#if_branching( `num_less_than_var_var(x, y)',
#			  `num_print_var(x)', 
#			  `num_print_var(y)' )
#



define(if_branching,
	`
#Now in condition and preprocessing
# Current scope: __scope__ 
sneaky_if_else_name(start_if_else):
	_push_reg($v0)
	$1

	addi $t9, $v0, 0
	_pop_reg($v0)

	# $t9 = branch condition
	beqz $t9, sneaky_if_else_name(start_else)

#Now in if branch

sneaky_if_else_name(start_if):
	li $t9, 0

	inc_var(`__scope__')
	$2
	dec_var(`__scope__')

	j sneaky_if_else_name(end_if_else)

#Now in else branch
sneaky_if_else_name(start_else):
	li $t9, 0

	inc_var(`__scope__')
	$3
	dec_var(`__scope__')

#Now exit
sneaky_if_else_name(end_if_else):
#Adding instance
inc_var(sneaky_get_if_else_instance(__scope__))
# Current scope: __scope__ 
	')





#for 
# change $t9, 
# absolutely don't use t9 in anyway
# to get a result out of this loop 
#ex:

#.text
#li $t0, 3

#make_num_var_lit(i_1, 0)

#for_branching(
#	`assign_num_var_lit(i_1, 0)',
#	`num_less_than_var_reg(i_1, $t0)',
#	`num_add_var_var_lit(i_1,i_1,1)',
#	`num_print_var(i_1)')



define(for_branching,
	`#Enter for loop
	 #Current scope: __scope__ 
sneaky_loop_name(start_for):

	#Note: customize local variable(s)
	$1
sneaky_loop_name(for_loop):

	_push_reg($v0)

	#condition
	$2
	addi $t9, $v0, 0
	_pop_reg($v0)

	# $t9 = condition
	beqz $t9, sneaky_loop_name(end_for)

sneaky_loop_name(for_actions):

	li $t9,0
	inc_var(`__scope__')
	$4
	dec_var(`__scope__')

sneaky_loop_name(other_actions):

	$3
	j sneaky_loop_name(for_loop)

#Exit for
sneaky_loop_name(end_for):
	li $t9,0
	inc_var(sneaky_get_loop_instance(__scope__))
	#Current scope: __scope__ 
	')



# break_loop()
define(break_loop,
	`#Break out of current loop
	j sneaky_loop_name(end_for)
	')


#continue_loop()
define(continue_loop,
	`#Continue to next iteration
	j sneaky_loop_name(other_actions)
	')


#exit_program:
define(exit_program,
	`#Now exit program
	li $v0,10
	syscall
	')





changecom()
divert(0)dnl