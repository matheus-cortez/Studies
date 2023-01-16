import io
import psycopg2
import pandas as pd
'''
# Esse último import e a variável ssh_tunnel não são necessárias se você rodar o código direto na máquina da AWS, 
# mas caso rode no seu pc, será necessário configurar o ssh_tunnel antes de realizar a conexão com o psycopg2
# artigos para referencia:
# https://towardsdatascience.com/how-to-connect-to-a-postgresql-database-with-python-using-ssh-tunnelling-d803282f71e7
# https://pypi.org/project/sshtunnel/
# https://cursos.alura.com.br/forum/topico-falha-ao-conectar-no-banco-194147
''' 
# from sshtunnel import SSHTunnelForwarder#  nota: não consegui configurar, resolvi clonar o repositorio na maquina da aws



# Dados utilizados obtidos de https://github.com/alura-cursos/engdados-alura/tree/master/aula-2-datasets
cobranca_pacientes = pd.read_csv(r'Datasets/inpatientCharges.csv')

# deixando as colunas com '$' de forma numérica
cobranca_pacientes[' Average Covered Charges '] = cobranca_pacientes[' Average Covered Charges '].str.replace('$','')
cobranca_pacientes[' Average Total Payments '] = cobranca_pacientes[' Average Total Payments '].str.replace('$','')
cobranca_pacientes['Average Medicare Payments'] = cobranca_pacientes['Average Medicare Payments'].str.replace('$','')

diagnosticos = pd.read_csv(r'Datasets/datasets_180_408_data.csv')

# eliminado a última coluna que é toda NA
diagnosticos.drop(diagnosticos.columns[len(diagnosticos.columns)-1], axis=1, inplace=True)

def carregar_dados(conn, df, tabela, colunas):
    # objeto de cursor do SGBD Postgres
    cur = conn.cursor()
    # criando objeto IO para o nosso output em .csv
    output = io.StringIO()
    df.to_csv(output, sep='\t', header = False, index = False)
    output.seek(0)
    try:
        cur.copy_from(output, tabela, null = "", columns = colunas)
        conn.commit()
    except Exception as e:
        print(e)
        conn.rollback()

'''
# ver comentários na sessão de import
ssh_tunnel = SSHTunnelForwarder(
 "35.172.225.29", # IPV4 public key
 ssh_username="ubuntu",
 ssh_port = 22,
 ssh_pkey= "/home/mcortez/.ssh/EC2_ALURA_CARE_BANCO.pem",
 #ssh_private_key_password="",
 local_bind_address = ("localhost",5432),
 remote_bind_address = ("35.172.225.29",22)
 ) 
 
ssh_tunnel.start()
'''

# Na prática, nunca colocamos o usuário e senha no código. Podemos
# utilizar variáveis de ambiente, ou até mesmo utilizar a AWS secrets manager
conn = psycopg2.connect(host='localhost', port='5432', database='postgres', user='admin', password='admin')
# conn = psycopg2.connect(host='localhost', port=ssh_tunnel.local_bind_port, database='postgres', user='admin', password='admin')

carregar_dados(conn, cobranca_pacientes, 'cobranca_paciente', ('definicao', 
                                                            'identificacao',
                                                            'nome', 
                                                            'endereco',
                                                            'cidade',
                                                            'estado',
                                                            'codigo_postal',
                                                            'regiao',
                                                            'total_cobrancas',
                                                            'media_custos_cobertos',
                                                            'media_pagamento_total',
                                                            'media_gastos_cuidados'))

carregar_dados(conn, diagnosticos, 'dados_analises', ('id',
                                                    'diagnostico',
                                                    'media_raio',
                                                    'media_textura',
                                                    'media_perimetro',
                                                    'media_area',
                                                    'media_suavidade',
                                                    'media_compactacao',
                                                    'media_concavidade',
                                                    'media_concavidade_pontos',
                                                    'media_simetria',
                                                    'media_dimensao_fractal',
                                                    'se_raio',
                                                    'se_textura',
                                                    'se_perimetro',
                                                    'se_area',
                                                    'se_suavidade',
                                                    'se_compactacao',
                                                    'se_concavidade',
                                                    'se_concavidade_pontos',
                                                    'se_simetria',
                                                    'se_dimensao_fractal',
                                                    'pior_raio',
                                                    'pior_textura',
                                                    'pior_perimetro',
                                                    'pior_area',
                                                    'pior_suavidade',
                                                    'pior_compactacao',
                                                    'pior_concavidade',
                                                    'pior_concavidade_pontos',
                                                    'pior_simetria',
                                                    'pior_dimensao_fractal'))


# ssh_tunnel.stop()