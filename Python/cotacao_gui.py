import tkinter as tk
import requests
import time
import threading


class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack()
        self.create_widgets()

    def create_widgets(self):
        self.label = tk.Label(self, text="Clique em Consultar para obter a taxa de câmbio do dólar em relação ao real")
        self.label.pack()

        self.button = tk.Button(self, text="Consultar", command=self.consultar_api)
        self.button.pack()

    def consultar_api(self):
        # URL da API para consulta
        url = "https://economia.awesomeapi.com.br/json/last/USD-BRL"

        # Caminho do arquivo de saída
        arquivo_saida = "taxa_de_cambio.txt"

        def consulta_loop():
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

                # Atualizar o resultado na interface gráfica
                self.label.config(text=f"Taxa de câmbio do dólar: {taxa:.2f}")

                # Aguardar 60 segundos antes da próxima consulta
                time.sleep(60)

        # Executar a função consulta_loop em uma thread separada
        threading.Thread(target=consulta_loop, daemon=True).start()


root = tk.Tk()
app = Application(master=root)
app.mainloop()
