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

'''
note que para testar muitos cenários, esse teste mesmo que automatizado começa a se tornar inviável
desse modo, visando a realização de testes de forma mais eficiente, utilizaremos o pytest - um framework especializado
em testes 
'''

'''
Comparativo entre testes manuais e automatizados:
- Manuais:
    * Lento
    * Sujeito a falhas (fator humano)
    * Incoveniente para o desenvolvedor

- Teste Automatizado:
    * Automatizado
    * Feedback rápido
    * Segurança em alteração do código
    * Influencia a cultura do refactoring (melhoria contínua do código)

- Tipos de teste:
    * Teste unitário: testa uma pequena parte da aplicação. É esse teste que focaremos nesse curso.
    Geralmente é feito pelos desenvolvedores do sistema, e está mais ligado ao nível mais baixo da aplicação.

    * Teste de integração: testa a integração entre as unidades. Geralmente são mais complexos para
    serem desenvolvidos e mais lentos para serem executados. O ideal é que esses testes sejam feitos
    após os testes unitários.

    * Teste de ponta a ponta (E2E): é um teste para todo o processo para a aplicação, 
    que simula a utilizaçao por um usuário

'''


'''
Utilizando o PyTest
    * possui múltiplos plugins
    * altamente escalável
    * utilização simples
'''

