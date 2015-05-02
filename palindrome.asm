################################################################################
##
## palindrome.asm -- reads a line of text and tests whether it is a palindrome.
##
##	Modified: Antonio Recalde
##
##
################################################################################
##
##
## Register usage:
##	$t1	- A.
##	$t2	- B.
##	$t3	- the character *A.
##	$t4	- the character *B.
##	$v0	- syscall parameter / return values.
##	$a0	- syscall parameters.
##	$a1	- syscall parameters.
##
################################################################################

	.globl  length_loop
        .globl  string_space
	    
        
        .text
main:				          			# SPIM starts by jumping to main.
					   
	la      $a0, string_space			# read the string S:
	li      $a1, 1024
	li      $v0, 8	                   	# load "read_string" code into $v0.
	syscall	

	la      $t1, string_space	  		# initialize $t1 to point to the start

	la      $t2, string_space          	# we need to move B to the end

length_loop:			           		#	of the string:
	lb		$t3, ($t2)	           		# load the byte *B into $t3.
	beqz	$t3, end_length_loop       	# if $t3 == 0, branch out of loop.
	addu	$t2, $t2, 1	           		# otherwise, increment B,
	b	length_loop		   				#  and repeat the loop.

	
	
end_length_loop:
	subu	$t2, $t2, 2	           		# subtract 2 to move B back past
				           				#  the '\0' and '\n'.

				           
updateRegister:
	bge     $t1, $t2, is_palin	   		# if A >= B, it is a palindrome.

	lb      $t3, ($t1)                 	# load the byte *A into $t3,
	lb      $t4, ($t2)	           		# load the byte *B into $t4.
	
	b		testStart					# test the starting character in the substring

testStart:								# this tests isAlphaNumeric()
	blt		$t3, '0', nextStart			# No letters below '0'. Update substring start with nextStart if so
	ble		$t3, '9', testEnd			# if the char is > '0', but >= '9', then it must be a number. So, 
										# test the end of the substring if that is the case.

	bgt		$t3, 'z', nextStart			# if the char is greater than 122, is not Alphabetic
	blt		$t3, 'A', nextStart			# likewise if its smaller than ascii 65, not alpha
	
	bge		$t3, 'a', testEnd			# at this point, if char >= 97, isAlpha() = true. Move on to test end.						
	ble		$t3, 'Z', toLowerStart		# but, if we are here.. and if < 'Z', char is uppercase.. so toLower()
	b		nextStart					# if between 90 and 96, it's not alphabetic
	
nextStart:								# this sets a new start for our substring		
	addu	$t1, $t1, 1                	# increment A,
	b 		updateRegister				# reload the values of $t3 and $t4

nextEnd:								# sets new end of substring
	subu	$t2, $t2, 1					# update end pointer
	b		updateRegister				# reload $t3, $t4
	
testEnd:								# tests if end of string is AlphaNumeric
	blt		$t4, '0', nextEnd			# No letters below '0'. So if condition applies, find next end of substring
	ble		$t4, '9', compare			# if condition is met, It is a number. So,  compare start and end of substring.
	
	bgt		$t4, 'z', nextEnd			# not alphabetical if greater than ascii 122
	blt		$t4, 'A', nextEnd			# not alphabetical if smaller than ascii 65
	bge		$t4, 'a', compare			# yes, isAlpha() = true! Continue to compare start and end chars
	ble		$t4, 'Z', toLowerEnd		# at this point, if smaller or equal to 90, isUpper() = true.
	b		nextEnd						# if char is between 'Z' and 'a' (90 |*| 97), isAlpha() = false.
	
	
toLowerStart:							# start of substring was uppercase.. let's make it a lowercase.
	addu	$t3, $t3, 'a'				# basically, the next two lines add 32 to it.
	subu	$t3, $t3, 'A'
	b		testEnd						# we are done testing the start of the substring.. now test the End.
	
toLowerEnd:								# intends to do the same as toLower() in C
	addu	$t4, $t4, 'a'				# basically means add 32.
	subu	$t4, $t4, 'A'
	b		testEnd
	
compare:								# test to see if start and end of substring match.
	bne     $t3, $t4, not_palin	   		# if $t3 != $t4, not a palindrome.
										
	b		substring					# ..start and end were a match, now lets go to the next substring.
	
substring:									
	addu	$t1, $t1, 1                	#  increment A,
	subu	$t2, $t2, 1                	#  decrement B,
	b	updateRegister              	#  and repeat the loop.

is_palin:	                           	# print the is_palin_msg, and exit.
	la         $a0, is_palin_msg
	li         $v0, 4
	syscall
	b          exit

not_palin:
	la         $a0, not_palin_msg	  	# print the is_palin_msg, and exit.
	li         $v0, 4
	syscall

exit:			                  		# exit the program:
	li		$v0, 10	          			# load "exit" into $v0.
	syscall			          			# make the system call.
	
	
	
	
	
## Here is where the data for this program is stored:
	.data
string_space:	.space	1024  	# set aside 1024 bytes for the string.
is_palin_msg:	.asciiz "The string is a palindrome.\n"
not_palin_msg:	.asciiz "The string is NOT a palindrome.\n"
## end of palindrome.asm
