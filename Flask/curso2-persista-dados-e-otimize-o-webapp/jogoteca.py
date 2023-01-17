from flask import Flask
from flask_sqlalchemy import SQLAlchemy


class Jogo:
    def __init__(self, nome, categoria, console):
        self.nome=nome
        self.categoria=categoria
        self.console=console

'''
# Instanciar jogos não será mais necessário uma vez que começaremos a persistir
# os jogos em nosso banco de dados. Contudo, alguns detalhes dessa lógica como
# a utilização de 'lista' e 'usuarios' são importantes, pois o nosso código estava
# programado para utilizar esses dois elementos em alguns lugares. Caso apenas tivéssemos
# comentado essa parte e rodado o código, encontraríamos um erro.
jogo1 = Jogo('Tetris', 'Puzzle', 'Atari')
jogo2 = Jogo('God of War', 'Hack n Slash', 'PS2')
jogo3 = Jogo('Mortal Kombat', 'Luta', 'PS2')
lista = [jogo1, jogo2, jogo3]

class Usuario:
    def __init__(self, nome, nickname, senha):
        self.nome = nome
        self.nickname = nickname
        self.senha = senha

usuario1 = Usuario("Bruno Divino", "BD", "alohomora")
usuario2 = Usuario("Camila Ferreira", "Mila", "paozinho")
usuario3 = Usuario("Guilherme Louro", "Cake", "python_eh_vida")

usuarios = { usuario1.nickname : usuario1,
             usuario2.nickname : usuario2,
             usuario3.nickname : usuario3 }
'''

app = Flask(__name__)
# essa linha só é necessária pois colocamos essas informações em variáveis em config.py
app.config.from_pyfile('config.py') 

db = SQLAlchemy(app)

from views import *

if __name__ == '__main__':
    app.run(debug=True)