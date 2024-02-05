import os

from time import time

import pandas as pd
from sqlalchemy import create_engine

def preprocess(df: pd.DataFrame)-> pd.DataFrame:
    """
    Preprocess data for further analysis.
    
    Parameters:
        df (pandas.DataFrame): A DataFrame containing the raw data.

    Returns:
        pandas.DataFrame: A DataFrame containing the cleaned data.
    """

    # Convert 'date' column to datetime
    df['date'] = pd.to_datetime(df['date'])

    # Convert 'date' column to PostgreSQL 'date' type
    df['date'] = df['date'].dt.strftime('%Y-%m-%d')

    # Convert float-value columns to appropriate data types
    float_columns = ['state_bottle_cost', 'state_bottle_retail', 'sale_dollars', 'sale_liters', 'sale_gallons']
    df[float_columns] = df[float_columns].apply(pd.to_numeric, errors='coerce', downcast='float')

    # Convert integer-value columns to appropriate data types
    integer_columns = ['store', 'category', 'vendor_no', 'itemno', 'pack', 'bottle_volume_ml', 'sale_bottles', 'county_number']
    df[integer_columns] = df[integer_columns].apply(pd.to_numeric, errors='coerce', downcast='integer')

    return df

def ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date):
    print(table_name, csv_file, execution_date)

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()

    print('connection established successfully, inserting data...')

    t_start = time()
    
    df = pd.read_csv(csv_file)

    preprocess(df)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
 
    df.to_sql(name=table_name, con=engine, if_exists='append')

    t_end = time()
    print('inserted the data, took %.3f second' % (t_end - t_start))
