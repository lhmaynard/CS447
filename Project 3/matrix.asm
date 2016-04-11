.text

la $t0, 0xFFFF8000
li $s0, 0x00002200
bgLoop:
li $a0, 10
li $a1, 93
li $v0, 42
syscall
addi $a0, $a0, 33
sll $a0, $a0, 24
or $t1, $s0, $a0
sw $t1, ($t0)
addi $t0, $t0, 4
blt $t0, 0xFFFFB200, bgLoop
################## Generate initial runners ##########################
subi $sp, $sp, 204      #make room in stack
li $t0, 0     #counter
startLoop:
mul $t1, $t0, 4    # $t1 = $sp offset
li $a0, 10        #seed
li $a1, 80        #upper bound
li $v0, 42
syscall

jal _checkValid
beqz $v0, startLoop

move $t5, $a0                  # $t5 contains random column number 

mul $t8, $a0, 4

addi $s7, $t8, 0xFFFF8000     # $s7 contains address of top of column
lw $t8, ($s7)
addi $t8, $t8, 0x0000DD00     #set to head brighness
sw $t8, ($s7)


li $a0, 10        #seed
li $a1, 4        #upper bound
li $v0, 42
syscall
move $t6, $a0
addi $t6, $t6, 1    # $t6 contains random speed

move $t7, $t5
sll $t7, $t7, 8
or $t7, $t7, $t6      # $t7 contains complete runner representation

add $sp, $sp, $t1     #get address of current runner
sw $t7, ($sp)         #store 
sub $sp, $sp, $t1    #restore $sp




addi $t0, $t0, 1
blt $t0, 50, startLoop

############## Main loop ##################  
main:
li $t4, 0      #counter
li $t6, 1       #speed
mainLoop:

mul $t5, $t4, 4    # $t5 = $sp offset

add $sp, $sp, $t5     #get address of current runner
lw $t7, ($sp)         #load into $t7
sub $sp, $sp, $t5    #restore $sp

move $t8, $t7            # copy data
andi $t8, $t8, 7
bgt $t8, $t6, skip          #don't iterate this runner if its speed is greater than the loop's speed value

srl $t7, $t7, 8      #get column number of runner at address
move $a0, $t7
jal _iterate
move $a1, $t5         #move column offset into argument#######################
beq $v0, 1, _reset

skip:

addi $t4, $t4, 1
blt $t4, 50, mainLoop
li $t4, 0

addi $t6, $t6, 1
blt $t6, 6, skipSpeed
li $t6, 1
skipSpeed: 
j mainLoop



################### Iterate #############################    

# $a0 = column 
_iterate: 
li $v0, 1
mul $t0, $a0, 4
addi $t3, $t0, 0xFFFF8000     # $t3 contains address of top of column


itLoop:
	
lw $t1, ($t3)
andi $t2, $t1, 0x0000FF00
beq $t2, 0x00002200, itLoopBot   #if the character has background color don't do anything
li $v0, 0   #indicate that the column wasn't empty

subi $t1, $t1, 0x00001100     #decrement color
sw $t1, ($t3)               #store back to memory

bne $t2, 0x0000FF00, itLoopBot
addi $t3, $t3, 320         #increment address to next row
lw $t1, ($t3)              #load value
addi $t1, $t1, 0x0000DD00  #set to head brighness
sw $t1, ($t3)              #store back to memory

itLoopBot: addi $t3, $t3, 320    #increment address to next row
blt $t3, 0xFFFFb200 itLoop
jr $ra

############## Check Valid ####################   

# $a0 = potential column number
# $v0 returns 1 if valid, 0 if not
_checkValid:
li $s0, 0           #counter
li $v0, 1

validLoop:
mul $s1, $s0, 4     # $s1 = $sp offset

add $sp, $sp, $s1     #get address of current runner
lw $s2, ($sp)         #load into $s2
sub $sp, $sp, $s1    #restore $sp

srl $s2, $s2, 8      #get column number of runner at address
beq $a0, $s2, notValid

addi $s0, $s0, 1       #increment counter
blt $s0, 51, validLoop
jr $ra

notValid:
li $v0, 0
jr $ra

############## Reset ######################

# $a0 contains column number to be changed
# $a1 contains offset from $sp
_reset:

move $t9, $a0
move $s6, $a1

resetLoop:

li $a0, 10        #seed
li $a1, 80        #upper bound
li $v0, 42
syscall
move $a1, $ra
jal _checkValid
move $ra, $a1
beqz $v0, resetLoop

move $s5, $a0                  # $s5 contains random column number 


mul $s3, $a0, 4

addi $s7, $s3, 0xFFFF8000     # $s7 contains address of top of column
lw $s3, ($s7)
addi $s3, $s3, 0x0000DD00     #set to head brighness
sw $s3, ($s7)
####### started head

li $a0, 10        #seed
li $a1, 4        #upper bound
li $v0, 42
syscall

addi $a0, $a0, 1    # $a0 contains random speed

move $s4, $s5
sll $s4, $s4, 8
or $s4, $s4, $a0      # $s4 contains complete runner representation

add $sp, $sp, $s6     #get address of current runner
sw $s4, ($sp)         #store 
sub $sp, $sp, $s6    #restore $sp

jr $ra




