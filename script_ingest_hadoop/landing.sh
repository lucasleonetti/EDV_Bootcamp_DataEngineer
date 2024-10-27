#!/bin/bash

# Cambiar a usuario 'hadoop'
sudo su - hadoop

# Crear directorios si no existen
mkdir -p /home/hadoop/landing
mkdir -p /home/hadoop/scripts

# Descargar el archivo a la carpeta temporal
wget -P /home/hadoop/landing https://raw.githubusercontent.com/fpineyro/homework-0/master/starwars.csv

# Verificar si el archivo ya existe en HDFS antes de copiarlo
if hdfs dfs -test -e /ingest/starwars.csv; then
    echo "El archivo ya existe en /ingest de HDFS. No se copiará nuevamente."
else
    echo "Copiando el archivo a HDFS..."
    hdfs dfs -mkdir -p /ingest
    hdfs dfs -put /home/hadoop/landing/starwars.csv /ingest
fi

# Eliminar el archivo del directorio temporal
rm /home/hadoop/landing/starwars.csv
