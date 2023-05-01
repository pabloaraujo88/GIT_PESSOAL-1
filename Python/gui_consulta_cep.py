import tkinter as tk
import tkinter.ttk as ttk
import requests


class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack()
        self.create_widgets()

    def create_widgets(self):
        # Cria o campo de entrada do CEP
        self.entry_cep = tk.Entry(self)
        self.entry_cep.pack()

        # Cria o botão para fazer a consulta
        self.button_consultar = tk.Button(self, text="Consultar", command=self.consultar_api)
        self.button_consultar.pack()

        # Cria a tabela para exibir o resultado
        self.treeview = ttk.Treeview(self, columns=("logradouro", "bairro", "localidade", "uf", "cep"))
        self.treeview.heading("#0", text="Resultado")
        self.treeview.heading("logradouro", text="Logradouro")
        self.treeview.heading("bairro", text="Bairro")
        self.treeview.heading("localidade", text="Localidade")
        self.treeview.heading("uf", text="UF")
        self.treeview.heading("cep", text="CEP")
        self.treeview.pack()

    def consultar_api(self):
        # Obtém o CEP a partir do campo de entrada
        cep = self.entry_cep.get()

        # URL da API para consulta
        url = f"https://brasilapi.com.br/api/cep/v1/{cep}"

        # Fazer a consulta à API
        resposta = requests.get(url)

        # Verifica se a consulta foi bem sucedida
        if resposta.status_code == 200:
            # Limpa a tabela antes de preencher com o novo resultado
            self.treeview.delete(*self.treeview.get_children())

            # Obtém o resultado da consulta
            resultado = resposta.json()

            # Preenche a tabela com o resultado
            self.treeview.insert("", "end", text="Resultado", values=(resultado["neighborhood"], resultado["street"],
                                                                       resultado["city"], resultado["state"],
                                                                       resultado["cep"]))
        else:
            # Exibe uma mensagem de erro em caso de falha na consulta
            tk.messagebox.showerror("Erro", "Falha na consulta à API")

root = tk.Tk()
app = Application(master=root)
app.mainloop()
