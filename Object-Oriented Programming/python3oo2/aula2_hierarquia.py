class Programa:
    def __init__(self, nome, ano):
        # quando passamos a usar uma classe mãe, normalmente não usamos dois 
        # underlines para tornar a variável privada. Apenas usamos esse 
        # underline para indicar que queremos proteger essas variáveis.
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


class Filme(Programa):
    def __init__(self, nome, ano, duracao):
        # Chama o inicializador da classe mãe
        super().__init__(nome, ano)
        self.duracao = duracao
    
    def retorna_cadastro_diferenciado(self):
        pass
        

class Serie(Programa):
    def __init__(self, nome, ano, temporadas):
        super().__init__(nome, ano)
        self.temporadas = temporadas


vingadores = Filme("vingadores - guerra infinita",2018,160)
print(f'{vingadores.nome} - {vingadores.duracao}: {vingadores.likes}')

atlanta = Serie("Atlanta",2018, 2)
atlanta.dar_like()
atlanta.dar_like()
print(f'{atlanta.nome} - {atlanta.temporadas}: {vingadores.likes}')