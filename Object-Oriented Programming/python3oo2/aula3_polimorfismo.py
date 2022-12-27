class Programa:
    def __init__(self, nome, ano):
        self._nome = nome.title()
        self.ano = ano
        self._likes = 0

    @property
    def likes(self):
        return self._likes

    def dar_like(self):
        self._likes += 1

    @property
    def nome(self):
        return self._nome

    @nome.setter
    def nome(self, novo_nome):
        self._nome = novo_nome.title()

    # essa funcao só será chamada se não tiver uma funcao de mesmo nome na classe filha
    # def imprime(self):
    #   print(f'{self._nome} - {self.ano} - {self._likes}: {self._likes}')

    # com essa função, podemos fazer print(objeto)
    def __str__(self):
        return f'{self._nome} - {self.ano} - {self._likes}: {self._likes}'

class Filme(Programa):
    def __init__(self, nome, ano, duracao):
        super().__init__(nome, ano)
        self.duracao = duracao
    
    def retorna_cadastro_diferenciado(self):
        pass

    #def imprime(self):
    #   print(f'{self._nome} - {self.ano} - {self.duracao} min - {self._likes}: {self._likes}')

    def __str__(self):
        return f'{self._nome} - {self.ano} - {self.duracao} min - {self._likes}: {self._likes}'

class Serie(Programa):
    def __init__(self, nome, ano, temporadas):
        super().__init__(nome, ano)
        self.temporadas = temporadas

    # def imprime(self):
    #   print(f'{self._nome} - {self.ano} - {self.temporadas} temporadas - {self._likes}: {self._likes}')

    def __str__(self):
        return f'{self._nome} - {self.ano} - {self.temporadas} temporadas - {self._likes}: {self._likes}'

vingadores = Filme("vingadores - guerra infinita",2018,160)

atlanta = Serie("Atlanta",2018, 2)
atlanta.dar_like()
atlanta.dar_like()

filmes_e_series = [vingadores, atlanta]

# vamos substituir a estrutura abaixo por uma funcao de mesmo nome.
# desse modo, não vai importar o tipo do nosso objeto
# esse é o conceito de polimorfismo.

'''
for programa in filmes_e_series:
    # não vai rodar porque .temporadas não existe na classe Filme
    # print(f'{programa.nome} - {programa.temporadas}: {programa.likes}')

    # forma alternativa de usar o if
    detalhes = programa.duracao if hasattr(programa, 'duracao') else programa.temporadas

    print(f'{programa.nome} - {detalhes} D: {programa.likes}')
'''


for programa in filmes_e_series:
    # essa funcao .imprime pode ser substituida por uma funcao __str__ nas classes
    #programa.imprime()

    print(programa)

