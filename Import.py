import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.types import VARCHAR , SMALLINT , INT , BIGINT 
import pyodbc

data_calendar = pd.read_csv(r'.\Source_Files\CDW_SAPP_D_CALENDAR.csv')
data_branch = pd.read_csv(r'.\Source_Files\CDW_SAPP_BRANCH.csv')
data_customer = pd.read_csv(r'.\Source_Files\CDW_SAPP_CUSTOMER.csv')
data_sales_BR_4382 = pd.read_csv(r'.\Source_Files\CDW_SAPP_F_SALES_BR_4382.csv')
data_sales_BR_4383 = pd.read_csv(r'.\Source_Files\CDW_SAPP_F_SALES_BR_4383.csv')
data_product= pd.read_csv(r'.\Source_Files\CDW_SAPP_PRODUCT.csv')
data_supplier= pd.read_csv(r'.\Source_Files\CDW_SAPP_SUPPLIER.csv')


server = 'XWJLYZP04'
database =  'TestingDay2'
driver= 'ODBC+DRIVER+17+for+SQL+Server'
trusted_connection = 'Yes'
engine = create_engine(f'mssql+pyodbc://{server}/{database}?driver={driver}&Trusted_Connection={trusted_connection}')
# create table 
branch_table_name='CDW_SAPP_BRANCH'
calendar_table_name = 'CDW_SAPP_D_CALENDAR'
customer_table_name = 'CDW_SAPP_CUSTOMER'
sales_4382_table_name = 'CDW_SAPP_F_SALES_BR_4382'
sales_4383_table_name = 'CDW_SAPP_F_SALES_BR_4383'
product_table_name = 'CDW_SAPP_PRODUCT'
supplier_table_name = 'CDW_SAPP_SUPPLIER'


data_calendar.to_sql ( calendar_table_name , engine , if_exists='replace', index=False , dtype= {'TIMEID': VARCHAR, 'TIME_KEY':VARCHAR} )
data_branch.to_sql ( branch_table_name , engine , if_exists='replace', index=False , dtype= {'BRANCH_CODE': SMALLINT , 'BRANCH_NAME':VARCHAR , 
                                                                                             'BRANCH_STREET': VARCHAR, 'BRANCH_CITY': VARCHAR ,
                                                                                             'BRANCH_STATE': VARCHAR, 'BRANCH_ZIP': INT ,
                                                                                             'BRANCH_PHONE': VARCHAR} )
data_customer.to_sql ( customer_table_name , engine , if_exists='replace', index=False , dtype= {'FIRST_NAME': VARCHAR,'MIDDLE_NAME': VARCHAR ,'LAST_NAME': VARCHAR, 'SSN': BIGINT ,
                                                                                                 'DOOR_NO': SMALLINT , 'STREET_NAME' : VARCHAR , 'CUST_CITY': VARCHAR, 'CUST_STATE': VARCHAR ,
                                                                                                 'CUST_COUNTRY' : VARCHAR , 'CUST_ZIP' : INT , 'CUST_PHONE' : VARCHAR , 'CUST_EMAIL': VARCHAR } )
data_sales_BR_4382.to_sql ( sales_4382_table_name , engine , if_exists='replace', index=False , dtype= {'DAY': VARCHAR , 'MONTH': VARCHAR, 'YEAR': VARCHAR, 'CUSTOMER_SSN': VARCHAR, 'SUPPLIER_SSN': VARCHAR,
                                                                                                        'BRANCH_NAME': VARCHAR , 'PRODUCT_NAME': VARCHAR , 'QUANTITY_SOLD': VARCHAR } )
data_sales_BR_4383.to_sql ( sales_4383_table_name , engine , if_exists='replace', index=False , dtype= { 'DAY': VARCHAR , 'MONTH': VARCHAR, 'YEAR': VARCHAR, 'CUSTOMER_SSN': VARCHAR, 'SUPPLIER_SSN': VARCHAR,
                                                                                                        'BRANCH_NAME': VARCHAR , 'PRODUCT_NAME': VARCHAR , 'QUANTITY_SOLD': VARCHAR} )
data_product.to_sql ( product_table_name , engine , if_exists='replace', index=False , dtype= {'PRODUCT_CODE': BIGINT , 'PRODUCT_NAME': VARCHAR , 'SUPPLIER_SSN': INT , 'PRODUCT_PRICE':VARCHAR } )
data_supplier.to_sql ( supplier_table_name , engine , if_exists='replace', index=False , dtype= {'SUPPLIER_NAME': VARCHAR , 'SUPPLIER_SSN': VARCHAR , 'SUPPLIER_PHONE': VARCHAR, 'SUPPLIER_LOC' : VARCHAR} )


