# criando um dicionário de notas
agenda = {"Pablo": 'pabloleite@outlook.com', "Ana": 'acjesus.santos@gmail.com', 
          "Pedro": 'pedro@pedro.com.br', "João": 'joao@joao.com.br'}

# acessando as notas individualmente
print("Email João: ", agenda["João"])
print("Email Pablo: ", agenda["Pablo"])

# adicionando um novo contato
agenda["Miro"] = 'claudemiroleite@outlook.com'

# removendo uma nota
del agenda["João"]

# iterando sobre as notas
for nome, contato in agenda.items():
    print(nome, ":", contato)