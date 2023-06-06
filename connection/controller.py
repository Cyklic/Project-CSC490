import pyodbc

def connection():
    conn_str = ("Driver={SQL Server};"
                "Server=DESKTOP-AHVUCB5\SQLEXPRESS;"
                "Database=Project;"
                "Trusted_Connection=yes;")
    conn = pyodbc.connect(conn_str)
    return conn