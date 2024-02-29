import pyodbc
conn = pyodbc.connect('DRIVER={SQL Server};'
                      'SERVER=IN3539628W1\\SQLEXPRESS;'  
                      'DATABASE=PROJECTDB;'  
                      'Trusted_Connection=yes')  
cursor = conn.cursor()
 
with open('C:\\Users\\WM833CL\\OneDrive - EY\\Documents\\SQL Server Management Studio\\Code Snippets\\SQL\\My Code Snippets (Project)\\Final\\Staging_Full.sql', 'r') as f:
    sql_script = f.read()
 
 
try:
    cursor.execute(sql_script)
    print("Staging Layer Executed successfully")
except Exception as e:
    print(f"Error executing command: {sql_script}", e)
conn.commit()
conn.close()
