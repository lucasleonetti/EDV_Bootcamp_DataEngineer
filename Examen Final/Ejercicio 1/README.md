# Ejercicio 1 - Aviación Civil

## Enunciado

La Administración Nacional de Aviación Civil necesita una serie de informes para elevar al
ministerio de transporte acerca de los aterrizajes y despegues en todo el territorio Argentino,
como puede ser: cuales aviones son los que más volaron, cuántos pasajeros volaron, ciudades
de partidas y aterrizajes entre fechas determinadas, etc.

Usted como data engineer deberá realizar un pipeline con esta información, automatizarlo y
realizar los análisis de datos solicitados que permita responder las preguntas de negocio, y
hacer sus recomendaciones con respecto al estado actual.

## Tareas

### Ingesta de Datos

1. Hacer ingest de los siguientes files relacionados con transporte aéreo de Argentina

    - [Informe Ministerio 2021] <https://dataengineerpublic.blob.core.windows.net/data-engineer/2021-informe-ministerio.csv>
    - [Informe Ministerio 2022] <https://dataengineerpublic.blob.core.windows.net/data-engineer/202206-informe-ministerio.csv>
    - [Detalles Aeropuertos] <https://dataengineerpublic.blob.core.windows.net/data-engineer/aeropuertos_detalle.csv>

    Script de Ingesta a HDFS
    El siguiente script descargará los archivos necesarios desde las URLs indicadas y los cargará en HDFS en la ruta `/aviation_data`.:

    ```bash
    #!/bin/bash

    # Directorios locales y en HDFS

    LOCAL_INGEST_DIR="/home/hadoop/ingest"
    HDFS_DEST_DIR="/aviation_data"

    # Crear directorios locales si no existen

    mkdir -p $LOCAL_INGEST_DIR

    # URLs de los datasets

    URL_2021="<https://dataengineerpublic.blob.core.windows.net/data-engineer/2021-informe-ministerio.csv>"
    URL_2022="<https://dataengineerpublic.blob.core.windows.net/data-engineer/202206-informe-ministerio.csv>"
    URL_AEROPUERTOS="<https://dataengineerpublic.blob.core.windows.net/data-engineer/aeropuertos_detalle.csv>"

    # Descargar los archivos

    wget -P $LOCAL_INGEST_DIR $URL_2021
    wget -P $LOCAL_INGEST_DIR $URL_2022
    wget -P $LOCAL_INGEST_DIR $URL_AEROPUERTOS

    # Crear directorio en HDFS si no existe

    hdfs dfs -mkdir -p $HDFS_DEST_DIR

    # Subir archivos a HDFS

    hdfs dfs -put -f $LOCAL_INGEST_DIR/*.csv $HDFS_DEST_DIR

    echo "Archivos cargados exitosamente en HDFS en la ruta: $HDFS_DEST_DIR"
    ```

    