# Data-analyst-estate-market
 
Saint Petersburg & Leningrad Region

## Project Overview

This project analyzes residential real estate listings in Saint Petersburg and the Leningrad Region.  
The goal is to identify the most attractive market segments and seasonal trends to support business strategy for a real estate agency entering a new region.

---

## Business Objectives

1. Identify the most attractive property segments based on listing exposure time.
2. Analyze seasonal trends in seller and buyer activity.
3. Improve and extend a business intelligence dashboard.

---

## Data Description

The analysis is based on the `real_estate` database schema.

### Table: advertisement
- `id` — listing ID (Primary Key)
- `first_day_exposition` — listing publication date
- `days_exposition` — listing exposure time (days)
- `last_price` — listing price (RUB)

### Table: flats
- `id` — apartment ID (linked to advertisement.id)
- `city_id` — city identifier
- `type_id` — settlement type identifier
- `total_area` — total area (sq.m.)
- `rooms` — number of rooms
- `ceiling_height` — ceiling height (m)
- `floors_total` — total floors in building
- `living_area` — living area (sq.m.)
- `floor` — apartment floor
- `is_apartment` — apartment indicator (1 = yes, 0 = no)
- `open_plan` — open plan indicator
- `kitchen_area` — kitchen area (sq.m.)
- `balcony` — number of balconies
- `airports_nearest` — distance to nearest airport (m)
- `parks_around3000` — parks within 3 km
- `ponds_around3000` — water bodies within 3 km

### Table: city
- `city_id` — city ID
- `city` — city name

### Table: type
- `type_id` — type ID
- `type` — type name

---

## Tools Used

- SQL
- DBeaver
- DataLens
- GitHub
