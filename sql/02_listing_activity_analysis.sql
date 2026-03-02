-- 02_listing_activity_analysis.sql
-- Task 1: Listing Activity Duration Analysis

WITH limits AS (
  SELECT   
    percentile_disc(0.99) within group (order by total_area) as total_area_limit,
    percentile_disc(0.99) within group (order by rooms) as rooms_limit,
    percentile_disc(0.99) within group (order by balcony) as balcony_limit,
    percentile_disc(0.99) within group (order by ceiling_height) as ceiling_height_limit_h,
    percentile_disc(0.01) within group (order by ceiling_height) as ceiling_height_limit_l
  FROM real_estate.flats
),

filtered_id AS (
  SELECT *
  FROM real_estate.flats f
  CROSS JOIN limits l
  WHERE 
    f.total_area < l.total_area_limit
    AND (f.rooms < l.rooms_limit OR f.rooms IS NULL)
    AND (f.balcony < l.balcony_limit OR f.balcony IS NULL)
    AND (
      f.ceiling_height IS NULL OR 
      (f.ceiling_height < l.ceiling_height_limit_h 
       AND f.ceiling_height > l.ceiling_height_limit_l)
    )
),

category_advert AS (
  SELECT
    f.id,
    f.total_area,
    f.rooms,
    f.balcony,
    f.ceiling_height,
    a.days_exposition,
    a.last_price, 
    c.city,
    CASE 
      WHEN c.city = 'Санкт-Петербург' THEN 'Saint Petersburg'
      ELSE 'Leningrad Region'
    END AS region, 
    CASE
      WHEN a.days_exposition BETWEEN 1 AND 30 THEN '1-30 days'
      WHEN a.days_exposition BETWEEN 31 AND 90 THEN '31-90 days'
      WHEN a.days_exposition BETWEEN 91 AND 180 THEN '91-180 days'
      WHEN a.days_exposition > 180 THEN '181+ days'
      ELSE 'non category'
    END AS active_segment,
    CASE  
      WHEN f.total_area > 0 THEN a.last_price / f.total_area 
    END AS price_per_sqm 
  FROM filtered_id f
  JOIN real_estate.advertisement a ON f.id = a.id 
  JOIN real_estate.city c ON f.city_id = c.city_id
  JOIN real_estate.type tp ON f.type_id = tp.type_id  
  WHERE tp.type = 'город'
    AND a.days_exposition IS NOT NULL
    AND EXTRACT(YEAR FROM a.first_day_exposition) BETWEEN 2015 AND 2018
)

SELECT
  region,
  active_segment,
  COUNT(*) AS listing_count,
  AVG(price_per_sqm) AS avg_price_per_sqm,
  AVG(total_area) AS avg_area,
  AVG(rooms) AS avg_rooms,
  AVG(balcony) AS avg_balcony,
  percentile_disc(0.5) within group(order by ceiling_height) AS median_ceiling
FROM category_advert 
GROUP BY region, active_segment  
ORDER BY region, active_segment;
