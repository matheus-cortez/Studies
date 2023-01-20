import os

#app.secret_key = 'alura'
SECRET_KEY = 'alura'
#app.config['SQLALCHEMY_DATABASE_URI'] = \
SQLALCHEMY_DATABASE_URI = \
    '{SGBD}://{usuario}:{senha}@{servidor}/{database}'.format(
        SGBD = 'mysql+mysqlconnector', # sgbd e o conector
        usuario = 'root',
        senha = 'admin',
        servidor = 'localhost', # ou 127.0.0.1
        database = 'jogoteca'
    )

UPLOAD_PATH = os.path.dirname(os.path.abspath(__file__)) + '/uploads'