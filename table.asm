################################################################################
##
## table.asm
##
## Author: Antonio Recalde
##
## Register usage:
##		$t1		- holds Minimum value
##		$t2		- holds Maximum value
##		$a0		- syscall
##		$s1		- counter
##		$s2		- table index
##		$s7		- store size
##		$v0		- syscall
##
################################################################################

			.data
size: 		.word 	9
table: 		.word 	3, -1, 6, 5, 7, -3, -15, 18, 2
Largest: 	.asciiz "Largest: "
Smallest: 	.asciiz "Smallest: "
endl: 		.asciiz "\n"
SpaceBar: 	.asciiz " "

			
			.text

main:
			lw		$s7, size 			# get size of list
			move 	$s1, $zero 			# set counter for # of elems printed
			move 	$s2, $zero 			# set table index
			b 		init
			
init:
			lw 		$t1, table($s2)		# first item on the list is new Minimum value
			lw 		$t2, table($s2)		# first item on the list is new Maximum value
			b 		Loop				# jump to Loop

Loop:
			bge 	$s1, $s7, end 		# stop after last elem is loaded
			lw 		$a0, table($s2) 	# load to $a0 to print next value from the list
			
			blt 	$t1, $a0, newMin	# if current minimum is less than $a0, update minimum value
			bgt 	$t2, $a0, newMax	# if current max is greater than $a0, update maximum value
			
			li 		$v0, 1				
			syscall
			
			la 		$a0, SpaceBar
			li 		$v0, 4
			syscall
			
			addi 	$s1, $s1, 1 		# increment counter
			addi 	$s2, $s2, 4 		# step to the next array elem
			
			b Loop 						# loop

newMin:									# sets new Minimum value when found
			lw 		$t1, table($s2)		# loads into $t1, elements at current ($s2) index
			b Loop
			
newMax:									# sets new Maximum value when found
			lw 		$t2, table($s2)		# loads into $t2, elements at current ($s2) index
			b Loop

end:
			la 		$a0, endl
			li 		$v0, 4
			syscall

			la 		$a0, Largest
			li 		$v0, 4
			syscall

			move 	$a0, $t1
			li 		$v0, 1
			syscall
			
			la 		$a0, endl
			li 		$v0, 4
			syscall
			
			la 		$a0, Smallest
			li 		$v0, 4
			syscall
			
			move 	$a0, $t2
			li 		$v0, 1
			syscall
			
			la		$a0, endl
			li		$v0, 4
			syscall
			
			li 		$v0, 10
			syscall
