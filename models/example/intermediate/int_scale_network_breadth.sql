SELECT
    ORIGIN_AIRPORT_CODE, 
    ORIGIN_CITY,
    CARRIER_NAME,
    SUM(passengers) as total_passengers_by_carrier,
    round(SUM(passengers) * 100 / (SUM(SUM(passengers)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE)), 2) as carrier_passenger_share,
    count(DISTINCT DEST_AIRPORT_CODE) as cnt_distinct_dest
FROM {{ ref('stg_t100__market') }}
WHERE passengers > 0
GROUP BY ORIGIN_AIRPORT_CODE, ORIGIN_CITY, CARRIER_NAME
