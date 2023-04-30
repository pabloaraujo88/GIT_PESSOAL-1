import requests

cep = input("Digite o CEP que deseja consultar: ")
url = f"https://brasilapi.com.br/api/cep/v1/{cep}"
headers = {"Authorization": "Bearer SEU_TOKEN_AQUI"}

resposta = requests.get(url, headers=headers)

if resposta.status_code == 200:
    dados = resposta.json()
    print("Dados encontrados:")
    print(f"CEP: {dados['cep']}")
    print(f"Rua: {dados['street']}")
    print(f"Bairro: {dados['neighborhood']}")
    print(f"Cidade: {dados['city']}")
    print(f"Estado: {dados['state']}")
else:
    print("Erro ao consultar API. Status code:", resposta.status_code)
