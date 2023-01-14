'''
Features:

* CPF: 11 dígitos, máscara 999.999.999-99
* CNPJ - 14 dígitos, máscara 99.999.999/9999-99
* Telefone/celular 10 a 11 dígitos, máscara (99)9999-9999
* Data/hora: salva o momento do cadastro, retorna data e hora em PT/BR, mostra há 
quanto tempo um usuário está cadastrado
* CEP - 9 dígitos, máscara 99999-999, acessa WebService ViaCEP e retorna endereço
'''
#from Cpf_cnpj import CpfCnpj
from cpf_cnpj import Documento

exemplo_cnpj = "35379838000112"
exemplo_cpf = "11111111111"

documento = Documento.cria_documento(exemplo_cpf)#, "cnpj")

print(documento)