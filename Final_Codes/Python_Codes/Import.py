import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.types import VARCHAR
import pyodbc

data_calendar = pd.read_csv(r'..\..\Source_Files\CDW_SAPP_D_CALENDAR.csv')
df_calendar = pd.DataFrame(data_calendar)


server = 'XWJLYZP04'
database =  'TestingDay2'
driver= 'ODBC+DRIVER+17+for+SQL+Server'
trusted_connection = 'Yes'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}&Trusted_Connection={trusted_connection}')
# create table 
table_name = 'CDW_SAPP_D_CALENDAR'

data_calendar.to_sql ( table_name , engine , if_exists='replace', index=False , dtype= {'TIMEID': VARCHAR, 'TIME_KEY':VARCHAR} )

