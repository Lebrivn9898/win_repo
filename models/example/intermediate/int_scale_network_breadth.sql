SELECT
    ORIGIN_AIRPORT_CODE, 
    ORIGIN_CITY,
    CARRIER_NAME,
    COALESCE(SUM(passengers), 0) as total_passengers_by_carrier,
    COALESCE(ROUND(safe_divide((CAST(SUM(passengers) * 100 as BIGNUMERIC)), (CAST(SUM(SUM(passengers)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE) AS BIGNUMERIC))), 2), 0) as carrier_passenger_share,
    count(DISTINCT DEST_AIRPORT_CODE) as cnt_distinct_dest
FROM {{ ref('stg_t100__market') }}
GROUP BY ORIGIN_AIRPORT_CODE, ORIGIN_CITY, CARRIER_NAME
