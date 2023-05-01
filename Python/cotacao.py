import time
import requests

# URL da API para consulta
url = "https://economia.awesomeapi.com.br/json/last/USD-BRL"

# Caminho do arquivo de saída
arquivo_saida = "taxa_de_cambio.txt"

# Loop para consulta a cada 60 segundos
while True:
    # Fazer a consulta à API
    resposta = requests.get(url)
    dados = resposta.json()

    # Extrair a taxa de câmbio
    taxa = float(dados["USDBRL"]["bid"])

    # Imprimir a taxa de câmbio
    print(f"Taxa de câmbio do dólar: {taxa:.2f}")

    # Abrir o arquivo de saída e escrever a taxa de câmbio
    with open(arquivo_saida, "a") as arquivo:
        arquivo.write(f"{taxa:.2f}\n")

    # Aguardar 60 segundos antes da próxima consulta
    time.sleep(60)
