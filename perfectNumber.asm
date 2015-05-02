################################################################################
##
##	perfectNumber.asm
##
##	Author: Antonio Recalde
##
##
##	This program finds Perfect Numbers within the range (5, 500)
##
##	The method implemented follows Euclid's proof that an even number is per-
##	-fect whenever the number is equal to (2^(p-1))(2^p-1) and (2^p-1) equals a
##	Mersenne Prime Number.
##
##	E.g.	for p = 2:	 2^1(2^2 - 1) = 6
##
##	Note: The smallest non-mersenne prime is 11. 11 is out of range. Hence all 
##  primes found in this program are Mersenne primes. The program does not 
##  apply the Lucas–Lehmer primality test on the primes found. However, it could
##  be incorporated with success.
##			
################################################################################
##
##	Register usage:
##		$t0		- N
##		$t2		- Divisor
##		$t3		- Iteration Counter (@Exp)
##				- Result (@calculate)
##		
##		$t4		- N/2 (@process)
##				- Iteration Counter (@Exp)
##		
##		$s0		- Power of 2
##		$s2		- Multiplier 2
##		$a0		- Syscall
##
################################################################################

       .text
main:
        li      $t0, 2						# load our starting point.. value 2
        li      $t1, 2						# we use $t1 as a divisor
        li		$s0, 2						# used for finding powers of 2
        b       checkPrime					# lets determine if the number is a prime

checkPrime:
        ble     $t0, 3, isPrime				# if its less than 3, its a prime
        div     $t0, $t1					# divide 
        mflo    $t4							# store quotient in $t4. That will help us determine out stopping condition

        b       process						# lets do something with the results

process:
        div     $t0, $t1					# lets find if the number in $t0 is divisible by any other number
        mfhi    $t3							# store modulo in $t3
        beq     $t3, $zero, updateNumber	# if mod = 0, lets go to the next number.. not a prime
        addu    $t1, $t1, 1					# update divisor.. we will divide #t1 by every number up to its half
        									## .. it is computationally inefficient to find a prime this way, but given the ranges
        									### .. in this problem, it works quite appropriately in relation to the needs.
        
        bgt     $t1, $t4, isPrime			# if our counter surpasses $t0/2, it's a prime

        b       process

updateNumber:
        addi    $t0, $t0, 1					# lets see if the next number is prime
        li      $t1, 2						# reset our divisor. 
        li		$s0, 2						# here we will store our powers of 2.
        li		$s1, 2						# we will the multiplier
        b       checkPrime					# now check if this number is a prime.

isPrime:
		la		$a0, prime_msg				# print message	
		li		$v0, 4						
		syscall	
		move	$a0, $t0					# print Mersenne Prime 
		li		$v0, 1						# Note: I claim its a Mersenne Prime because the first non-mersenne prime
		syscall								## ..is out of range. However, a Lucas–Lehmer primality test can be incorporated
		la		$a0, tab					### ..to this code, to find all possible perfect numbers within our computational reach
		li		$v0, 4
		syscall



		li		$s1, 2						# this register will be used to store the current power of 2
		subu	$t4, $t0, 1					# $t4 (p - 1). It will help us tell when we are at 2^(p-1)
		li		$t3, 1						# $t3 is a counter now. Counts iterations of power of 2
		b		Exp
		
Exp:
		beq		$t3, $t0, calculate			# if counter reached p (prime number) then we have 2^p
		beq		$t3, $t4, Exp2				# if
		mult	$s0, $s1					# 2*2, then 4*2, 8*2.... etc
		mflo	$s0							# store result of mult in $s1
		addi	$t3, $t3, 1					# increase counter

		b		Exp
		
Exp2:
		move 	$t4, $s0					# save the current result of powers of 2 in $t4 
		b		Exp							# continue the previous operation
		
calculate:									# finds ( 2^(p-1) )( (2^p) - 1)
		subu	$s0, $s0, 1					# $s1 was 2^p.. after substracting, (2^p) - 1 
		mult	$s0, $t4					# ( 2^(p-1) )( (2^p) - 1)
		mflo	$t3							# store value in $t3
		
		la		$a0, result					# print message	
		li		$v0, 4						
		syscall	
		move	$a0, $t3					# print result 
		li		$v0, 1
		syscall	
		la		$a0, endl2				
		li		$v0, 4
		syscall
		
		bge		$t0, 7, fin					# if $t0 is >= 7, results go beyond the required 500 limit.
		b		updateNumber				# we're not beyong 500 yet, so let's find the next prime.
		
fin:
		li		$v0, 10
		syscall

		
## Here's where the data for this program is stored:   
        
        .data
spaceBar:		.asciiz		" "
tab:			.asciiz		"\t\t"
endl2:			.asciiz		"\n\n"
prime_msg:		.asciiz		"*Mersenne Prime Number found: " 	# I make this claim because only Mersenne Prime numbers are found within the range we are working with.
exp_msg:		.asciiz		"Value of 2^(p-1): "
exp2_msg:		.asciiz		"Value of [(2^p)-1]: "
result:			.asciiz		"Perfect Number:  "
        
   



