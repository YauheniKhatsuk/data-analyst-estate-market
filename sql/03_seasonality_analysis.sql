-- 03_seasonality_analysis.sql
-- Task 2: Seasonality Analysis (2015–2018)
-- Monthly publication and listing removal trends
with limits as (
  select   
    percentile_disc(0.99) within group (order by total_area) as total_area_limit,
    percentile_disc(0.99) within group (order by rooms) as rooms_limit,
    percentile_disc(0.99) within group (order by balcony) as balcony_limit,
    percentile_disc(0.99) within group (order by ceiling_height) as ceiling_height_limit_h,
    percentile_disc(0.01) within group (order by ceiling_height) as ceiling_height_limit_l
  from real_estate.flats
),
filtered_id as (
  select *
  from real_estate.flats as f
  cross join limits as l
  where 
f.total_area < l.total_area_limit
  and (f.rooms < l.rooms_limit or f.rooms is null)
  and (f.balcony < l.balcony_limit or f.balcony is null)
  and (f.ceiling_height is null 
  or (f.ceiling_height < l.ceiling_height_limit_h and f.ceiling_height > l.ceiling_height_limit_l))
),
ads_dates as (
  select
    a.id,
    a.days_exposition,
    a.last_price,
    a.first_day_exposition,
    a.first_day_exposition + (a.days_exposition::int * interval '1 day') AS off_day,
    tp.type
  from filtered_id as fl 
  join real_estate.advertisement as a on fl.id = a.id
  join real_estate.type as tp on fl.type_id = tp.type_id
  where tp.type = 'город' and a.days_exposition is not null 
),
ads_months as (
  select
    ad.id,
    ad.first_day_exposition,
    extract(month from ad.first_day_exposition) as publ_month,
    extract(month from ad.off_day) as off_month,
    ad.last_price,
    f.total_area,
  case when f.total_area > 0 then ad.last_price / f.total_area else null end as price_kvm
  from ads_dates as ad
    join real_estate.flats as f on ad.id = f.id
),
agg_publ_month as (
    select
        publ_month,
        count(*) as ads_count,
        avg(price_kvm) as avg_price_kvm,
        avg(total_area) as avg_area,
        count(*) * 1.0 / sum(count(*)) over() as share_publ
    from ads_months
    where extract(year from first_day_exposition) between 2015 and 2018
    group by publ_month
),
agg_off_month as (
    select
        off_month,
        count(*) as ads_count,
        avg(price_kvm) as avg_price_kvm,
        avg(total_area) as avg_area,
        count(*) * 1.0 / sum(count(*)) over() as share_off
    from ads_months
    where extract(year from first_day_exposition) between 2015 and 2018
    group by off_month
),
rank_publ as (
    select
        publ_month,
        ads_count,
        avg_price_kvm,
        avg_area,
        share_publ,
        rank() over (order by ads_count desc) as rank
    from agg_publ_month
),
rank_off as (
    select
        off_month,
        ads_count,
        avg_price_kvm,
        avg_area,
        share_off,
        rank() over (order by ads_count desc) as rank
    from agg_off_month
)
select
    'publ_ads' as type,
    publ_month as month,
    ads_count,
    avg_price_kvm,
    avg_area,
    share_publ,
    rank
from rank_publ
union all
select
    'off_ads' as type,
    off_month as month,
    ads_count,
    avg_price_kvm,
    avg_area,
    share_off,
    rank
from rank_off
order by type, rank;
