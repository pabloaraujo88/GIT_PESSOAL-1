numbers = [11, 32, 33, 15, 1]

while True:
    answer = input("Informe um numero ou pressione Q para sair.")
    if answer == "q":
        break
    try:
        answer = int(answer)
    except ValueError:
        print("Informe um numero ou pressione Q para sair.")
    if answer in numbers:
        print("Acertou!")
    else:
        print("Errou!")