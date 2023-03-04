.data

inputSize: .word 51

integer1: .space 52
integer2: .space 52

#Mensajes Inputs
msgInteger1: .asciiz "Enter the first large integer (50 characters): \n--> "
msgInteger2: .asciiz "Enter the second large integer(50 characters): \n--> "
msgOperation: .asciiz "Enter the number of the operation that you want to do: \n1. Addition \n2. Substraction \n3. Multiplication \n--> "

#Salto de línea
salto: .asciiz "\n"

#Mensajes validaciones
msgGreaterLessThan: .asciiz "\n¡WARNING! You have to enter a number between 1 and 3 ¡WARNING!\n"


.text

#Inputs
inputInteger:

	#Imprime el mensaje para introducir el primer entero
	li $v0, 4
	la $a0, msgInteger1
	syscall

	#Input del primer entero
	li $v0, 8
	la $a0, integer1
	lw $a1, inputSize
	syscall
		
	#Imprime el mensaje para introducir el segundo entero
	li $v0, 4
	la $a0, msgInteger2
	syscall 

	#Input del segundo entero
	li $v0, 8
	la $a0, integer2
	lw $a1, inputSize
	syscall
	
	#Salto de línea
	li $v0, 4
	la $a0, salto
	syscall
	

inputOperation:
	
	#Imprime el mensaje para introducir la operación a realizar
	li $v0, 4
	la $a0, msgOperation
	syscall
	
	#Input de la operación a realizar
	li $v0, 5
	syscall
	move $t1, $v0
	
	j validations


#Validations
validations:

	#Operation validation
	beq $t1, 1, addition
		
	beq $t1, 2, sustraction
	
	beq $t1, 3, multiplication
	
	#Validación si inputOperation es menor que 1 o mayor que 3
	bgt $t1, 3, greaterThan	
	blt $t1, 1, lessThan
	
	j end
	
#Exceptions
greaterThan:
	li $v0, 4
	la $a0, msgGreaterLessThan
	syscall
	
	j inputOperation

lessThan:
	li $v0, 4
	la $a0, msgGreaterLessThan
	syscall
	
	j inputOperation
	
#Addition
addition:
	
	j end

#Sustraction
sustraction:

	j end
	
#Multiplication
multiplication:
	
	j end

#Exit
end:
	li $v0, 10
	syscall

