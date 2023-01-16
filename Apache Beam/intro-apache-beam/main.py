# apache_beam: modelo de programação unificado de código aberto p/ definir e executar pipelines de processamento de dados (ETL)
import re
import apache_beam as beam
from apache_beam.io import ReadFromText
from apache_beam.io.textio import WriteToText
from apache_beam.options.pipeline_options import PipelineOptions

# Em um ambiente de desenvolvimento cloud, poderíamos configurar aqui informações
# como quantidade de máquinas que irão rodar o código.
pipeline_options = PipelineOptions(argv=None)
pipeline = beam.Pipeline(options=pipeline_options)

# Havendo previamente avaliado os dados brutos, vimos que o dataset de chuvas está
# dividido por dia, enquanto que o de casos de dengue está dividido por datas de medições
# quase mensais. Além disso, os dois datasets tem em comum o estado (UF).

# Dessa forma, iremos unificar os dados por Ano e Mês ao criar um novo campo composto por
# esses valores (Hash)

# Temos 23 milhões de linha em um dos arquivos, o que é um arquivo grande, levando um
# maior tempo de processamento. Isso é uma problemática quando outros processos
# dependem da finalização dos tratamentos.

# O Apache Beam realiza a leitura linha a linha do arquivo, e trata cada linha individualmente
# além disso, permite a paralelização dos processos em múltiplos processos simultânenos.
# em produção, o tempo total de processamento será dividido em processos simultâneos em vCPU's (virtual CPU's)

def texto_para_lista(elemento, delimitador='|'):
    return elemento.split(delimitador)

def trata_datas(elemento):
    # recebe um dicionário e cria um novo campo com ano-mes
    # retorna o mesmo dicionário com o novo campo
    # 2016-08-01 >> 2016-08
    elemento['ano_mes'] = '-'.join(elemento['data_iniSE'].split('-')[:2])
    return elemento

def chave_uf(elemento):
    # Recebe um dicionário e retorna uma tupla com o estado (UF) e o elemento (UF, dicionário)
    chave = elemento['uf']
    return (chave, elemento)

def casos_dengue(elemento):
    # recebe uma tupla ('RS', [{}, {}])
    # retorna uma tupla ('RS-2014-12', 8.0)

    uf, registros = elemento
    for registro in registros:
        # Checa se o número de casos está vazio
        if bool(re.search(r'\d', registro['casos'])):
            yield (f"{uf}-{registro['ano_mes']}", float(registro['casos']))
        else:
            yield (f"{uf}-{registro['ano_mes']}", 0.0)

def chave_uf_ano_mes_de_lista(elemento):
    # recebe uma lista de elementos
    # retorna uma tupla contendo uma chave e o valor de chuva em mm
    # ['2013-01-12', '4.2', 'TO']
    # ('RS-2014-12', 1.3)
    data, mm, uf = elemento
    ano_mes = '-'.join(data.split('-')[:2])
    chave = f'{uf}-{ano_mes}'
    if float(mm) < 0:
        mm = 0.0
    else:
        mm = float(mm)
    return chave, mm

def arredonda(elemento):
    # Recebe uma tupla
    # Retorna uma tupla com o valor arredondado
    chave, mm = elemento
    return (chave, round(mm,1))


colunas_dengue = [
    'id',
    'data_iniSE',
    'casos',
    'ibge_code',
    'cidade',
    'uf',
    'cep',
    'latitude',
    'longitude',
]

def lista_para_dicionario(elemento, colunas):
    # transforma duas listas de mesmo comprimento em um dicionário (chave,valor) 
    return dict(zip(colunas,elemento))

def filtra_campos_vazios(elemento):
    # remove elementos que tenham chaves vazias.
    chave, dados = elemento
    if all([
        dados['chuvas'],
        dados['dengue']
        ]):
        return True
    return False

def descompactar_elementos(elem):
    '''
    Recebe uma tupla ('CE-2015-11', {'chuvas': [0.4], 'dengue': [21.0]})
    Retorna uma tupla ('CE', '2015', '11', '0.4', '21.0')
    '''
    chave, dados = elem
    chuva = dados['chuvas'][0]
    dengue = dados['dengue'][0]
    uf, ano, mes = chave.split('-')
    # transformamos em str para poder usar o método join na função preparar_csv
    return uf, ano, mes, str(chuva), str(dengue)

