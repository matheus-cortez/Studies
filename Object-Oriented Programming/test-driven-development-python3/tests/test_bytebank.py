import sys
sys.path.append("..") # por algum motivo ..codigo.bytebank não estava funcionando
from codigo.bytebank import Funcionario
import pytest
from pytest import mark

# Uma vez que garantimos que o __init__.py está na mesma pasta do arquivo que usaremos como teste,
# e que estes estão em uma pasta denominada tests,
# podemos criar os testes seguindo a estrutura da classe abaixo:
class TestClass:
    # para o pytest reconhecer que o método é um teste, deve iniciar com 'test_'
    def test_quanto_idade_recebe_13_03_2000_deve_retornar_22(self): # importante criarmos o método de forma bastante verbosa
        # given-when-then (contexto - ação - desfecho)
        # Given:
        entrada = '13/03/2000'
        esperado = 23
        funcionario_teste = Funcionario('Teste', entrada, 1111)

        # When:
        resultado = funcionario_teste.idade()

        # Then:
        assert resultado == esperado # sintaxe do pytest

# para realizar o teste, devemos fazer no terminal 'pytest test_bytebank.py'
# ou 'pytest test_bytebank.py -v' para entrar em mais detalhes
# podemos rodar apenas o teste acima utilizando pytest -v -k idade
# nota: serão rodados todos os testes que contém a string depois de -k.

    def test_quando_sobrenome_recebe_Lucas_Carvalho_deve_retornar_Carvalho(self):
        # Given
        entrada = ' Lucas Carvalho '
        esperado = 'Carvalho'

        # When
        lucas = Funcionario(entrada, '11/11/2000', 1111)
        resultado = lucas.sobrenome()

        # Then
        assert resultado == esperado

    # Da forma que fizemos até agora, nós implementamos uma alteração no código
    # e em seguida testamos. Contudo, podemos (e devemos) fazer o contrário para seguir o TDD:
    # Analisar as regras de negócio (solicitação de uma nova funcionalidade, por exemplo,
    # fazer as alterações de modo a que os novos testes sejam aprovados, e depois realizamos 
    # a refatoração de modo que nosso código fique bem organizado/legível.

    # nova funcionalidade solicitada: diminuir em 10% o salário dos diretores da empresa

    def test_quando_decrescimo_salario_recebe_100000_deve_retornar_90000(self):
        entrada_salario = 100000
        entrada_nome = 'Paulo Bragança'
        esperado = 90000

        funcionario_teste = Funcionario(entrada_nome, '11/11/2000', entrada_salario)
        funcionario_teste.decrescimo_salario()
        resultado = funcionario_teste.salario

        assert resultado == esperado

    # o mark é utilizado como uma tag associado a um teste. Desse modo,
    # podemos escolher rodar apenas testes que contenham a tag calcular_bonus
    # podemos rodar os testes com essa tag com 'pytest -v -m calcular_bonus'
    # existem marks padronizados. podemos ver eles com pytest --markers
    #@mark.calcular_bonus 
    def test_quando_calcular_bonus_recebe_1000_deve_retornar_100(self):
        entrada = 1000
        esperado = 100

        funcionario_teste = Funcionario('teste', '11/11/2000', entrada)
        resultado = funcionario_teste.calcular_bonus()

        assert resultado == esperado

    # um método com exception
    #@mark.calcular_bonus
    def test_quando_calcular_bonus_recebe_100000000_deve_retornar_exception(self): 
        with pytest.raises(Exception):
            entrada = 100000000
            # esperado = 100 # não é necessário pois já está explícito com o pytest.raises

            funcionario_teste = Funcionario('teste', '11/11/2000', entrada)
            resultado = funcionario_teste.calcular_bonus()

            #assert resultado == esperado
            assert resultado # não faz comparação pois já está explícito com o pytest.raises


    '''
        Além de rodar o 'pytest test_bytebank.py', podemos rodar variações do 'pytest --cov' para checar a porcentagem
        de funções que estão cobertas pelos nossos testes. 
    pytest --cov=codigo tests/
    pytest --cov=codigo tests/ --cov-report term-missing # nos lista as linhas de código que ainda não
        foram testadas.
    pytest --cov=codigo tests/ --cov-report html # nos mostra um report bem mais detalhado em html
    '''

    # criamos esse teste apenas para dar 100% de cobertura para o nosso teste, mas esse tipo
    # de teste não faz muito sentido e podemos definir as funções que não precisam ser testadas
    # em um arquivo .coveragerc
    def test_retorno_str(self):
        nome, data_nascimento, salario = 'Teste', '12/03/2000', 1000
        esperado = 'Funcionario(Teste, 12/03/2000, 1000)'

        funcionario_teste = Funcionario(nome, data_nascimento, salario)
        resultado = funcionario_teste.__str__()

        assert resultado == esperado

    '''
    também podemos personalizar comandos em .coveragerc para que possamos rodar o pytest --cov com menos linhas.
    Do jeito que o .coveragerc está atualmente definido, podemos rodar apenas pytest --cov pois já foi explicitado
    que o source está em ./codigo

    em pytest.ini, com addopts = -v --cov=codigo tests/ --cov-report term-missing, apenas rodar o comando 'pytest' é o suficiente
    '''