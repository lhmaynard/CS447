.data
                      #    # " !       ' & % $     + * ) (     / . - ,     3 2 1 0     7 6 5 4     ; : 9 8     ? > = <     C B A @     G F E D     K J I H     O N M L     S R Q P     W V U T     [ Z Y X     _ ^ ] \     c b a `     g f e d     k j i h     0 n m l     s r q p     w v u t     { z y x     | } ~ <-
	line1:	.word	0x50502000, 0x2040c020, 0x00002020, 0x00000000, 0x70702070, 0xf870f810, 0x00007070, 0x70000000,	0x70f07070, 0x70f8f8f0, 0x88087088, 0x70888880, 0x70f070f0, 0x888888f8, 0x70f88888, 0x00207000, 0x00800020, 0x00300008, 0x80102080, 0x00000060, 0x00000000, 0x00000040, 0x10000000, 0x00404020
	line2:	.word	0x50502000, 0x20a0c878, 0x20a81040, 0x08000000, 0x88886088, 0x08888030, 0x00008888, 0x88400010, 0x88888888, 0x88808088, 0x90082088, 0x8888d880, 0x88888888, 0x88888820, 0x40088888, 0x00501080, 0x00800020, 0x00400008, 0x80000080, 0x00000020, 0x00000000, 0x00000040, 0x20000000, 0x00a82020
	line3:	.word	0xf8502000, 0x20a01080, 0x20701040, 0x10000000, 0x08082098, 0x1080f050, 0x20208888, 0x0820f820, 0x80888898, 0x80808088, 0xa0082088, 0x88c8a880, 0x80888888, 0x88888820, 0x40105050, 0x00881040, 0x70f07010, 0x70e07078, 0x903060f0, 0x70f8f020, 0x78b878f0, 0xa88888f0, 0x20f88888, 0x00102020
	line4:	.word	0x50002000, 0x00402070, 0xf8d81040, 0x2000f800, 0x301020a8, 0x20f80890, 0x00007870, 0x30100040, 0x80f088a8, 0x80f0f088, 0xc00820f8, 0x88a88880, 0x70f088f0, 0x88888820, 0x40202020, 0x00001020, 0x88880800, 0x88408888, 0xa0102088, 0x8888a820, 0x80488888, 0xa8888840, 0x40108850, 0x00001020
	line5:	.word	0xf8002000, 0x00a84008, 0x20701040, 0x40000030, 0x082020c8, 0x208808f8, 0x20200888, 0x2020f820, 0x8088f898, 0xb8808088, 0xa0882088, 0x88988880, 0x08a08880, 0xa8888820, 0x40402050, 0x00001010, 0x80887800, 0x8840f888, 0xc0102088, 0x8888a820, 0x70408888, 0xa8508840, 0x20208820, 0x00002020
	line6:	.word	0x50000000, 0x009098f0, 0x20a81040, 0x80000030, 0x88402088, 0x20888810, 0x20008888, 0x00400010, 0x88888880, 0x88808088, 0x90882088, 0x88888880, 0x88909880, 0xd8508820, 0x40802088, 0x00001008, 0x80888800, 0x78408088, 0xa0102088, 0x8888a820, 0x084078f0, 0xa8508840, 0x20407850, 0x00002020
	line7:	.word	0x50002000, 0x00681820, 0x00002020, 0x00200010, 0x70f87070, 0x20707010, 0x00007070, 0x20000000, 0x70f08878, 0x7080f8f0, 0x88707088, 0x708888f8, 0x70887880, 0x88207020, 0x70f82088, 0xf8007000, 0x78f07800, 0x08407878, 0x90907088, 0x7088a870, 0xf0400880, 0x50207830, 0x10f80888, 0x00004020
	line8:	.word	0x00000000, 0x00000000, 0x00000000, 0x00000020, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xf0000000, 0x00600000, 0x00000000, 0x00000880, 0x00000000, 0x00007000, 0x00000000

	prompt: .asciiz "Enter file name: "	
	filename: .space 100
	buffer: .space 80

.text
li $v0, 4
la $a0, prompt
syscall
li $v0, 8
la $a0, filename
li $a1, 9999
syscall               #get filename

la $t5, filename
NLloop: addi $t5, $t5, 1
lb $t4, ($t5)
bne $t4, 10, NLloop
sb $zero, ($t5)


li $v0, 13
la $a0, filename
li $a1, 0
addi $a2, $zero, 1
syscall
move $s0, $v0           #set $s0 to file descriptor

######################
_main:
move $a0, $s0
la $a1, buffer
jal _readLine

la $a0, buffer
jal _printBuffer
jal _printSpaceBetweenLine
beqz $v0, _main
mainEnd:
li $v0, 10
syscall


# $a0 = file descriptor
# $a1 = address of buffer
_readLine:
li $s1, 0     # $s1 = counter

loop:
li $a2, 1
li $v0, 14
syscall             #read character into buffer
lb $t0, ($a1)