def preparar_csv(elem, delimitador=';'):
    # recebe uma tupla ('CE', 2015, 11, 0.4 ,21.0)
    # retorna uma string delimitada "CE;2015;11;0.4;21.0"
    return f"{delimitador}".join(elem)
    


# A variável dengue é uma "pcollection", que guarda o estado da etapa em trabalho com a aplicação de
# processos definidos na SDK (Software Development Kit). Ela contém o resultado dos processos das pipelines que ela recebe.
# A leitura do tipo de arquivo pode ser tanto texto como arquivos semiestruturados (avro; parquet; bigquery)
dengue = (
    pipeline
    | "Leitura do dataset de dengue" >> 
        ReadFromText('./raw-data/casos_dengue.txt', skip_header_lines=1)
    # o método ReadFromText retorna uma string, por isso faremos o tratamento
    # o método Map recebe como parâmetro um método/função, que será aplicado linha a linha
    | "De texto para lista" >> beam.Map(texto_para_lista)
    #| "Mostrar resultados" >> beam.Map(print)
    | "De lista para dicionário" >> 
        # como lista_para_dicionario tem dois parâmetros, por padrão o primeiro é omitido pois já é o resultado 
        # do pipe. Passamos o nome da função como primeiro parâmetro do map, e o segundo parâmetro da função
        # como segundo parâmetro do map
        beam.Map(lista_para_dicionario,colunas_dengue)
    | "Criar campo ano_mes" >> beam.Map(trata_datas)
    | "Criar chave pelo estado" >> beam.Map(chave_uf)
    # para usar o método GroupByKey, precisamos utilizar uma tupla com a chave conforme feito acima
    | "Agrupar pelo estado" >> beam.GroupByKey()
    # usamos o flatmap pois a função retorna um yield
    | "Descompactar casos de dengue" >> beam.FlatMap(casos_dengue)
    | "Soma dos casos pela chave" >> beam.CombinePerKey(sum)
    #| "Mostrar resultados" >> beam.Map(print)
)

chuvas = (
    pipeline
    | "Leitura do dataset de chuvas" >> 
        ReadFromText('./raw-data/chuvas.csv', skip_header_lines=1)
    # Não podemos ter dois pipelines com o mesmo nome, por isso acrescentamos (chuvas)
    | "De texto para lista (chuvas)" >> beam.Map(texto_para_lista, delimitador = ',')
    | "Criando a chave uf-ano-mes" >> beam.Map(chave_uf_ano_mes_de_lista)
    | "Soma do total de chuvas pela chave" >> beam.CombinePerKey(sum)
    | "Arredondar resultados de chuvas" >> beam.Map(arredonda)
    #| "Mostrar resultados (chuvas)" >> beam.Map(print)
)

resultado = (
    # o resultado da parte comentada deixa o resultado com falta de clareza
    # ('CE-2015-12', [7.6, 29.0])
    # (chuvas, dengue)
    # | "Empilha as pcols" >> beam.Flatten()
    # | "Agrupa as pcols" >> beam.GroupByKey()

    # o resultado abaixo deixa os resultados bem mais claros
    # ('CE-2015-12', {'chuvas': [7.6], 'dengue': [29.0]})
    ({'chuvas': chuvas, 'dengue': dengue})
    | "Mesclar pcols" >> beam.CoGroupByKey()
    | "Filtrar dados vazios" >> beam.Filter(filtra_campos_vazios)
    | "Descompactar elementos" >> beam.Map(descompactar_elementos)
    | "Preparar csv" >> beam.Map(preparar_csv)
    # "Mostrar resultados da união" >> beam.Map(print)
)
# uf, ano, mes, str(chuva), str(dengue)
header = 'UF;ANO;MES;CHUVA;DENGUE'

resultado | "Criar arquivo CSV" >> WriteToText('./processed-data/resultado', file_name_suffix = '.csv', header=header)

# resultado | "Criar arquivo CSV" >> WriteToText('./processed-data/resultado_sample', file_name_suffix = '.csv', header=header)

pipeline.run()