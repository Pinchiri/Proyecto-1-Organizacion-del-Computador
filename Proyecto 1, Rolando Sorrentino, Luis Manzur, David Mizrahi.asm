.data

integer1: .space 51
integer2: .space 51
inverted1: .space 51
inverted2: .space 51

operation: .space 3

resultInverted: .space 102
result: .space 102

# Mensajes Inputs
msgBienvenue: .asciiz "----------  WELCOME!  ---------- \n\nFirst you will have to enter the two large integers \nPlease note that you have to put the sign of the number first, e.g: '+10' , '-10'\n\n"
msgInteger1: .asciiz "Enter the first large integer (50 characters): \n--> "
msgInteger2: .asciiz "Enter the second large integer(50 characters): \n--> "
msgOperation: .asciiz "Enter the number of the operation that you want to do: \n1. Addition \n2. Substraction (The first integer will be substracted by the second)   \n3. Multiplication \n4. Exit the program \n--> "

# Salto de l�nea
salto: .asciiz "\n"

# Mensajes validaciones
msgGreaterLessThan: .asciiz "\n!WARNING! You have to enter a number between 1 and 4 !WARNING!\n"

# Mensaje Output
msgOutput: " ------------------------------------------------\n El resultado es: "


.text

# Inputs
inputInteger:
	
	#Imprime el mensaje para introducir el primer entero
	li $v0, 4
	la $a0, msgBienvenue
	syscall

	#Imprime el mensaje para introducir el primer entero
	li $v0, 4
	la $a0, msgInteger1
	syscall

	# Input del primer entero
	li $v0, 8
	la $a0, integer1
	li $a1, 51
	syscall
	
	# Salto de l�nea
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
	
	# Salto de l�nea
	li $v0, 4
	la $a0, salto
	syscall
	
	# �ltimas posiciones de los enteros
	li $t8, 0
	li $t9, 0
	
	# Signos de cada n�mero
	lb $s0, integer1($0)
	lb $s1, integer2($0)
	
	sub $s3, $s0, $s1
	
	lastPosition1:
		# Cargar el Caracter al cual apunta $t8
		lb $t1, integer1($t8)
		
		# Condiciones de Parada (Salto de l�nea = 10 en ASCII; Espacio = 32 en ASCII)
		beq $t1, 10, endLastPosition1
		beq $t1, 32, endLastPosition1
		beqz $t1, endLastPosition1
	
		# Iterar hasta conseguir la mayor posici�n del entero
		addi $t8, $t8, 1
		
		b lastPosition1
	endLastPosition1:

	lastPosition2:
		# Cargar el Caracter al cual apunta $t9
		lb $t2, integer2($t9)
		
		# Condiciones de Parada (Salto de l�nea = 10 en ASCII; Espacio = 32 en ASCII)
		beq $t2, 10, endLastPosition2
		beq $t2, 32, endLastPosition2
		beqz $t2, endLastPosition2
	
		# Iterar hasta conseguir la mayor posici�n del entero
		addi $t9, $t9, 1
		
		b lastPosition2	
	endLastPosition2:
	
	# Variables de iteraci�n
	li $t0, 0
	li $t1, 0
	
	# Se guardan los tama�os de los dos n�meros para usarlos posteriormente
	la $s4, ($t8)
	la $s5, ($t9)
	
	blt $s4, $s5, firstGreatest
	bgt $s4, $s5, secondGreatest
	
	# Si el segundo n�mero es mayor setea en $s6 su tama�o
	firstGreatest:
		la $s6, ($s5)
		li $s4, 0
		li $s5, 0
		j endSecondGreatest

	endFirstGreatest:
	
	# Si el primer n�mero es mayor setea en $s6 su tama�o
	secondGreatest:
		la $s6, ($s4)
		li $s4, 0
		li $s5, 0
	endSecondGreatest:
	
	subi $s6, $s6, 1
	# Invertir primer entero
	invertion1:
		# Condici�n de parada
		blt $t8, 0, endInvertion1
		
		lb $t1, integer1($t8)
		sb $t1, inverted1($t0)
		# Sumamos 1 a $t0 y restamos 1 a $t8
		addi $t0, $t0, 1
		subi $t8, $t8, 1
		
		b invertion1
	endInvertion1:
	
	# Variable de iteraci�n
	li $t0, 0
	
	# Invertir segundo entero
	invertion2:
		# Condici�n de parada
		blt $t9, 0, endInvertion2
		
		lb $t2, integer2($t9)
		sb $t2, inverted2($t0)
		# Sumamos 1 a $t0 y restamos 1 a $t8
		addi $t0, $t0, 1
		subi $t9, $t9, 1
		
		b invertion2
	endInvertion2:

