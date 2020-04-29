include(stack.asm)

divert(-1) #Prevent output

# A library for manipulation of strings

# Done:
#	print_str
# 	len_str
# 	capitalize
#	strcpy
# 	join
# 	find

# Pending:
# 	upper
# 	lower 
#	title

# 	count
# 	replace

# 	lstrip
# 	rstrip
# 	strip
# 		
# 		)


changecom(//)

define(_max_str_length, 100)

#define str name as str_x, x:= 1->...
define(_strnum, 1)
define(_get_str_length_reg_instance, 1)
define(_not_valid_instance, 1)
define(_str_cpy_instance, 1)
define(_get_str_find_first_reg_reg_instance, 1)
#increment strnum
define(inc_var,
`define(`$1',incr($1))')


###############
# print_str_lit
# 	Define a string then print it

# Input:  A quoted string ( "Hello")
# Output: The string is printed to the console
#        A string with the value passed in is added to the data segment
#        That string has the name strn where n is the number of strings
#          previously define by this function + 1

# Side effect: None

# Ex: print_str_lit("Hello there")

###############

define(print_str_lit,
   `#Print literal string
    _push($v0)
    _push($a0)

	li	$v0, 4 
	.data
	str_`'_strnum:	.asciiz	$1

	.text
	la	$a0, str_`'_strnum
	syscall

	_pop($a0)
	_pop($v0)

inc_var(`_strnum')')


###############
# print_str_reg
#	 Print a string pointed to by a register

# Input:  A register
# Output: The string pointed to is printed on the console

# Side effects: None

# Ex: print_str_reg( $a0)

###############

define(print_str_reg, 
   `#Print the string pointed to by $1
   _push($v0)
   	_push($a0)

	li	$v0, 4
	move	$a0, $1
	syscall

	_pop($a0)
	_pop($v0)
	')


###############
# print_str_label
#	Print a string from a label

# Input:  A valid data label
# Output: The string the label represented print to console.

# Side Effects: None

# Ex: 
#	this_string: .asciiz "Hello"
#	print_str_label(this_string)

###############
define(print_str_label,
   `#Print the string from label $1
   _push($v0)
   _push($a0)

	li	$v0, 4
	la	$a0, $1
	syscall

	_pop($a0)
	_pop($v0)
')



###############
# get_str_length_lit
#	Get length of literal string

# Input:  A string ( "Hello"), register to assign value
# Output: length of string to $v0

# Side Effects: Loss value in $v0

# Ex: 
#	get_str_length_literal("Hello")

###############
define(get_str_length_lit,
   `#Get length of literal string to $2
	li	$v0, eval(len($1)-2)
')



###############
# get_str_length_reg
#	Get length of string from register

# Input:  A string with address to string
# Output: length of string to $v0

# Side Effects: Loss value in $v0

# Ex: 
#	get_str_length_reg($a0)

###############

define(get_str_length_reg,
   `#Get length of string in $1 to $v0
   _push($a0)
   _push($t0)
   _push($t1)
   _push($t2)

get_length_`'_get_str_length_reg_instance:

	move $a0,$1

	#set zero
	xor $v0, $zero $zero		#v0 = length = 0
	xor $t0, $zero, $zero		# t0 = i = 0

check_char_`'_get_str_length_reg_instance:
	add $t1, $a0, $t0			# t1 = &x[i]  =  a0 + t0
								
	lb $t2, 0($t1)				# t2 = x[i]

	beq $t2, $zero, end_of_str_`'_get_str_length_reg_instance	# if (x[i] == null) break loop

	addi $v0, $v0, 1			# length ++;
	addi $t0, $t0, 1			# i ++;
	j check_char_`'_get_str_length_reg_instance

end_of_str_`'_get_str_length_reg_instance:
end_of_get_length_`'_get_str_length_reg_instance:
	addi $v0, $v0, 0			#  correct length to saved register
	
	_pop($t2)
	_pop($t1)
	_pop($t0)
	_pop($a0)
inc_var(`_get_str_length_reg_instance')')




###############
# get_str_length_label
#	Get length of string from label

# Input:  A label of string
# Output: length of string to $v0

# Side Effects: Loss value in $v0

# Ex: 
#	get_str_length_label(label)
###############

define(get_str_length_label,
	`#Get length of string in $1 to $v0
	_push($a0)
	la	$a0, $1
	get_str_length_reg($a0)
	_pop($a0)
	')



###############
# byte_capitalize_reg
#	Capitalize a byte in register

# Input:  A register
# Output: new value in $v0

# Side Effects: Loss value in $v0

# Ex: 
#	byte_capitalize_reg( $v1)
###############

define(byte_capitalize_reg,
	`#capitalize
	_push($t0)
	#check if lower char?
	sge $t0, $1, 97
	beqz $t0,not_valid_`'_not_valid_instance
	sle $t0, $1, 122 
	beqz $t0,not_valid_`'_not_valid_instance
	addi $v0, $v0, -32

not_valid_`'_not_valid_instance:
	_pop($t0)
inc_var(`_not_valid_instance')')



###############
# capitalize_reg
#	Capitalize a string in register

# Input:  A register
# Output: new capitalized string

# Side Effects: Loss value of old string

# Ex: 
#	capitalize_reg( $a0)
###############

define(capitalize_reg,
	`#Capitalize string
	_push($v0)
	lb $v0, 0($1)
	byte_capitalize_reg($v0)

	#Load back
	sb $v0, 0($1)

	_pop($v0)
	')



###############
# capitalize_label
#	Capitalize a string in label

# Input:  A label
# Output: new capitalized string

# Side Effects: Loss value of old string

# Ex: 
#	capitalize_label( $a0)
###############

define(capitalize_label,
	`#Capitalize label
	_push($a0)
	la $a0,$1
	capitalize_reg($a0)
	_pop($a0)
	')


###############
# str_cpy_string_to_space
#	Copy to space at register $1
#	the content of string at $2

# Input:  1 register with space address, 1 register with string address
# Output: string content to $1

# Side Effects: Loss of space at $a0

# Ex: 
#	str_cpy_string_to_space( $a0, $a1)
###############

define(str_cpy_string_to_space,
	`# Fill space at $1 to content of $2
	 
	_push($a0)
	_push($a1)
	_push($s0)
	_push($t1)
	_push($t2)
	_push($t3)

	#Load
	# a0 = $1
	# a1 = $2
	_push($1)
	_push($2)
	_pop($a1)
	_pop($a0)


	#Implement strcpy
strcpy_`'_str_cpy_instance:
	addi $s0,$zero,0 	#s0 = i = 0

L1_`'_str_cpy_instance:
	add $t1,$s0,$a1		#t1 = address of y[i]  =  s0 + a1 = i + y[0] 
	lb $t2,0($t1)		#t2 = y[i]  =  value at t1 
	

	add $t3,$s0,$a0		#t3 = address of x[i]  =  s0 + a0 = i + x[0] 

	sb $t2, 0($t3)		#x[i]= t2 = y[i]


	beq $t2,$zero,end_of_strcpy_`'_str_cpy_instance 	#if y[i] == 0, exit
	nop								


	addi $s0,$s0,1				# s0++  <->   i++;

	j L1_`'_str_cpy_instance				# Loop back if not finish
	nop

end_of_strcpy_`'_str_cpy_instance:
	_pop($t3)
	_pop($t2)
	_pop($t1)
	_pop($s0)
	_pop($a1)
	_pop($a0)
inc_var(`_str_cpy_instance')')



###############
# str_cpy_reg
#	Create new string at register $a0
#	to the content of string at $2

# Input:  1 register with string address
# Output: new string address at $a0

# Side Effects: Loss old value at $a0

# Ex: 
#	str_cpy_reg($a2)
###############

define(str_cpy_reg,
	`#Copy $2 to $a0
	_push($a1)

.data
	str_`'_strnum: .space _max_str_length
.text

	#Load
	move $a1,$1
	la $a0,str_`'_strnum

	str_cpy_string_to_space($a0, $a1)

	_pop($a1)
inc_var(`_strnum')')


#There's more to strcpy

###############
# str_cpy_label
#	Create new string at register $a0
#	to the content of label $1

# Input: 1 label with string address
# Output: new string address at $a0

# Side Effects: Loss old value at $a0

# Ex: 
#	str_cpy_label( Label)
###############

define(str_cpy_label,
	`#Copy string from label
	_push($a1)
	la $a1,$1
	str_cpy_reg($a1)
	_pop($a1) 
	 ')



###############
# str_cpy_lit
#	Create new string at register $a0
#	to the content of literal string

# Input:   1 string
# Output: new string address at $a0

# Side Effects: Loss old value at $a0

# Ex: 
#	str_cpy_lit( "Hello")
###############

define(str_cpy_lit,
	`#Copy string to $a0
.data
	str_`'_strnum: .asciiz $1
.text
	la $a0,str_`'_strnum
	inc_var(`_strnum')')



###############
# str_find_first_reg_reg
#	Find first occurence of a character

# Input:  register to str to be found, register to character to find
# Output: index of character at v0

# Side Effects: Loss value at $v0

# Ex: 
#	str_find_first_reg_reg( $a0, $a1)
###############

define(str_find_first_reg_reg,
	`#Find first occurence of char at $2
	_push($a0)
	_push($t0)
   	_push($t1)
   	_push($t2)
   	_push($t3)

get_length_`'_get_str_find_first_reg_reg_instance:

	_push($1)
	_push($2)
	_pop($t3)
	_pop($a0)
	# a0 = $1
	# t3 = $2
	lb $t3, 0($t3)

	#set zero
	xor $v0, $zero $zero		#v0 = length = i = 0

check_char_`'_get_str_find_first_reg_reg_instance:
	add $t1, $a0, $v0			# t1 = &x[i]  =  a0 + v0
								
	lb $t2, 0($t1)				# t2 = x[i]

	sne $t0, $t2, $t3
	beq $t0, $zero, end_of_get_length_`'_get_str_find_first_reg_reg_instance	# if (x[i] == char) break loop
	beqz $t2,end_of_str_`'_get_str_find_first_reg_reg_instance  #if(x[i] == null) goto end_of_str_`'_get_str_find_first_reg_reg_instance

	addi $v0, $v0, 1			# length ++;
	j check_char_`'_get_str_find_first_reg_reg_instance

end_of_str_`'_get_str_find_first_reg_reg_instance:
	addi $v0, $zero, -1			#return -1 if not found
	j end_of_str_find_first_reg_reg`'_get_str_find_first_reg_reg_instance

end_of_get_length_`'_get_str_find_first_reg_reg_instance:
	addi $v0, $v0, 0			#  correct length to saved register

end_of_str_find_first_reg_reg`'_get_str_find_first_reg_reg_instance:
	_pop($t3)
	_pop($t2)
	_pop($t1)
	_pop($t0)
	_pop($a0)
inc_var(`_get_str_find_first_reg_reg_instance')')



###############
# str_find_first_reg_lit
#	Find first occurence of a literal character

# Input:  register to str to be found, a literal string
# Output: index of character at $v0

# Side Effects: Loss value at $v0

# Ex: 
#	str_find_first_reg_reg( $a0, "h")
###############

define(str_find_first_reg_lit,
	`# Find first occurence of $2,
	 # save result to $
	 _push($a1)
.data
	str_`'_strnum: .asciiz $2

.text
	la $a1,str_`'_strnum
	str_find_first_reg_reg($1, $a1)
	_pop($a1)
inc_var(`_strnum')')





###############
# str_join_reg_reg
#	Join 2 strings

# Input:  2 registers with string addresses
# Output: new string at $a0

# Side Effects: Loss old value of $a0

# Ex: 
#	str_join_reg_reg( $a1, $a2)
###############

 define(str_join_reg_reg,
 	`#Join 2 string at $1 and $2 to $a0
 	_push($v0)
 	_push($a1)
 	_push($2)

 	str_cpy_reg($1) #Copy string at $1 to $a0

 	#Get address of $2 starting point in $a0
 	str_find_first_reg_lit($a0, "\0")
 	add $a1, $a0, $v0

 	_pop($v0)
 	str_cpy_string_to_space($a1, $v0)

 	_pop($a1)
 	_pop($v0)
 	')


###############
# str_join_reg_label
#	Join 2 strings

# Input:  1 registers with string addresses, 1 label
# Output: new string at $a0

# Side Effects: Loss old value of $a0

# Ex: 
#	str_join_reg_label( $a1, label)
###############

define(str_join_reg_label,
	`# Join string at $1 and label $2
	_push($a1)

	_push($1)
	_pop($a0)

	la $a1,$2
	str_join_reg_reg($a0, $a1)
	_pop($a1)
')


changecom()
divert(0)dnl 