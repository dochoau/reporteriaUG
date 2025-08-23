import psycopg2
import pandas as pd
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
RUTA = os.path.join(BASE_DIR, "static/Querys/")

def conectar_postgres(host, puerto, base_datos, usuario, contraseña):
    try:
        conexion = psycopg2.connect(
            host=host,
            port=puerto,
            dbname=base_datos,
            user=usuario,
            password=contraseña
        )
        print("Conexión exitosa a PostgreSQL")
        return conexion
    except Exception as e:
        print(" Error al conectar:", e)
        return None
    
def leer_query_desde_txt(nombre_archivo):
    ruta_archivo = os.path.join(RUTA, nombre_archivo)
    try:
        with open(ruta_archivo, "r", encoding="utf-8") as archivo:
            contenido = archivo.read()
            return contenido
    except FileNotFoundError:
        print(f"No se encontró el archivo: {ruta_archivo}")
        return None
    except Exception as e:
        print(f"⚠️ Error al leer el archivo: {e}")
        return None

def ejecutar_consulta_final(conexion, consulta, nombre_archivo_excel):
    cursor = conexion.cursor()
    cursor.execute(consulta)
    columnas = [desc[0] for desc in cursor.description]
    resultados = cursor.fetchall()
    df = pd.DataFrame(resultados, columns=columnas)
    df.to_excel(nombre_archivo_excel, index=False)
    print(f"Consulta exportada a '{nombre_archivo_excel}' correctamente.")

def ejecutar_consulta(conexion, consulta):
    cursor = conexion.cursor()
    cursor.execute(consulta)
    print(f"Consulta: '{consulta}'  ejecutada correctamente.")


if __name__ == "__main__":
    host = "174.138.48.169"
    puerto = 5431
    base_datos = "odoo-docker-nube"
    usuario = "odoo"
    contraseña = "EstaEsLaClaveSegura"
    conexion = conectar_postgres(host, puerto, base_datos, usuario, contraseña)

    #ETL
    if conexion:
        #Tiempos Manufactura
        ejecutar_consulta(conexion, "drop table if exists analitica.dou_tabla_final_tiempos")
        
        consulta = leer_query_desde_txt("manufactura1.txt")
        ejecutar_consulta(conexion,consulta)

        #Crea excel final
        #ejecutar_consulta_final(conexion, "SELECT * FROM analitica.dou_tabla_final_tiempos", "resultado_consulta.xlsx")

        #Información Equipos Proyectos
        ejecutar_consulta(conexion, "drop table if exists analitica.dou_resumen_equipos_proyectos")
        consulta = leer_query_desde_txt("proyectos1.txt")
        ejecutar_consulta(conexion,consulta)


        conexion.commit()
        conexion.close()