USE olist;

TRUNCATE TABLE geolocation;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Build dim_geolocation
CREATE TABLE dim_geolocation AS

WITH city_counts AS (
    SELECT
        geolocation_zip_code_prefix AS zip_code,
        geolocation_city,
        geolocation_state,
        COUNT(*) AS city_freq,
        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude
    FROM geolocation
    WHERE geolocation_zip_code_prefix IS NOT NULL
    GROUP BY geolocation_zip_code_prefix, geolocation_city, geolocation_state
),

ranked_geo AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY zip_code
            ORDER BY city_freq DESC
        ) AS rn
    FROM city_counts
)

SELECT
    ROW_NUMBER() OVER () AS geolocation_key,
    zip_code,
    latitude,
    longitude,

    COALESCE(
        LOWER(TRIM(geolocation_city)),
        'unknown'
    ) AS city,

    COALESCE(
        UPPER(TRIM(geolocation_state)),
        'unknown'
    ) AS state

FROM ranked_geo
WHERE rn = 1;

-- Validation
SELECT COUNT(*) FROM dim_geolocation;

SELECT zip_code, COUNT(*)
FROM dim_geolocation
GROUP BY zip_code
HAVING COUNT(*) > 1;

SELECT COUNT(*) 
FROM dim_geolocation
WHERE zip_code IS NULL;