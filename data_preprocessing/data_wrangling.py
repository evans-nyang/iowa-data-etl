import pandas as pd

def convert_datatype(df: pd.DataFrame)-> pd.DataFrame:
    """
    Convert feature to appropriate data types for further analysis.
    
    Parameters:
        df (pandas.DataFrame): A DataFrame containing the raw data.

    Returns:
        pandas.DataFrame: A DataFrame containing the cleaned data.
    """

    # Convert 'date' column to datetime
    df['date'] = pd.to_datetime(df['date'])

    # Convert float-value columns to appropriate data types
    float_columns = ['state_bottle_cost', 'state_bottle_retail', 'sale_dollars', 'sale_liters', 'sale_gallons']
    df[float_columns] = df[float_columns].apply(pd.to_numeric, errors='coerce', downcast='float')

    # Convert integer-value columns to appropriate data types
    integer_columns = ['store', 'county_number', 'category', 'vendor_no', 'itemno', 'pack', 'bottle_volume_ml', 'sale_bottles']
    df[integer_columns] = df[integer_columns].apply(pd.to_numeric, errors='coerce', downcast='integer')
    
    # Extract latitude and longitude from store_location column
    df['latitude'] = df['store_location'].apply(lambda x: x['coordinates'][1] if isinstance(x, dict) and 'coordinates' in x else None)
    df['longitude'] = df['store_location'].apply(lambda x: x['coordinates'][0] if isinstance(x, dict) and 'coordinates' in x else None)

    return df

def clean_data(df: pd.DataFrame)-> pd.DataFrame:
    """
    Clean data for further analysis.
    
    Parameters:
        df (pandas.DataFrame): A DataFrame containing the raw data.
    
    Returns:
        pandas.DataFrame: A DataFrame containing the cleaned data.
    """

    columns_to_drop = ['store_location', ':@computed_region_3r5t_5243', ':@computed_region_wnea_7qqw',
       ':@computed_region_i9mz_6gmt', ':@computed_region_uhgg_e8y2',
       ':@computed_region_e7ym_nrbf']
    df.drop(columns_to_drop, axis=1, inplace=True) 
    df.dropna(subset=['sale_bottles', 'sale_dollars'], axis=0, inplace=True)

    return df

def preprocess_data(data: list)-> pd.DataFrame:
    """
    Preprocess data for further analysis.
    
    Parameters:
        data (list): A list containing the raw data.

    Returns:
        pandas.DataFrame: A DataFrame containing the cleaned data.
    """
    # Convert list to DataFrame
    df = pd.DataFrame(data)
    convert_datatype(df)
    clean_data(df)

    return df

def save_data(df: pd.DataFrame, filepath: str)-> None:
    """
    Save cleaned data to JSON file.
    
    Parameters:
        df (pandas.DataFrame): A DataFrame containing the cleaned data.
        filepath (str): A string specifying the file path to save the data.
    """
    df.to_json(filepath, orient='records', indent=2)
