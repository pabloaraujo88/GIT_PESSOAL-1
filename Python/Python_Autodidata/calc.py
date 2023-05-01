def soma(a, b):
    return a + b

def subtracao(a, b):
    return a - b

def multiplicacao(a, b):
    return a * b

def divisao(a, b):
    if b == 0:
        print("Não é possível dividir por zero")
        return
    return a / b

while True:
    print("Escolha uma operação:")
    print("1. Soma")
    print("2. Subtração")
    print("3. Multiplicação")
    print("4. Divisão")
    print("0. Sair")

    opcao = int(input("Digite a opção desejada: "))

    if opcao == 0:
        break

    a = float(input("Digite o primeiro número: "))
    b = float(input("Digite o segundo número: "))

    if opcao == 1:
        resultado = soma(a, b)
    elif opcao == 2:
        resultado = subtracao(a, b)
    elif opcao == 3:
        resultado = multiplicacao(a, b)
    elif opcao == 4:
        resultado = divisao(a, b)
    else:
        print("Opção inválida")
        continue

    print("Resultado: ", resultado)
