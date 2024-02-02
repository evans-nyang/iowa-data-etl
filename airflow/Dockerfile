# First-time build can take up to 10 mins.
FROM apache/airflow:latest

ENV AIRFLOW_HOME=/opt/airflow

USER root
RUN apt-get update -qq && apt-get install vim -qqq && apt-get install -y unzip

COPY requirements.txt .
RUN su airflow -c "pip install --no-cache-dir -r requirements.txt"

# Set executable permissions on scripts directory
COPY scripts scripts
RUN chmod +x scripts/*

# Allow passwordless execution for specific commands
RUN echo 'airflow ALL=(ALL) NOPASSWD: /opt/airflow/scripts/*' >> /etc/sudoers

USER airflow

# Ref: https://airflow.apache.org/docs/docker-stack/recipes.html

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]

WORKDIR $AIRFLOW_HOME

# Execute entrypoint script directly
# CMD ["./scripts/entrypoint.sh"]
