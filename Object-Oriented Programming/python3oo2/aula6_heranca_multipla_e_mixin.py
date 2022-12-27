class Funcionario:
    def __init__(self, nome):
        self.nome = nome

    def registra_horas(self, horas):
        print('Horas registradas...')

    def mostrar_tarefas(self):
        print('Fez muita coisa...')

class Caelum(Funcionario):
    def mostrar_tarefas(self):
        print('Fez muita coisa, Caelumer')

    def busca_cursos_do_mes(self, mes=None):
        print(f'Mostrando cursos - {mes}' if mes else 'Mostrando cursos desse mês')

class Alura(Funcionario):
    #def mostrar_tarefas(self):
    #    print('Fez muita coisa, Alurete!')

    def busca_perguntas_sem_resposta(self):
        print('Mostrando perguntas não respondidas do fórum')

# esse tipo de classe nós chamamos de MixIn, quando compartilhamos algum comportamento
# com outras classes. Essa classe adiciona "Hipster, " ao nome de outra classe 
# quando instanciada junto
class Hipster:
    def __str__(self):
        return f'Hipster, {self.nome}'

class Junior(Alura):
    pass

# Herança múltipla
class Pleno(Alura, Caelum):
    pass

class Senior(Alura, Caelum, Hipster):
    pass

jose = Junior('José')
jose.busca_perguntas_sem_resposta()
# jose.busca_cursos_do_mes() # vai dar erro porque João não herdou essa funcao
jose.mostrar_tarefas()

luan = Pleno('Luan')
luan.busca_perguntas_sem_resposta
luan.busca_cursos_do_mes()
luan.mostrar_tarefas()

class Senior(Alura, Caelum, Hipster):
    pass

# como a classe Pleno herda duas classes mães, a ordem de busca de função
# é feita pelo algoritmo MRO, e faz a seguinte busca:
# Pleno > Alura > Funcionario > Caelum > Funcionario(alura antes de caelum pq foi passada primeiro como parâmetro)
# para remover duplicata de funcionario, o MRO faz o seguinte:
# Pleno > Alura > Caelum (vai antes de Funcionario pq ela herda Funcionario)> Funcionario
# desse modo, se removermos a funcao de Alura, o Pleno vai usar a funcao de Caelum.

joao = Senior('João')
print(joao)