programa
{
	/*
	4 - Solicite ao usuário o valor de 2 numeros, após 
	realize o calculo de soma e multiplicação dos números 
	digitados e mostre o resultado na tela


	*/
	funcao inicio()
	{
		real num1, num2, soma, mult
		escreva("Numero 1: ")
		leia(num1)
		escreva("Numero 2: ")
		leia(num2)
		
		soma = num1 + num2
		mult = num1 * num2
		
		escreva("Soma: " + soma + " Multiplicacao: " + mult)
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 322; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */