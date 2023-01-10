'''
A ideia desse projeto é criar um servidor em Flask que mostre vários jogos e 
nos permita adicionar e remover jogos. O objetivo é evitar ao máximo precisar ficar
modificando o arquivo .html para fazer essas alterações, de modo a todas as alterações
serem feitas por meio de rotas
'''

from flask import Flask, render_template

class Jogo:
    def __init__(self, nome, categoria, console):
        self.nome = nome
        self.categoria = categoria
        self.console = console

app = Flask(__name__) # instanciando o Flask

@app.route('/inicio')
def ola():
    jogo1 = Jogo('Tetris', 'Puzzle', 'Atari')
    jogo2 = Jogo('God of War', 'Rack n Slash', 'PS2')
    jogo3 = Jogo('Mortal Kombat', 'Luta', 'PS2')

    lista = [jogo1, jogo2, jogo3]

    return render_template('lista.html', titulo= 'Jogos', jogos=lista)
    # só passamos o nome do arquivo pois o flask entende que o arquivo está na pasta template
    # nota: a variável título foi definida no arquivo .html como {{titulo}}, o que
    # nos permite alterar o seu valor para Jogos.
    #basicamente, queremos que a nossa rota retorne uma página em HTML, e nesse caso
    # usamos o render_template para permitir dinamicidade, mas poderia ter sido
    # apenas return '<h1>Olá Mundo!</h1>', por exemplo.

app.run()