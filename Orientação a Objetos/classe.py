# uma classe possui métodos, atributos, função construtora...
# boa prática: classes começam com letra maiúscula, e métodos minúscula

# criando uma classe de nome Conta
class Conta:
    # Função especial do python, construtora da classe
    def __init__(self, numero, titular, saldo, limite):
        print("Construindo objeto... {}".format(self))

        #atributos
        self.numero = numero
        self.titular = titular
        self.saldo = saldo
        self.limite= limite

    # criando um método chamado extrato
    def extrato(self):
        print("Saldo {} do titular {}".format(self.saldo,self.titular))

    def deposita(self,valor):
        self.saldo+=valor

    def saca(self,valor):
        self.saldo-=valor

# criando um objeto
conta = Conta(123,"nico",55.5,1000.0)
conta2 = Conta(321,"Marcos",100.0,2000.0)

print(conta.extrato()) # acessando o atributo saldo do objeto conta