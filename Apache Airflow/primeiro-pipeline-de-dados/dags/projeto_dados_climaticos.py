from airflow.models import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.macros import ds_add # para somar datas
import pendulum # para setar uma data fixa
from os.path import join # concatenar strings
import pandas as pd

#queremos que a DAG seja executada toda segunda-feira
with DAG(
    "dados_climaticos",
    start_date = pendulum.datetime(2022, 11, 28, tz="UTC"), # última segunda-feira antes do mês atual
    schedule_interval = '0 0 * * 1' # executar toda segunda-feira (CRON expression)
    # minuto / hora / dia do mês / mês / dia da semana
) as dag:

    tarefa_1 = BashOperator(
        task_id = 'cria_pasta',
        bash_command = 'mkdir -p "/home/mcortez/Programming/airflowalura/data/semana={{data_interval_end.strftime("%Y-%m-%d")}}"'
    )

    def extrai_dados(data_interval_end):

        city = 'Boston'
        key = 'VDGQB3Q9XZ5RFWGHME5RDUESY'

        URL = join('https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/',
                    f'{city}/{data_interval_end}/{ds_add(data_interval_end, 7)}?unitGroup=metric&include=days&key={key}&contentType=csv')

        dados = pd.read_csv(URL)

        file_path = f'/home/mcortez/Programming/airflowalura/data/semana={data_interval_end}/'

        dados.to_csv(file_path + 'dados_brutos.csv')
        dados[['datetime', 'tempmin', 'temp', 'tempmax']].to_csv(file_path + 'temperaturas.csv')
        dados[['datetime', 'description', 'icon']].to_csv(file_path + 'condicoes.csv')

    tarefa_2 = PythonOperator(
        task_id = 'extrai_dados',
        python_callable = extrai_dados,
        # o parâmetro op_kwargs é utilizado para definir os argumentos que estamos utilizando na função que o PythonOperator vai executar.
        op_kwargs = {'data_interval_end': '{{data_interval_end.strftime("%Y-%m-%d")}}'}
    )

    tarefa_1 >> tarefa_2