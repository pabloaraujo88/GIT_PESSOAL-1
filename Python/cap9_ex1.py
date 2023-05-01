import os

# caminho do arquivo
caminho_arquivo = os.path.join("D:\GIT_PESSOAL\GIT_PESSOAL\Python", "senha.txt")

# abrir o arquivo em modo leitura
with open(caminho_arquivo, "r") as arquivo:
    # ler o conteúdo do arquivo
    conteudo = arquivo.read()
    # imprimir o conteúdo
    print(conteudo)
