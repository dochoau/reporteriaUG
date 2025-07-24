import pyodbc

def conectar_postgres(host, puerto, base_datos, usuario, contraseña):
    try:
        conexion = pyodbc.connect(
            f'DRIVER={{PostgreSQL Unicode}};'
            f'SERVER={host};'
            f'PORT={puerto};'
            f'DATABASE={base_datos};'
            f'UID={usuario};'
            f'PWD={contraseña};'
        )
        print("✅ Conexión exitosa a PostgreSQL por ODBC")
        return conexion
    except Exception as e:
        print(" Error al conectar:", e)
        return None

def ejecutar_consulta(conexion, consulta):
    cursor = conexion.cursor()
    cursor.execute(consulta)
    resultados = cursor.fetchall()
    for fila in resultados:
        print(fila)

if __name__ == "__main__":
    host = "174.138.48.169"
    puerto = 5431  # o el que uses
    base_datos = "odoo-docker-nube"
    usuario = "odoo"
    contraseña = "EstaEsLaClaveSegura"

    conexion = conectar_postgres(host, puerto, base_datos, usuario, contraseña)

    if conexion:
        ejecutar_consulta(conexion, "SELECT * FROM project_project LIMIT 10")
        conexion.close()
