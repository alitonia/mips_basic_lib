include(new_number.asm)
.data

.text
make_num_var_lit(x, 90)
make_num_var_lit(y, 70)
li $t0, 60
li $t1, 30
num_greater_than_reg_lit($t0, 50)