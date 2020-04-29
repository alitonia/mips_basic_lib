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