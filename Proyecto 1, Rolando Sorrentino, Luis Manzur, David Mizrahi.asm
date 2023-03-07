.data

integer1: .space 51
integer2: .space 51
inverted1: .space 51
inverted2: .space 51

resultInverted: .space 60
result: .space 60

# Mensajes Inputs
msgInteger1: .asciiz "Enter the first large integer (50 characters): \n--> "
msgInteger2: .asciiz "Enter the second large integer(50 characters): \n--> "
msgOperation: .asciiz "Enter the number of the operation that you want to do: \n1. Addition \n2. Substraction \n3. Multiplication \n--> "

# Salto de línea
salto: .asciiz "\n"

# Mensajes validaciones
msgGreaterLessThan: .asciiz "\n¡WARNING! You have to enter a number between 1 and 3 ¡WARNING!\n"

# Mensaje Output
msgOutput: "El resultado es: "


.text

# Inputs
inputInteger:

	#Imprime el mensaje para introducir el primer entero
	li $v0, 4
	la $a0, msgInteger1
	syscall

	# Input del primer entero
	li $v0, 8
	la $a0, integer1
	li $a1, 51
	syscall
	
	# Salto de línea
	li $v0, 4
	la $a0, salto
	syscall
	
	# Imprime el mensaje para introducir el segundo entero
	li $v0, 4
	la $a0, msgInteger2
	syscall 

	# Input del segundo entero
	li $v0, 8
	la $a0, integer2
	li $a1, 51
	syscall
	
	# Salto de línea
	li $v0, 4
	la $a0, salto
	syscall
	
	# Últimas posiciones de los enteros
	li $t8, 0
	li $t9, 0

	lastPosition1:
		# Cargar el Caracter al cual apunta $t8
		lb $t1, integer1($t8)
		
		# Condiciones de Parada (Salto de línea = 10 en ASCII; Espacio = 32 en ASCII)
		beq $t1, 10, endLastPosition1
		beq $t1, 32, endLastPosition1
		beqz $t1, endLastPosition1
	
		# Iterar hasta conseguir la mayor posición del entero
		addi $t8, $t8, 1
		
		b lastPosition1
	endLastPosition1:

	lastPosition2:
		# Cargar el Caracter al cual apunta $t9
		lb $t2, integer2($t9)
		
		# Condiciones de Parada (Salto de línea = 10 en ASCII; Espacio = 32 en ASCII)
		beq $t2, 10, endLastPosition2
		beq $t2, 32, endLastPosition2
		beqz $t2, endLastPosition2
	
		# Iterar hasta conseguir la mayor posición del entero
		addi $t9, $t9, 1
		
		b lastPosition2	
	endLastPosition2:
	
	# Variables de iteración
	li $t0, 0
	li $t1, 0
	
	# Invertir primer entero
	invertion1:
		# Condición de parada
		blt $t8, 0, endInvertion1
		
		lb $t1, integer1($t8)
		sb $t1, inverted1($t0)
		# Sumamos 1 a $t0 y restamos 1 a $t8
		addi $t0, $t0, 1
		subi $t8, $t8, 1
		
		b invertion1
	endInvertion1:
	
	# Variable de iteración
	li $t0, 0
	
	# Invertir segundo entero
	invertion2:
		# Condición de parada
		blt $t9, 0, endInvertion2
		
		lb $t2, integer2($t9)
		sb $t2, inverted2($t0)
		# Sumamos 1 a $t0 y restamos 1 a $t8
		addi $t0, $t0, 1
		subi $t9, $t9, 1
		
		b invertion2
	endInvertion2:

