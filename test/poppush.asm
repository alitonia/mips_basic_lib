divert(-1)
define(_push,
	`
	addi $sp, $sp, -4
    sw $1, 0($sp)
	')

define(_pop,
	`
	lw $1, ($sp)
	addi $sp, $sp, 4
	')

divert(0)dnl 