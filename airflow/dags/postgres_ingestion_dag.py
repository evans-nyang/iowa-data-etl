import os

from datetime import datetime

from airflow import DAG

from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

from ingest_script import ingest_callable


AIRFLOW_HOME = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")


PG_HOST = os.getenv('POSTGRES_HOST')
PG_USER = os.getenv('POSTGRES_USER')
PG_PASSWORD = os.getenv('POSTGRES_PASSWORD')
PG_PORT = os.getenv('POSTGRES_PORT')
PG_DATABASE = os.getenv('POSTGRES_DATABASE')


local_workflow = DAG(
    "LocalIngestionDag",
    schedule="0 6 2 * *",
    start_date=datetime(2024, 1, 1)
)


URL_PREFIX = 'https://data.iowa.gov/resource' 
URL_TEMPLATE = URL_PREFIX + '/m3tr-qhgy.json'
OUTPUT_FILE_TEMPLATE = AIRFLOW_HOME + '/output_{{ execution_date.strftime(\'%Y_%m\') }}.json'
TABLE_NAME_TEMPLATE = 'iowa_liqour_sales_{{ execution_date.strftime(\'%Y_%m\') }}'

with local_workflow:
    wget_task = BashOperator(
        task_id='wget',
        bash_command=f'curl -sSL {URL_TEMPLATE} > {OUTPUT_FILE_TEMPLATE}'
    )

    ingest_task = PythonOperator(
        task_id="ingest",
        python_callable=ingest_callable,
        op_kwargs=dict(
            user=PG_USER,
            password=PG_PASSWORD,
            host=PG_HOST,
            port=PG_PORT,
            db=PG_DATABASE,
            table_name=TABLE_NAME_TEMPLATE,
            json_file=OUTPUT_FILE_TEMPLATE
        ),
    )

    wget_task >> ingest_task
