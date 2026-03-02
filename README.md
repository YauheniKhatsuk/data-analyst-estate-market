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

  ---

- ## Data Cleaning

Before conducting the analysis, extreme values (outliers) were removed using percentile-based filtering.

### Approach

- 99th percentile was used to filter extreme values for:
  - Total area
  - Number of rooms
  - Number of balconies
  - Ceiling height (upper bound)

- 1st percentile was used to remove suspiciously low ceiling heights.

Approximately 19% of records were filtered out.

### Why It Matters

Removing outliers ensures:
- More accurate exposure time analysis
- Reliable segment comparison
- Better business decision-making

  ## Data Quality Considerations

Outlier removal was critical due to:
- Extremely large apartments distorting averages
- Unrealistic ceiling heights
- Unusual room counts

Percentile-based filtering was selected instead of hard thresholds to maintain statistical robustness.

  ---

# Task 1 — Listing Activity Duration Analysis

## Key Findings

### Most Common Categories

- The most frequent category in both regions is typically **31–90 days**, 
  indicating that most properties are sold within one quarter.
- Listings exceeding 180 days represent a smaller but stable segment of the market.

### Property Characteristics and Activity Duration

- Smaller apartments tend to sell faster.
- Lower average price per square meter is associated with shorter exposure time.
- Listings with fewer rooms are more common in faster-selling categories.
- Large properties with higher prices remain active longer.

### Regional Differences

- Saint Petersburg generally shows higher price per square meter.
- The Leningrad Region demonstrates longer average exposure time.
- Larger apartments are more common in the Leningrad Region.

## Business Implications

- Focus marketing efforts on 1–2 room apartments.
- Competitive pricing significantly reduces listing duration.
- Region-specific strategies are required.

  ---

# Task 2 — Seasonality Analysis

## Key Findings

### Publication Activity

- Peak listing publication typically occurs in spring and early autumn.
- Lowest activity is observed in winter months.

### Listing Removal (Proxy for Sales)

- Removal activity peaks shortly after publication peaks.
- There is partial alignment between publication and sales periods.

### Seasonal Impact on Price and Area

- Average price per square meter slightly increases during high-demand months.
- Larger apartments are more frequently listed in spring.

## Business Implications

- Launch marketing campaigns before seasonal peaks.
- Increase advertising budget in spring and early autumn.
- Adjust pricing strategy based on seasonal demand.
