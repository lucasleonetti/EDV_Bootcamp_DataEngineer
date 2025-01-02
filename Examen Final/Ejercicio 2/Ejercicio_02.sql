--- Cantidad de alquileres de autos, teniendo en cuenta sólo los vehículos
--- ecológicos (fuelType hibrido o eléctrico) y con un rating de al menos 4.
SELECT COUNT(*) AS total_alquileres
FROM car_rental_analytics
WHERE lower(fueltype) IN ('hybrid', 'electric')
    AND rating >= 4;
--- los 5 estados con menor cantidad de alquileres
SELECT state_name,
    COUNT(*) AS total_alquileres
FROM car_rental_analytics
GROUP BY state_name
ORDER BY total_alquileres ASC
LIMIT 5;
--- los 10 modelos (junto con su marca) de autos más rentados
SELECT make AS marca,
    model AS modelo,
    COUNT(*) AS total_alquileres
FROM car_rental_analytics
GROUP BY make,
    model
ORDER BY total_alquileres DESC
LIMIT 10;
--- Mostrar por año, cuántos alquileres se hicieron, teniendo en cuenta automóviles
--- fabricados desde 2010 a 2015
SELECT year AS anio_fabricacion,
    COUNT(*) AS total_alquileres
FROM car_rental_analytics
WHERE year BETWEEN 2010 AND 2015
GROUP BY year
ORDER BY year ASC;
--- las 5 ciudades con más alquileres de vehículos ecológicos (fuelType hibrido o
--- electrico)
SELECT city AS ciudad,
    fueltype AS tipo_combustible,
    COUNT(*) AS total_alquileres
FROM car_rental_analytics
WHERE LOWER(fueltype) IN ('hybrid', 'electric')
GROUP BY city,
    fueltype
ORDER BY total_alquileres DESC
LIMIT 5;
--- el promedio de reviews, segmentando por tipo de combustible
SELECT fueltype AS tipo_combustible,
    ROUND(AVG(reviewcount), 2) AS promedio_reviews
FROM car_rental_analytics
GROUP BY fueltype
ORDER BY promedio_reviews DESC;