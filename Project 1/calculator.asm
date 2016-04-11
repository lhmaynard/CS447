.text

#$t8 = display
#$t9 = keypad
#$t1 = operand 1
#$t2 = operand 2
#$t3 = operator
#$t4 = result


state0: 
add $t8, $zero, $zero      #reset values
add $t9, $zero, $zero
add $t1, $zero, $zero
add $t2, $zero, $zero
add $t3, $zero, $zero





state1:


add $t9, $zero, $zero          #reset button
wait: beq $zero, $t9, wait     #wait for button press
sll $t9, $t9, 1                #set MSB of $t9 to 0
srl $t9, $t9, 1       

beq $t9, 15, state0
beq $t9, 14, state1_eq
slti $t0, $t9, 10  
beq $t0, $zero, state1_op

state1_num:

addi $s0, $t1, 0            #take already entered digit times 10
sll $s0, $s0, 3
add $s0, $s0, $t1
add $s0, $s0, $t1
add $t1, $t9, $s0     #add (previous digit * 10) to new digit, save as operand 1
addi $t8, $t1, 0               #display operand 1
j state1

state1_op:
add $t3, $zero, $t9             #save operator
addi $t8, $t1, 0               #display operand 1
j state2

state1_eq:
add $t4, $t1, $zero       #save operand 1 as the result
add $t8, $t4, $zero       #display result
j state4





state2:


add $t9, $zero, $zero          #reset button
wait2: beq $zero, $t9, wait2     #wait for button press
sll $t9, $t9, 1                #set MSB of $t9 to 0
srl $t9, $t9, 1       

beq $t9, 15, state0
beq $t9, 14, state2_eq
slti $t0, $t9, 10  
beq $t0, $zero, state2_op

state2_num:

addi $s0, $t2, 0            #take already entered digit times 10
sll $s0, $s0, 3
add $s0, $s0, $t2
add $s0, $s0, $t2
add $t2, $t9, $s0     #add (previous digit * 10) to new digit, save as operand 2
addi $t8, $t2, 0               #display operand 2
j state3

state2_op:
add $t3, $zero, $t9             #save operator
addi $t8, $t1, 0               #display operand 1
j state2

state2_eq:
add $t4, $t1, $zero       #save operand 1 as the result
add $t8, $t4, $zero       #display result
j state4





state3:
add $t9, $zero, $zero          #reset button
wait3: beq $zero, $t9, wait3     #wait for button press
sll $t9, $t9, 1                #set MSB of $t9 to 0
srl $t9, $t9, 1       

beq $t9, 15, state0
beq $t9, 14, state3_eq
slti $t0, $t9, 10  
beq $t0, $zero, state3_op

state3_num:

addi $s0, $t2, 0            #take already entered digit times 10
sll $s0, $s0, 3
add $s0, $s0, $t2
add $s0, $s0, $t2
add $t2, $t9, $s0     #add (previous digit * 10) to new digit, save as operand 2
addi $t8, $t2, 0               #display operand 2
j state3

state3_op:

beq $t3, 13, div3       #perform calculation with selected operater
beq $t3, 12, mul3
beq $t3, 11, sub3

add3: 
add $t4, $t1, $t2      #add the operaters
beq $s4, 1, eq_out
j out

sub3:
sub $t4, $t1, $t2         #subtract operater 2 from operater 1
beq $s4, 1, eq_out
j out

mul3:
add $s0, $zero, $zero           #set counter to 0
add $s1, $zero, $zero      
mulloop:beq $s0, $t2, mdone      #if calculation is finished, skip this iteration
add $s1, $s1, $t1        #add operand 1
addi $s0, $s0, 1         #increment counter
j mulloop
mdone: addi $t4, $s1, 0
beq $s4, 1, eq_out
j out

div3:
add $s0, $zero, $zero           #set counter to 0
add $s1, $t1, $zero   
slt $s6, $s1, $zero
beq $s6, 1, divneg
divloop: slt $s3, $s1, $t2
beq $s3, 1, ddone      #if calculation is finished, skip this iteration
sub $s1, $s1, $t2        #subtract operand 2
addi $s0, $s0, 1         #increment counter
j divloop
ddone: addi $t4, $s0, 0
beq $s4, 1, eq_out
j out

divneg:
sub $s1, $zero, $t1
j divloop 

out:
addi $t8, $t4, 0    #display result
addi $t1, $t4, 0    #set operand 1 to result
add $t2, $zero, $zero
addi $t3, $t9, 0    #set new operator
j state2

state3_eq:
addi $s4, $zero, 1
beq $t3, 13, div3       #perform calculation with selected operater
beq $t3, 12, mul3
beq $t3, 11, sub3
beq $t3, 10, add3

eq_out:
addi $s4, $zero, 0
addi $t8, $t4, 0    #display result
addi $t1, $t4, 0    #set operand 1 to result
add $t2, $zero, $zero
j state4


state4:
add $t9, $zero, $zero          #reset button
wait4: beq $zero, $t9, wait4     #wait for button press
sll $t9, $t9, 1                #set MSB of $t9 to 0
srl $t9, $t9, 1       

beq $t9, 15, state0
beq $t9, 14, state4_eq
slti $t0, $t9, 10  
beq $t0, $zero, state4_op

state4_num:
addi $t1, $t9, 0
addi $t8, $t1, 0

j state1

state4_op:
addi $t1, $t4, 0
addi $t3, $t9, 0
j state2

state4_eq: addi $t8, $t4, 0
j state4


