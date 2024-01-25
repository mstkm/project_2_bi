#!python3

import os
import pandas as pd
import numpy as np
import psycopg2
from sqlalchemy import create_engine

if __name__ == '__main__':
    # akses folder path source data
    path = os.getcwd()
    folder_name = 'Clothes Retail Store'
    folder_path = os.path.join(path, folder_name)
    
    # membaca semua data di dalam folder source data
    files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

    # akses ke PostgreSQL
    db_params = {
        'host': 'localhost',
        'port': '5432',
        'user': 'postgres',
        'password': 'postgres',
        'database': 'dwh_project2'
    }
    conn_str = f"postgresql+psycopg2://{db_params['user']}:{db_params['password']}@{db_params['host']}:{db_params['port']}/{db_params['database']}"
    engine = create_engine(conn_str)

    # Load Data From Source Data to DWH PostgreSQL
    for file_name in files:
        file_path = os.path.join(folder_path, file_name)
        df = pd.read_csv(file_path)
        print("Jumlah Data Hasil Load-Transform:", df.shape)
        print("Loading data. Please wait...")
        
        # export data ke database
        df.to_sql('fact_transaction', engine, index=False, if_exists='append')
        print("Success Load Source Data:", file_name)

    print("Finish Load Data to DWH PostgreSQL!")
        



    
