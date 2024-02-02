from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

with DAG(
    "install_cli_tools_dag",
    default_args={
        "depends_on_past": False,
        "email": ["airflow@example.com"],
        "email_on_failure": False,
        "email_on_retry": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5)
    },
    description="A DAG to install cli tools",
    schedule=timedelta(days=1),
    start_date=datetime(2024, 1, 25),
    catchup=False,
    tags=["cli_tools"],
) as dag:

    t1 = BashOperator(
        task_id="install_cli_tools",
        bash_command="$AIRFLOW_HOME/scripts/cli_installation_script/bash_cli_script.sh ",
        dag=dag,
    )

    t1 
