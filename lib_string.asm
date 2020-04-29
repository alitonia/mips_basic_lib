#Print_related function

.macro print_string( %__string__)

li $v0,4
la $a0,__string__
syscall

.end_macro