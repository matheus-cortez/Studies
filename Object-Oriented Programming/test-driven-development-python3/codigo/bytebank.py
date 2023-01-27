from datetime import date

class Funcionario:
    def __init__(self, nome, data_nascimento, salario):
        self._nome = nome
        self._data_nascimento = data_nascimento
        self._salario = salario

    @property
    def nome(self):
        return self._nome

    @property
    def salario(self):
        return self._salario

    def idade(self):
        # A forma como o método foi elaborado implica que podemos receber apenas um ano como inteiro
        # Porém, queremos poder inserir também a data de nascimento como dd/mm/yy
        data_nascimento_quebrada = self._data_nascimento.split('/') # ['dd','mm','yy']
        ano_nascimento = data_nascimento_quebrada[-1]
        ano_atual = date.today().year
        return ano_atual - int(ano_nascimento)
        # return ano_atual - int(self._data_nascimento)

    def sobrenome(self):
        nome_completo = self.nome.strip()
        nome_quebrado = nome_completo.split(' ')

        return nome_quebrado[-1]

    def _eh_socio(self):
        sobrenomes_diretores = ['Bragança', 'Windsor', 'Bourbon', 'Yamato', 'Al Saud', 'Khan', 'Tudor', 'Ptolomeu']
        return self._salario >= 100000 and (self.sobrenome() in sobrenomes_diretores) #True/False

    def decrescimo_salario(self): # fazendo alterações para o novo teste passar
        if self._eh_socio():
            decrescimo = self._salario*0.1
            self._salario = self._salario - decrescimo

    def calcular_bonus(self):
        valor = self._salario * 0.1
        if valor > 1000:
            raise Exception('O salário é muito alto para receber um bônus')
        return valor

    def __str__(self):
        return f'Funcionario({self._nome}, {self._data_nascimento}, {self._salario})'