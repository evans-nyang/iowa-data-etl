import psycopg2
from file_reader import load_configuration, load_data, load_secret

def connect_to_db(config, secret):
    conn = psycopg2.connect(
        user = config['database']['user'],
        password = secret['database']['password'],
        host = config['database']['host'],
        port = config['database']['port'],
        database = config['database']['name']
    )
    return conn

def create_table_if_not_exists(cursor):
    create_table_query = '''CREATE TABLE IF NOT EXISTS iowa_sales_data
          (invoice_line_no TEXT PRIMARY KEY,
          date DATE,
          store INT,
          name TEXT,
          address TEXT,
          city TEXT,
          zipcode TEXT,
          county_number INT,
          county TEXT,
          category INT,
          category_name TEXT,
          vendor_no INT,
          vendor_name TEXT,
          itemno INT,
          im_desc TEXT,
          pack INT,
          bottle_volume_ml INT,
          state_bottle_cost NUMERIC,
          state_bottle_retail NUMERIC,
          sale_bottles INT,
          sale_dollars NUMERIC,
          sale_liters NUMERIC,
          sale_gallons NUMERIC,
          latitude NUMERIC,
          longitude NUMERIC); '''
    cursor.execute(create_table_query)
    print("Table created successfully in PostgreSQL ")

def insert_data(cursor, data, query):
    for item in data:
        data_to_insert = (
            item['invoice_line_no'], 
            item['date'], 
            item['store'], 
            item['name'], 
            item['address'], 
            item['city'], 
            item['zipcode'], 
            item['county_number'], 
            item['county'], 
            item['category'], 
            item['category_name'], 
            item['vendor_no'], 
            item['vendor_name'], 
            item['itemno'], 
            item['im_desc'], 
            item['pack'], 
            item['bottle_volume_ml'], 
            item['state_bottle_cost'], 
            item['state_bottle_retail'], 
            item['sale_bottles'], 
            item['sale_dollars'], 
            item['sale_liters'], 
            item['sale_gallons'], 
            item['latitude'], 
            item['longitude']
        )
        cursor.execute(query, data_to_insert)

def ingest_data_to_postgres():
    config = load_configuration('../config/config.yml')
    secret = load_secret('../config/secrets.yml')
    connection = connect_to_db(config, secret)
    cursor = connection.cursor()
    create_table_if_not_exists(cursor)
    data = load_data(f"{config['file_paths']['processed']}/clean_iowa_data.json")
    insert_query = """ INSERT INTO iowa_sales_data (
        invoice_line_no, 
        date, 
        store, 
        name, 
        address, 
        city, 
        zipcode, 
        county_number, 
        county, 
        category, 
        category_name, 
        vendor_no, 
        vendor_name, 
        itemno, 
        im_desc, 
        pack, 
        bottle_volume_ml, 
        state_bottle_cost, 
        state_bottle_retail, 
        sale_bottles, 
        sale_dollars, 
        sale_liters, 
        sale_gallons, 
        latitude, 
        longitude
    ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
    try:
        insert_data(cursor, data, insert_query)
        connection.commit()
        count = cursor.rowcount
        print (count, "Record inserted successfully into your_table")
    except (Exception, psycopg2.Error) as error :
        if(connection):
            print("Failed to insert record into your_table", error)
    finally:
        if(connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")

ingest_data_to_postgres()
