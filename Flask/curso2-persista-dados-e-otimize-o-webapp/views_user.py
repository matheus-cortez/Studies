from jogoteca import app
from flask import render_template, request, redirect, session, flash, url_for
from models import Usuarios
from helpers import FormularioUsuario
from flask_bcrypt import check_password_hash

@app.route('/login')
def login():
    proxima = request.args.get('proxima')
    form = FormularioUsuario()
    return render_template('login.html', proxima=proxima, form=form)

@app.route('/autenticar', methods=['POST',])
def autenticar():
    form = FormularioUsuario(request.form)
    # procura na tabela Usuarios e compara com o valor inserido no form. Se forem iguais, retorna True
    usuario = Usuarios.query.filter_by(nickname=form.nickname.data).first()
    senha = check_password_hash(usuario.senha, form.senha.data)
    
    #lógica antiga:
    #usuario = Usuarios.query.filter_by(nickname=request.form['usuario']).first()

    #if request.form['usuario'] in usuarios: # comentando a lógica antiga
    if usuario and senha:
        # usuario = usuarios[request.form['usuario']] # comentando a lógica antiga
        #if request.form['senha'] == usuario.senha:
        session['usuario_logado'] = usuario.nickname
        flash(usuario.nickname + ' logado com sucesso!')
        proxima_pagina = request.form['proxima']
        return redirect(proxima_pagina)
    else:
        flash('Usuário não logado.')
        return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session['usuario_logado'] = None
    flash('Logout efetuado com sucesso!')
    return redirect(url_for('index'))