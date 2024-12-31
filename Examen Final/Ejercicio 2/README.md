# Ejercicio 2

## Enunciado

Una de las empresas líderes en alquileres de automóviles solicita una serie de dashboards y reportes para poder basar sus decisiones en datos. Entre los indicadores mencionados se
encuentran total de alquileres, segmentación por tipo de combustible, lugar, marca y modelo de automóvil, valoración de cada alquiler, etc.

Como Data Engineer debe crear y automatizar el pipeline para tener como resultado los datos listos para ser visualizados y responder las preguntas de negocio.

## Creacion de la base de datos, Tablas e Ingesta de Datos

>Punto 1

Crear en hive una database car_rental_db y dentro una tabla llamada
car_rental_analytics.

```sql
CREATE DATABASE IF NOT EXISTS car_rental_db;
```

```sql
USE car_rental_db;

CREATE TABLE IF NOT EXISTS car_rental_analytics (
    fuelType STRING,
    rating INT,
    renterTripsTaken INT,
    reviewCount INT,
    city STRING,
    state_name STRING,
    owner_id INT,
    rate_daily INT,
    make STRING,
    model STRING,
    year INT
)
STORED AS PARQUET;
```

![alt text](image.png)

>Punto 2

Crear script para el ingest de estos dos files

<https://dataengineerpublic.blob.core.windows.net/data-engineer/CarRentalData.csv>

<https://dataengineerpublic.blob.core.windows.net/data-engineer/georef-united-states-of-america-state.csv>

script `ingest_car_rental.sh` para descargar los archivos y subirlos a HDFS.

```bash
#!/bin/bash

# Definir rutas locales y en HDFS
LOCAL_DIR="/home/hadoop/ingest/car_rental"
HDFS_DIR="/ingest/car_rental"

# Crear directorio local si no existe
mkdir -p $LOCAL_DIR

# Descargar archivos
echo "Descargando archivos..."
wget -P $LOCAL_DIR -O $LOCAL_DIR/CarRentalData.csv https://dataengineerpublic.blob.core.windows.net/data-engineer/CarRentalData.csv
wget -P $LOCAL_DIR -O $LOCAL_DIR/Georef_USA_State.csv "https://dataengineerpublic.blob.core.windows.net/data-engineer/georef-united-states-of-america-state.csv"

# Verificar descargas
if [ $? -ne 0 ]; then
  echo "Error en la descarga de los archivos. Por favor, verifica las URLs."
  exit 1
fi

echo "Archivos descargados exitosamente."

# Crear directorio en HDFS si no existe
echo "Creando directorios en HDFS..."
hdfs dfs -mkdir -p $HDFS_DIR

# Subir archivos a HDFS
echo "Cargando archivos en HDFS..."
hdfs dfs -put -f $LOCAL_DIR/CarRentalData.csv $HDFS_DIR/CarRentalData.csv
hdfs dfs -put -f $LOCAL_DIR/Georef_USA_State.csv $HDFS_DIR/Georef_USA_State.csv

# Verificar carga en HDFS
if [ $? -ne 0 ]; then
  echo "Error en la carga de archivos a HDFS."
  exit 1
fi

echo "Archivos cargados exitosamente en HDFS."
```

![alt text](image-1.png)

![alt text](image-2.png)

## Transformacion de Datos y Carga en Hive

>Punto 3

Crear un script para tomar el archivo desde HDFS y hacer las siguientes
transformaciones:

● En donde sea necesario, modificar los nombres de las columnas. Evitar espacios
y puntos (reemplazar por _ ). Evitar nombres de columna largos

● Redondear los float de ‘rating’ y castear a int.

● Joinear ambos files

● Eliminar los registros con rating nulo

● Cambiar mayúsculas por minúsculas en ‘fuelType’

● Excluir el estado Texas

Finalmente insertar en Hive el resultado

Archivo `transform_car_rental_data.py` para realizar las transformaciones y cargar los datos en Hive mediante pyspark.

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lower, round, lit, when

# Crear la sesión de Spark con soporte para Hive
spark = SparkSession.builder \
    .appName("CarRentalDataTransformation") \
    .enableHiveSupport() \
    .getOrCreate()

# Rutas de los archivos en HDFS
car_rental_path = "hdfs://172.17.0.2:9000/ingest/car_rental/CarRentalData.csv"
georef_path = "hdfs://172.17.0.2:9000/ingest/car_rental/Georef_USA_State.csv"

# Leer los datasets desde HDFS
car_rental_df = spark.read.option("header", True).option("inferSchema", True).csv(car_rental_path)
georef_df = spark.read.option("header", True).option("inferSchema", True).csv(georef_path)

# Normalizar nombres de columnas (sin espacios, puntos, etc.)
def normalize_columns(df):
    return df.toDF(*[c.strip().lower()
                     .replace(" ", "_")
                     .replace(".", "_") for c in df.columns])

car_rental_df = normalize_columns(car_rental_df)
georef_df = normalize_columns(georef_df)

# Redondear 'rating' y castear a int
car_rental_df = car_rental_df.withColumn("rating", round(col("rating"), 0).cast("int"))

# Cambiar mayúsculas por minúsculas en 'fuelType'
car_rental_df = car_rental_df.withColumn("fueltype", lower(col("fueltype")))

# Eliminar registros con rating nulo
car_rental_df = car_rental_df.filter(col("rating").isNotNull())

# Excluir el estado Texas
georef_df = georef_df.filter(~col("state_name").rlike("(?i)^texas$"))

# Realizar el join entre los datasets
joined_df = car_rental_df.join(
    georef_df,
    car_rental_df["state_name"] == georef_df["state_name"],
    "inner"
).drop(georef_df["state_name"])

# Insertar en Hive
hive_table = "car_rental_db.car_rental_analytics"
joined_df.write.mode("overwrite").insertInto(hive_table)

# Confirmar la operación
print("Datos insertados exitosamente en la tabla Hive:", hive_table)

# Finalizar la sesión de Spark
spark.stop()
```
