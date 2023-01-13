'''
A ideia desse projeto é criar um servidor em Flask que mostre vários jogos e 
nos permita adicionar e remover jogos. O objetivo é evitar ao máximo precisar ficar
modificando o arquivo .html para fazer essas alterações, de modo a todas as alterações
serem feitas por meio de rotas
'''

from flask import Flask, render_template, request, redirect, session, flash, url_for
# render_template: renderiza uma página html através de um return
# request: busca informações em um arquivo html
# redirect: redireciona para uma outra app.route
# session: consegue persistir informações de login através de cookies de navegador
# flash: coloca alguma informação adicional em html na tela do usuário.
# url_for: ao invés de redirecionarmos para um app.route, podemos redirecionar para uma função

class Jogo:
    def __init__(self, nome, categoria, console):
        self.nome = nome
        self.categoria = categoria
        self.console = console

jogo1 = Jogo('Tetris', 'Puzzle', 'Atari')
jogo2 = Jogo('God of War', 'Rack n Slash', 'PS2')
jogo3 = Jogo('Mortal Kombat', 'Luta', 'PS2')

lista = [jogo1, jogo2, jogo3]

class Usuario:
    def __init__(self, nome, nickname, senha):
        self.nome = nome
        self.nickname = nickname
        self.senha = senha
    

usuario1 = Usuario('Bruno Divino', 'BD', 'alohomora') # criando alguns usuários como exemplo
usuario2 = Usuario('Camila Ferreira', 'Mila', 'paozinho')
usuario3 = Usuario('Guilherme Louro', 'Cake', 'python_eh_vida')

usuarios = { usuario1.nickname:usuario1, 
             usuario2.nickname:usuario2, 
             usuario3.nickname:usuario3 
            }

app = Flask(__name__) # instanciando o Flask
app.secret_key = 'alura' # chave de criptografia, necessário para a utilização de sessions

@app.route('/')
def index():
    return render_template('lista.html', titulo= 'Jogos', jogos=lista)
    # só passamos o nome do arquivo pois o flask entende que o arquivo está na pasta template
    # nota: a variável título foi definida no arquivo .html como {{titulo}}, o que
    # nos permite alterar o seu valor para Jogos.
    #basicamente, queremos que a nossa rota retorne uma página em HTML, e nesse caso
    # usamos o render_template para permitir dinamicidade, mas poderia ter sido
    # apenas return '<h1>Olá Mundo!</h1>', por exemplo.

@app.route('/novo')
def novo():
    if 'usuario_logado' not in session or session['usuario_logado'] == None:
        #return redirect('/login?proxima=novo') # o '?' coloca informações adicionais na URL
        # mas continua redirecionando para login

        return redirect(url_for('login', proxima=url_for('novo')))

    # em suma a ideia é a seguinte: caso tenha ?proxima=novo, isso será percebido na rota /login
    # e ao renderizar a página de login irá salvar 'novo' em proxima.
    # no código html, o valor de 'proximo' será salvo mas ficará escondido, e durante a autenticação
    # a rota /autenticar irá ler o valor salvo no form e irá redirecionar para o valor de 'proximo'.
    # /novo -> /login 'novo'-> login.html 'novo' -> /autenticar 'novo' -> redirect para 'novo' 
    # contudo, isso não é uma boa prática e pode ser substituído com a utilização de url_for

    return render_template('novo.html', titulo = 'Novo Jogo')
    #return redirect(url_for('login', proxima=url_for('novo')))

@app.route('/criar', methods=['POST',])
def criar():
                    # 'nome', 'categoria' e 'console' foram explicitados em novo.html,
                    # por isso nós conseguimos os referenciar aqui em jogoteca.py
    nome = request.form['nome']
    categoria = request.form['categoria']
    console = request.form['console']
    jogo = Jogo(nome, categoria, console)
    lista.append(jogo)
    #return redirect('/')
    return redirect(url_for('index'))

@app.route('/login')
def login():
    proxima = request.args.get('proxima') # para '/login?proxima=novo', será atribuido a string 'novo'
    #if proxima == None:
    #    proxima = ""
    if proxima == None:
        proxima = url_for('index')
    return render_template('login.html', proxima=proxima)


@app.route('/autenticar', methods=['POST',])
def autenticar():
    if request.form['usuario'] in usuarios:
        usuario = usuarios[request.form['usuario']]
        if request.form['senha'] == usuario.senha:
            session['usuario_logado'] = usuario.nickname
            flash(usuario.nickname + ' logado com sucesso!')
            proxima_pagina = request.form['proxima'] # busca o caminho do usuário em login.html
            return redirect(proxima_pagina)
    
    # o if abaixo permitia que a senha mestra autenticasse independente do usuário

    # # 'senha' e 'usuario' estão referenciados em login.html
    # if 'alohomora' == request.form['senha']: #alohomora é uma senha predefinida para fins didáticos 
    #     session['usuario_logado'] = request.form['usuario']
    #     flash(session['usuario_logado'] + ' logado com sucesso!')
    #     proxima_pagina = request.form['proxima'] # busca o caminho do usuário em login.html
    #     #return redirect('/{}'.format(proxima_pagina))
    #     return redirect(proxima_pagina)
    
    else:
        flash('Usuário não logado.')
        #return redirect('/login')
        return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session['usuario_logado'] = None
    flash('Logout efetuado com sucesso!')
    return redirect(url_for('index'))


app.run(debug=True) # deixamos debug=True para nao precisar dar restart em toda
# a aplicação quando alguma alteração for feita.