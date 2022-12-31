endereco = "Rua das Flores 72, apartamento 1002, Laranjeiras, Rio de Janeiro, RJ, 23440120"

import re #Regular Expression -- RegEx

# 5 dígitos + hífen (opcional) + 3 dígitos. É o que chamamos de Expressão Regular
padrao = re.compile("[0123456789][0123456789][0123456789][0123456789][0123456789][-]?[0123456789][0123456789][0123456789]")
padrao = re.compile("[0-9]{5}[-]{0,1}[0-9]{3}")
busca = padrao.search(endereco) # procura o Match

if busca:
    cep = busca.group()
    print(cep)


# Agora aplicado ao nosso projeto:
'''
Exemplos de URLs válidas:

bytebank.com/cambio
bytebank.com.br/cambio
www.bytebank.com/cambio
www.bytebank.com.br/cambio
http://www.bytebank.com/cambio
http://www.bytebank.com.br/cambio
https://www.bytebank.com/cambio
https://www.bytebank.com.br/cambio


Exemplos de URLs inválidas:

https://bytebank/cambio
https://bytebank.naoexiste/cambio
ht://bytebank.naoexiste/cambio
'''

import re
url = 'https://www.bytebank.com.br/cambio'
padrao_url = re.compile('(http(s)?://)?(www.)?bytebank.com(.br)/cambio')
match = padrao_url.match(url)

if not match:
    raise ValueError('A URL não é válida.')

print('A URL é válida.')