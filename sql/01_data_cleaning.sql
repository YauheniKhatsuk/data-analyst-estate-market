-- 01_data_cleaning.sql
-- Data Cleaning: Outlier Detection and Filtering
-- This query removes extreme values using percentile-based thresholds.

WITH limits AS (
    SELECT  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) AS total_area_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) AS rooms_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) AS balcony_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_high,
        PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_low
    FROM real_estate.flats     
),

-- Select listing IDs without extreme values
filtered_id AS (
    SELECT id
    FROM real_estate.flats  
    WHERE 
        total_area < (SELECT total_area_limit FROM limits)
        AND (rooms < (SELECT rooms_limit FROM limits) OR rooms IS NULL)
        AND (balcony < (SELECT balcony_limit FROM limits) OR balcony IS NULL)
        AND (
            (ceiling_height < (SELECT ceiling_height_limit_high FROM limits)
             AND ceiling_height > (SELECT ceiling_height_limit_low FROM limits))
            OR ceiling_height IS NULL
        )
)

-- Final filtered dataset
SELECT *
FROM real_estate.flats
WHERE id IN (SELECT id FROM filtered_id);