inputOperation:
	
	li $s7, 0
	
	#Imprime el mensaje para introducir la operaci�n a realizar
	li $v0, 4
	la $a0, msgOperation
	syscall
	
	#Input de la operaci�n a realizar
	li $v0, 8
	la $a0, operation
	li $a1, 3
	syscall
	
	# Salto de l�nea
	li $v0, 4
	la $a0, salto
	syscall
	
	lb $s7, operation($0)
	j validations


#Validations
validations:

	#Operation validation
	beq $s7, 49, additionSign
	
	j endAdditionSign
		
	additionSign:
		beqz $s3, addition
		bnez $s3, sustraction
	endAdditionSign:
	
	beq $s7, 50, sustractionSign
	
	j endSustractionSign
	
	sustractionSign:
		beqz $s3, sustraction
		bnez $s3, addition
	endSustractionSign:
	
	beq $s7, 51, multiplication
	
	beq $s7, 52, end
	
	#Validaci�n si inputOperation es menor que 1 o mayor que 3
	bgt $s7, 52, greaterThan	
	blt $s7, 49, lessThan
	
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
	
	sb $s0, resultInverted($s6)
	
	#Inicializamos la variable de iteraci�n $t0 en 1 ya que el primer elemento (0) del n�mero invertido es null
	li $t0, 1 
	li $t4, 0 # Variable de iteraci�n del resultado
	li $t9, 0 
	li $t8, 0 # Acarreo

	sum:	
		# Cargar el Caracter al cual apunta $t0
		lb $t1, inverted1($t0)
		lb $t2, inverted2($t0)

		# Condici�n de Parada (Si $t8 o $t9 son menores que 0)
		bgt $t0, $s6, lastDigit	

		j endLastDigit
		
		# Si el �ltimo d�gito no tiene un acarreo imprime el resultado; mientras que si tiene un acarreo todav�a lo agrega como �ltimo d�gito del resultado
		lastDigit:
			beqz $t8, printResult
			
			addi $t8, $t8, 48
			sb $t8, resultInverted($t4)
			addi $t4, $t4, 1
			sb $s0, resultInverted($t4) 
			j printResult
		endLastDigit:
		
		# Si $t1 o $t2 no es un n�mero va a "null1" o "null2"
		blt $t1, 48, null1
		blt $t2, 48, null2

		# Se realiza la suma de los dos d�gitos de cada entero
		add $t3, $t1, $t2
		blt $t3, 58, null
		# Se resta menos 48 para dar el valor correcto de la suma en ASCII
		subi $t3, $t3, 48
		
		j null
		
		# Si $t1 no es un n�mero guarda en $t4 (resultado de la suma) el valor de $t2
		null1:
			la $t3, ($t2)
			j lessTen
		
		# Si $t2 no es un n�mero guarda en $t4 (resultado de la suma) el valor de $t1
		null2:
			la $t3, ($t1)
			j lessTen
			
		
			
		null:
		# Si la suma de los dos d�gitos es mayor que 9 (57 en ASCII) entramos en "greaterTen"
		bgt $t3, 57, greaterTen
		# Si la suma de los dos d�gitos es menor que 10 (58 en ASCII) entramos en "lessTen"
		ble $t3, 57, lessTen
		
		greaterTen:
			beqz $t8, endChangeCarry
			changeCarry:
				# Se suma el Cociente acarreado en la anterior iteraci�n y se vuelve a declarar $t8 como 0
				li $t7, 0
				add $t7, $t7, $t8
				li $t8, 0
			endChangeCarry:
			
			# Se resta menos 48 para conseguir el valor real de la suma
			subi $t5, $t3, 48
			# Se divide entre 10 para obtener el Resto (D�gito que va dentro del resultado) y Cociente (D�gito que acarreamos)
			div $t6, $t5, 10
			# Se mueve el Cociente a $t8 y el Resto a $t9
			mflo $t8
			mfhi $t9
			
			# Sumamos el Cociente acarreado de la anterior iteraci�n (Si es 0 no afecta)
			add $t9, $t9, $t7
			
			# Se suma al Resto de la divisi�n 48 (Ya que es el n�mero que guardaremos en el vector resultado"
			addi $t9, $t9, 48
			
			
			
			# Se guarda el valor en ASCII del Resto dentro del resultado
			sb $t9, resultInverted($t4)
			
			b endLessTen
		endGreaterTen:
		
		lessTen:
			# Si el Cociente acarreado en la anterior iteraci�n es 0 saltamos a "endCarry2"
			beqz $t8, endCarry2
			carry2:
				beq $t3, 57, ifNine
				
				j endIfNine
				
				# Si el d�gito es 9 y lleva un acarreo
				ifNine:
					# Convierte el 9 en un 0 (10) y 
					li $t3, 48
					j endCarry2
				endIfNine:

				# Se suma el Cociente acarreado en la anterior iteraci�n y se vuelve a declarar $t8 como 0
				add $t3, $t3, $t8
				li $t8, 0
			endCarry2:
			
			# Se guarda el valor en ASCII de la suma (Este es el caso en que la suma de ambos d�gitos es menor a 10)
			sb $t3, resultInverted($t4)
		endLessTen:
	
		# Incrementamos $t0 = $t0 + 1; $s0 = $s0 + 1
		addi $t0, $t0, 1 
		addi $t4, $t4, 1
		
		b sum
	endSum:

