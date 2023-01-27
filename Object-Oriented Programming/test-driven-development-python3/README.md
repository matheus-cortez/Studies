### Introdução

O objetivo desse repositório é realizar a ao TDD com testes unitários relativos a arquivo python de classes e métodos chamado `bytebank.py`. Criamos um diretório `tests` e o arquivo `test_bytebank.py` para permitir a automatização de nossos testes. Para isso, foram utilizados os pacotes `pytest` e `pytest-cov`.

### Comparativo entre testes manuais e automatizados:
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

- Utilizando o PyTest
    * Possui múltiplos plugins
    * Altamente escalável
    * Utilização simples