beqz $t0, endofline
beq $t0, 10, newline
addi $s1, $s1, 1     #increment counter
addi $a1, $a1, 1     #increment buffer address
j loop

newline:
li $v0, 0         #not end of file, return 0
j fill

endofline:  
li $v0, 1           #end of line, return 1
j fill

fill:
li $t3, 80
sub $t1, $t3, $s1     # $t1 = number of spaces to be added
li $t2, 32
fillLoop:
beqz $t1, endFill    #if all spaces added, branch out of loop
sb $t2, ($a1)        #put space in buffer
addi $a1, $a1, 1     #increment buffer address
subi $t1, $t1, 1     
j fillLoop

endFill:
jr $ra



# $a0 = address of buffer
_printBuffer:
move $s6, $a0
la   $a1, line1
move $a0, $s6
subi $sp, $sp, 4
sw $ra, ($sp)
jal  _printLine
move $a0, $s6
la   $a1, line2
jal  _printLine
move $a0, $s6
la   $a1, line3
jal  _printLine
move $a0, $s6
la   $a1, line4
jal  _printLine
move $a0, $s6
la   $a1, line5
jal  _printLine
move $a0, $s6
la   $a1, line6
jal  _printLine
move $a0, $s6
la   $a1, line7
jal  _printLine
move $a0, $s6
la   $a1, line8
jal  _printLine
lw $ra, ($sp)
addi $sp, $sp, 4
jr $ra

# $a0 = address of buffer
# $a1 = address of line data
_printLine:
li $s3, 0               #set $s3 to zero
li $s2, 0                #set part counter to zero
li $s4, 0                #set big counter to zero

partA:
lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 2           #shift right to remove excess zeros, keep one for space between chars

or $s3, $s3, $t5         #merge $s3 and $t5
beq $s2, 4, skipA
sll $s3, $s3, 6          #shift left to make room for next letter representation
skipA:
addi $s2, $s2, 1           #increment counter
addi $a0, $a0, 1           #increment char address

blt $s2, 5, partA           #add 5 regulars
sll $s3, $s3, 2

lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 6           #shift right to remove last 6 bits

or $s3, $s3, $t5         #merge $s3 and $t5

addi $t8, $s3, 0         #send info to printer
addi $t9, $0, 1          #print
li $s2, 0               #reset part counter
li $s3, 0               #reset $s3

partB:
lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 2           #shift right to remove excess zeros, keep one for space between chars
li $t0, 15
and $t5, $t5, $t0         #remove first 2 bits
or $s3, $s3, $t5         #merge $s3 and $t5
sll $s3, $s3, 6          #shift left to make room for next letter representation
addi $a0, $a0, 1           #increment char address
regB:
lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 2           #shift right to remove excess zeros, keep one for space between chars

or $s3, $s3, $t5         #merge $s3 and $t5
beq $s2, 3, skipB
sll $s3, $s3, 6          #shift left to make room for next letter representation
skipB:
addi $s2, $s2, 1           #increment counter
addi $a0, $a0, 1           #increment char address
blt $s2, 4, regB           #add 4 regulars

sll $s3, $s3, 4
lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 4           #shift right to remove last 4 bits
or $s3, $s3, $t5         #merge $s3 and $t5

addi $t8, $s3, 0         #send info to printer
addi $t9, $0, 1          #print
li $s2, 0               #reset part counter
li $s3, 0               #reset $s3

partC:
lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 2           #shift right to remove excess zeros, keep one for space between chars
li $t0, 3
and $t5, $t5, $t0         #remove first 4 bits
or $s3, $s3, $t5         #merge $s3 and $t5
sll $s3, $s3, 6          #shift left to make room for next letter representation
addi $a0, $a0, 1           #increment char address
regC:
lbu $t6, ($a0)          #load char
subi $t6, $t6, 32
add $t7, $a1, $t6        #get address of char representation
lbu $t5, ($t7)             #load char representation
srl $t5, $t5, 2           #shift right to remove excess zeros, keep one for space between chars

or $s3, $s3, $t5         #merge $s3 and $t5
beq $s2, 4, skipC
sll $s3, $s3, 6          #shift left to make room for next letter representation
skipC:
addi $s2, $s2, 1           #increment counter
addi $a0, $a0, 1           #increment char address
blt $s2, 5, regC           #add 5 regulars

addi $t8, $s3, 0         #send info to printer
addi $t9, $0, 1          #print
li $s2, 0               #reset part counter
li $s3, 0               #reset $s3

addi $s4, $s4, 1        #increment big counter
blt $s4, 5, partA

jr $ra


_printSpaceBetweenLine:
li $s7, 0     #set counter to zero
spaceLoop:
beq $s7, 75, doneSpace
add $t8, $0, $0           #send info to printer
addi $t9, $0, 1           #print
addi $s7, $s7, 1          #increment counter
j spaceLoop
doneSpace:
jr $ra



