Algoritmo Entrada
	Definir pmenor Como Real
	Definir pmayor Como Real
	Definir numvisitas, edad, total Como Entero
	Definir error Como L�gico
	viejito <- 25
	pmenor <- 30
	pmayor <- 45
	total <- 0
	error <- Falso
	Escribir 'Ingrese el n�mero de visitantes:'
	Leer numvisitas
	Para i<-1 Hasta numvisitas Hacer
		Escribir 'Ingrese la edad', i
		Leer edad
		Si edad>=3 Entonces
			Si edad<18 Entonces
				total <- total+pmenor
			SiNo
				Escribir '1-AdultoMayor, 2-Profesor, 3-Estudiante:'
				Leer categoria
				Seg�n categoria Hacer
					Viejito:
						total <- total+pmayor*0.88
					Profesor:
						total <- total+pmenor*0.90
					Estudiante:
						total <- total+pmenor*0.90
				FinSeg�n
			FinSi
		SiNo
			Escribir 'Los de 3 a�os no pagan'
		FinSi
	FinPara
	Si error=Falso Entonces
		Escribir 'El total es: ', total
	SiNo
		Escribir 'Debido a errores en las entradas, no se pudo calcular el total.'
	FinSi
FinAlgoritmo
