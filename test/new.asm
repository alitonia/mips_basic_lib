


    
	addi $sp, $sp, -4
    sw $v0, 0($sp)
	
    
	addi $sp, $sp, -4
    sw $a0, 0($sp)
	
    
	li	$v0, 4
	.data
	str1:	.asciiz	"Hello"
	.text

	
	la	$a0, str1
	syscall

	
	lw $a0, ($sp)
	addi $sp, $sp, 4
	
	
	lw $v0, ($sp)
	addi $sp, $sp, 4
	

