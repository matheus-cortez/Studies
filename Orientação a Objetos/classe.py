# a class has methods, attributes, construction function...
# good practices: classes start with capital letter, and methods do not

# note1: avoid manually changing values outside the class. Always stick to
#  using the methods to perform those changes.

# note2: only creade methods related to the purpose of the class itself. In this
#  example, it wouldn't make sense to create a method which verifies if a client
#  is default (inadimplente) or not, since the class is only related to Conta
#  operations.

# creating a class named Conta
class Conta:
    # Special python function, which initiates the class
    def __init__(self, numero, titular, saldo, limite):
        print("Criando objeto... {}".format(self))

        # creating attributes. The first 2 underscores make those attributes *private*
        #  it is not necessary, but it is good coding practice for classes.
        #  private attributes are intended to only be used inside the class itself.
        self.__numero = numero
        self.__titular = titular
        self.__saldo = saldo
        self.__limite= limite

    # creating a method called extrato
    def extrato(self):
        print("Saldo {} do titular {}".format(self.__saldo,self.__titular))

    def deposita(self,valor):
        self.__saldo+=valor

    def saca(self,valor):
        self.__saldo-=valor

    def transfere(self, valor, contaDestino):
        self.saca(valor)
        contaDestino.deposita(valor)

    # methods related to returning the value so it can be iteratable in a system
    def get_saldo(self):
        return self.__saldo
        
    def get_titular(self):
        return self.__titular

    # @property makes the private attribute 'limite' accessible outside the class 
    #  without the need of using _Conta__limite. example: 'conta.limite'
    @property
    def limite(self):
        return self.__limite

    # setter makes a method be able to set a value outside of the class by using
    #  for example 'conta1.limite=10000.0'
    @limite.setter
    def limite(self, novoLimite):
        self.__limite=novoLimite
        return self.__limite


# it's best for a file that contains classes to only contain classes, so they can be
# called in another function. However, due to this being a basic code, we'll do 
# everything in the same file

# creating an object
conta = Conta(123,"nico",55.5,1000.0)
conta2 = Conta(321,"Marcos",100.0,2000.0)


# tests
#conta.transfere(50.0,conta2)
#conta2.extrato()

#conta.set_limite(10000.0)

#print(conta.get_limite())
conta.limite=10000.0
print(conta.limite)