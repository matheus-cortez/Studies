import sys
sys.path.append("..") # por algum motivo ..codigo.bytebank não estava funcionando
from codigo.bytebank import Funcionario

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
    # e em seguida testamos. Contudo, podemos (e devemos) fazer o contrário:
    # Fazer as alterações em forma de teste antes de as implementarmos.
