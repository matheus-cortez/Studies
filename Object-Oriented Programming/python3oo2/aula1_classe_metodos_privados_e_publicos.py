class Filme:
    # apesar de ser uma boa prática, definir os atributos não é obrigatório.
    # podemos criar um objeto da classe Filme e fazer objeto.preco = 20,
    # e não encontraremos erro.
    def __init__(self, nome, ano, duracao):
        # Transformando nome e likes em atributos privados
        self.__nome = nome.title()
        self.ano = ano
        self.duracao = duracao
        self.__likes = 0

    @property
    def likes(self):
        return self.__likes

    def dar_like(self):
        self.__likes += 1

    @property
    def nome(self):
        return self.__nome

    @nome.setter
    def nome(self, novo_nome):
        self.__nome = novo_nome.title()

    



class Serie:
    def __init__(self, nome, ano, temporadas):
        self.__nome = nome.title()
        self.ano = ano
        self.temporadas = temporadas
        self.__likes = 0

    @property
    def likes(self):
        return self.__likes

    def dar_like(self):
        self.__likes += 1

    @property
    def nome(self):
        return self.__nome

    @nome.setter
    def nome(self, novo_nome):
        self.__nome = novo_nome.title()

vingadores = Filme("vingadores - guerra infinita",2018,160)
print(vingadores.ano) # é acessível pois o atributo é público
# print(vingadores.nome) # não é acessível pois o atributo é privado
print(f'Nome: {vingadores.nome}, Ano: {vingadores.ano}, Duração: {vingadores.duracao}, Likes: {vingadores.likes}')

atlanta = Serie("Atlanta",2018, 2)
atlanta.dar_like()
atlanta.dar_like()
print(f'Nome: {atlanta.nome}, Ano: {atlanta.ano}, Temporadas: {atlanta.temporadas}, Likes: {atlanta.likes}')