inputOperation:
	
	li $t1, 0
	
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
	#Inicializamos la variable de iteración $t0 en 1 ya que el primer elemento (0) del número invertido es null
	li $t0, 1
	li $s0, 0
	li $t9, 0
	li $t8, 0
	sum:	
		# Cargar el Caracter al cual apunta $t0
		lb $t1, inverted1($t0)
		lb $t2, inverted2($t0)
		
		# Condición de Parada (Si $t8 o $t9 son menores que 0)
		beqz $t1, printResult	
		beqz $t2, printResult
	
		# Se realiza la suma de los dos dígitos de cada entero
		add $t3, $t1, $t2
		# Se resta menos 48 para dar el valor correcto de la suma en ASCII
		subi $t4, $t3, 48
		
		# Si la suma de los dos dígitos es mayor que 9 (57 en ASCII) entramos en "greaterTen"
		bgt $t4, 57, greaterTen
		# Si la suma de los dos dígitos es menor que 10 (58 en ASCII) entramos en "lessTen"
		ble $t4, 57, lessTen
		
		greaterTen:
			beqz $t8, endChangeCarry
			changeCarry:
				# Se suma el Cociente acarreado en la anterior iteración y se vuelve a declarar $t8 como 0
				li $t7, 0
				add $t7, $t7, $t8
				li $t8, 0
			endChangeCarry:
			
			# Se resta menos 48 para conseguir el valor real de la suma
			subi $t5, $t4, 48
			# Se divide entre 10 para obtener el Resto (Dígito que va dentro del resultado) y Cociente (Dígito que acarreamos)
			div $t6, $t5, 10
			# Se mueve el Cociente a $t8 y el Resto a $t9
			mflo $t8
			mfhi $t9
			
			# Sumamos el Cociente acarreado de la anterior iteración (Si es 0 no afecta)
			add $t9, $t9, $t7
			
			# Se suma al Resto de la división 48 (Ya que es el número que guardaremos en el vector resultado"
			addi $t9, $t9, 48
			
			
			
			# Se guarda el valor en ASCII del Resto dentro del resultado
			sb $t9, resultInverted($s0)
			b endLessTen
		endGreaterTen:
		
		lessTen:
			# Si el Cociente acarreado en la anterior iteración es 0 saltamos a "endCarry2"
			beqz $t8, endCarry2
			carry2:
				# Se suma el Cociente acarreado en la anterior iteración y se vuelve a declarar $t8 como 0
				add $t4, $t4, $t8
				li $t8, 0
			endCarry2:
			
			# Se guarda el valor en ASCII de la suma (Este es el caso en que la suma de ambos dígitos es menor a 10)
			sb $t4, resultInverted($s0)
		endLessTen:
	
		# Incrementamos $t0 = $t0 + 1; $s0 = $s0 + 1
		addi $t0, $t0, 1 
		addi $s0, $s0, 1
		
		b sum
	endSum:

#Sustraction
sustraction:

	j end
	
#Multiplication
multiplication:
	
	j end

#Print result
printResult:
	li $t0, 0
	
	lastPositionResult:
		# Cargar el Caracter al cual apunta $t0
		lb $t1, resultInverted($t0)
		
		# Condiciones de Parada (Salto de línea = 10 en ASCII; Espacio = 32 en ASCII)
		beq $t1, 10, endLastPositionResult
		beq $t1, 32, endLastPositionResult
		beqz $t1, endLastPositionResult
	
		#Iterar hasta conseguir la mayor posición del resultado
		addi $t0, $t0, 1
		
		b lastPositionResult
	endLastPositionResult:
	
	li $t2, 0
	li $t1, 0
	subi $t0, $t0, 1
	
	#Invertimos el resultado para devolverlo a su posición correcta
	resultInvertion:
		# Condición de parada
		blt $t0, 0, endResultInvertion
		
		lb $t1, resultInverted($t0)
		sb $t1, result($t2)
		# Sumamos 1 a $t2 y restamos 1 a $t0
		subi $t0, $t0, 1
		addi $t2, $t2, 1
		
		b resultInvertion
		
	endResultInvertion:
	
	
	# Salto de línea
	li $v0, 4
	la $a0, salto
	syscall
	
	# Print Resultado
	li $v0, 4
	la $a0, msgOutput
	syscall
	li $v0, 4
	la $a0, result
	syscall
	
	j end
	
#Exit
end:

	li $v0, 10
	syscall