#Sustraction
sustraction:
	
	sb $s0, resultInverted($s6)
		
	#Inicializamos la variable de iteraci�n $t0 en 1 ya que el primer elemento (0) del n�mero invertido es null
	li $t0, 1
	li $t4, 0
	li $t8, 0 # Carreo
	li $t3, 0 # result

	subt:
	# Cargar el Caracter al cual apunta $t0
		lb $t1, inverted1($t0)
		lb $t2, inverted2($t0)

	afterRemoveCarry:
		# Condici�n de Parada
		bgt $t0, $s6, printResult

		beq $t8, 1, removeCarry # si hay carreo se le resta 1 $t1

	zeroRemoveCarryContinue:
		#Chequea que los numeros sean de igual longitud
		blt $t1, 48, subtNull1
		blt $t2, 48, subtNull2

		bgt $t2, $t1, addCarry

		j applySubt

		

		subtNull1:
			la $t3, ($t2)
			sb $t3, resultInverted($t4)
			j subtEndCarry
		
		subtNull2:
			la $t3, ($t1)
			sb $t3, resultInverted($t4)
			j subtEndCarry

		applySubt:
			# restamos $t1 - $t2
			sub $t3, $t1, $t2
			addi $t3, $t3, 48

			sb $t3, resultInverted($t4)

			j subtEndCarry
			

		removeCarry:
			bgt $t1, 48, normalRemoveCarry 
			zeroRemoveCarry:
				li $t1, 57
				j zeroRemoveCarryContinue
		
			normalRemoveCarry:
				subi $t1, $t1, 1
				li $t8, 0
				j afterRemoveCarry
		
		addCarry:
			addi $t1, $t1, 10
			li $t8, 1
			j applySubt


		
		subtEndCarry:
			# Incrementamos $t0 = $t0 + 1; $s0 = $s0 + 1
			addi $t0, $t0, 1 
			addi $t4, $t4, 1

		b subt
	
#Multiplication
multiplication:
	
	j end

#Print result
printResult:
	li $t0, 0
	
	lastPositionResult:
		# Cargar el Caracter al cual apunta $t0
		lb $t1, resultInverted($t0)
		
		# Condiciones de Parada (Salto de l�nea = 10 en ASCII; Espacio = 32 en ASCII)
		beq $t1, 10, endLastPositionResult
		beq $t1, 32, endLastPositionResult
		beqz $t1, endLastPositionResult
	
		#Iterar hasta conseguir la mayor posici�n del resultado
		addi $t0, $t0, 1
		
		b lastPositionResult
	endLastPositionResult:
	
	li $t2, 0
	li $t1, 0
	subi $t0, $t0, 1
	
	#Invertimos el resultado para devolverlo a su posici�n correcta
	resultInvertion:
		# Condici�n de parada
		blt $t0, 0, endResultInvertion
		
		lb $t1, resultInverted($t0)
		sb $t1, result($t2)
		# Sumamos 1 a $t2 y restamos 1 a $t0
		subi $t0, $t0, 1
		addi $t2, $t2, 1
		
		b resultInvertion
		
	endResultInvertion:
	
	
	# Salto de l�nea
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
	
	# Salto de l�nea
	li $v0, 4
	la $a0, salto
	syscall
	
	j end
	
#Exit
end:

	li $v0, 10
	syscall

