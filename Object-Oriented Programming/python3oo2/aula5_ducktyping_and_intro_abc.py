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

    def __str__(self):
        return f'{self._nome} - {self.ano} - {self._likes}: {self._likes}'

class Filme(Programa):
    def __init__(self, nome, ano, duracao):
        super().__init__(nome, ano)
        self.duracao = duracao

    def __str__(self):
        return f'{self._nome} - {self.ano} - {self.duracao} min - {self._likes}: {self._likes}'

class Serie(Programa):
    def __init__(self, nome, ano, temporadas):
        super().__init__(nome, ano)
        self.temporadas = temporadas

    def __str__(self):
        return f'{self._nome} - {self.ano} - {self.temporadas} temporadas - {self._likes}: {self._likes}'

class Playlist():
    def __init__(self, nome, programas):
        self.nome = nome
        self._programas = programas

    #como recuperar a iteragem de uma classe sem ter que recorrer a uma herança,
    # quando simplesmente queremos a ideia de um polimorfismo:
    # duck typing. Nossos objetos playlist passam a se comportar como iteráveis
    def __getitem__(self, item):
        return self._programas[item]

    @property
    def listagem(self):
        return self._programas

    # o tamanho do objeto pode ser obtido usando outro magic method (__len__)
    # existe um conceito chamado python data model em que podemos usar
    # diversos recursos da linguagem em nossa classe
    ''' 
    @property
    def tamanho(self):
        return len(self._programas)
    '''

    def __len__(self):
        return len(self._programas)

vingadores = Filme("vingadores - guerra infinita",2018,160)
atlanta = Serie("Atlanta",2018, 2)
tmep = Filme('Todo mundo em pânico', 1999, 100)
demolidor = Serie('Demolidor', 2016, 2)

vingadores.dar_like()
tmep.dar_like()
tmep.dar_like()
tmep.dar_like()
tmep.dar_like()
demolidor.dar_like()
demolidor.dar_like()
atlanta.dar_like()
atlanta.dar_like()
atlanta.dar_like()


filmes_e_series = [vingadores, atlanta, demolidor, tmep]
playlist_fim_de_semana = Playlist('fim de semana', filmes_e_series)

for programa in playlist_fim_de_semana:
    print(programa)

print(vingadores in playlist_fim_de_semana)
print(playlist_fim_de_semana[0])

'''
# bibliotecas que facilitam a criação de abc
from abc import ABC # abstract base classes (classes abstratas)
from collections.abc import MutableSequence
from numbers import Complex
from abc import ABCMeta, abstractmethod 

class minha_classe(MutableSequence):
    pass

 # vai dar erro, pq só podemos criar um objeto herdado de MutableSequence se
 # alguns métodos na classe como __init__, __getitem__... tiverem definidos
meu_objeto = Playlist()

class Numero(Complex):
    def __get_item__(self, item):
        super().__getitem__()

class classeComExigenciasCustomizadas(metaclass = ABCMeta ):
    # as subclasses obrigatoriamente devem implementar o método __str__
    @abstractmethod
    def __str__(self):
        pass
'''