divert(-1) #Prevent output

# A library for manipulation of stack

(# Done:
 # 	push
 # 	pop
 
 # Pending:
 # 
 # )

changecom(//)

###############
# _push
# Push content of a register to stack ($sp)

# Input:  A register
# Output: content of the next 4_byte of stack
# 		is set to the value of register
#
# Side effects: Change $sp value

# Ex: push($s1)

###############

define( _push,
	`#Push $1 to stack
	addi $sp, $sp, -4
    sw $1, 0($sp)
	')


###############
# _pop
# Pop content of stack to a register ($sp)

# Input:  A register
# Output:  content of register
# 		is set to the value of 4 byte of stack

# Side effects: None

# Ex: pop($s1)

###############

define(_pop,
	`#Pop stack to $1
	lw $1, ($sp)
	addi $sp, $sp, 4
	')

changecom()
divert(0)dnl 