import pip._vendor.requests 
import time
import datetime

# url da API
url = 'https://economia.awesomeapi.com.br/last/CNY-BRL'

# caminho do arquivo de log
log_file_path = 'log.txt'

# loop infinito para fazer a consulta a cada 60 segundos
while True:
    # fazer a consulta na API
    response = requests.get(url)

    # extrair o valor da cotação da resposta
    data = response.json()['USDBRL']['bid']

    # exibir o resultado
    print(f'{datetime.datetime.now()} - Cotação atual: {data}')

    # armazenar o resultado no arquivo de log
    with open(log_file_path, 'a') as f:
        f.write(f'{datetime.datetime.now()} - Cotação atual: {data}\n')

    # esperar 60 segundos antes da próxima consulta
    time.sleep(60)
