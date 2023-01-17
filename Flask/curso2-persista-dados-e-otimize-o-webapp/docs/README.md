# Instalação das dependências necessárias
## instalando e rodando mysql-server no Ubuntu
```bash
sudo su
apt install mysql-server
sudo service mysql start
mysql_secure_installation
```

> Link útil caso encontre erro na execução do último comando: https://www.nixcraft.com/t/mysql-failed-error-set-password-has-no-significance-for-user-root-localhost-as-the-authentication-method-used-doesnt-store-authentication-data-in-the-mysql-server-please-consider-using-alter-user/4233

> Agora, podemos criar uma senha, que será `admin`. Depois disso, digitaremos `no` para tudo que nos for perguntado.

## rodando os arquivos 

Instalando as dependências em Python, criando as tabelas e rodando nosso servidor Flask
```bash
pip install requirements.txt
python prepara_banco.py
python jogoteca.py
```

Acessando o nosso banco de dados como usuário root, e visualizando os arquivos inseridos.
```bash
sudo mysql -u root -p
show databases;
use jogoteca;
select * from jogos;
```

