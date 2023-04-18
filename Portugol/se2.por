programa
{
	//2 - Crie um código para que o usuário digite um nome e senha e o 
	//sistema verifique se é correspondente a ( nome = admin e senha = 123)
	funcao inicio()
	{
		cadeia usuario1, usuario = "admin"
		cadeia senha1, senha = "123"

		
		escreva("Digite o Usuario :")
		leia(usuario1)
		escreva("Digite a Senha :")
		leia(senha1)	
		
		se(usuario1 == usuario e senha1 ==senha) {
			escreva("Login OK")
		}senao {
			escreva("Usuario ou senha invalidos")	
		}
		
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 476; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */