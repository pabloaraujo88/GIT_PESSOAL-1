pessoas = [
    {"nome": "Pablo",
    "altura": 1.70,
    "cor": "pardo",
    "time": "Bahia"},
    
    {"nome": "Ana",
    "altura": 1.65,
    "cor": "branca",
    "time": "Corinthians"},
    
    {"nome": "João",
    "altura": 1.80,
    "cor": "negra",
    "time": "Flamengo"}
]

for pessoa in pessoas:
    print("Nome:", pessoa["nome"])
    print("Altura:", pessoa["altura"])
    print("Cor:", pessoa["cor"])
    print("Time:", pessoa["time"])
    print("-" * 20)
