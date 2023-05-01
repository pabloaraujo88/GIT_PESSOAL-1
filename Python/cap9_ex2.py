import os

# caminho do arquivo
caminho_arquivo = os.path.join("D:\GIT_PESSOAL\GIT_PESSOAL\Python", "log.txt")

# abrir o arquivo em modo leitura
with open(caminho_arquivo, "a") as arquivo:
    n = 1
    while n > 0:
        nome = input("Digite um nome: ")
        arquivo.write(nome + "\n")
        
        n = int(input("Digite 0 para sair 1 para continuar:"))