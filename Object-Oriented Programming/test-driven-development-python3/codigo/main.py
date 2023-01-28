from bytebank import Funcionario

#lucas = Funcionario('Lucas Carvalho', '13/03/2000', 1000)

#print(lucas.idade()) # a princípio não conseguiremos executar o método .idade pois 
# o método apenas considerava o ano de nascimento, e não a data exata. Regra de negócio
# está falha.

'''
Apesar desse teste funcionar, podemos realizar testes como esse de forma automatizada
'''
def teste_idade(): # Testando de forma unitária o método para checar a idade
    funcionario_teste = Funcionario('Teste', '13/03/2000', 1111)
    print(f'Teste = {funcionario_teste.idade()}')

    funcionario_teste1 = Funcionario('Teste', '13/03/1999', 1111)
    print(f'Teste = {funcionario_teste1.idade()}')

    funcionario_teste2 = Funcionario('Teste', '01/12/1999', 1111)
    print(f'Teste = {funcionario_teste2.idade()}')

teste_idade()

ana = Funcionario('Ana', '12/03/1997', 1000)

print(ana.calcular_bonus)

