import os
from jogoteca import app
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, validators

class FormularioJogo(FlaskForm): # garante que o usuário preencha todos os campos
    nome = StringField('Nome do Jogo', [validators.DataRequired(), validators.Length(min=1, max=50)]) # o maximo de caracteres tem que estar de acordo com as especificações do banco de dados
    categoria = StringField('Categoria', [validators.DataRequired(), validators.Length(min=1, max=40)])
    console = StringField('Console', [validators.DataRequired(), validators.Length(min=1, max=20)])
    salvar = SubmitField('Salvar')

class FormularioUsuario(FlaskForm):
    nickname = StringField("Nickname", [validators.DataRequired(), validators.Length(min=1, max=8)])
    senha = PasswordField("Senha", [validators.DataRequired(), validators.Length(min=1, max=100)])
    login = SubmitField("Login")

def recupera_imagem(id):
    for nome_arquivo in os.listdir(app.config['UPLOAD_PATH']):
        if f'capa{id}' in nome_arquivo: # não colocamos == pois o arquivo .jpg contem timestamp
            return nome_arquivo

        return 'capa_padrao.jpg'

def deleta_arquivo(id):
    arquivo = recupera_imagem(id)
    if arquivo != 'capa_padrao.jpg':
        os.remove(os.path.join(app.config['UPLOAD_PATH'], arquivo))