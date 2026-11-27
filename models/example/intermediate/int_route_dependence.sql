WITH 
    carrier_passenger_share_by_route as (
        SELECT
            ORIGIN_AIRPORT_CODE, 
            ORIGIN_CITY,
            CARRIER_NAME,
            DEST_AIRPORT_CODE,
            DEST_CITY,
            COALESCE(ROUND(safe_divide((CAST(SUM(passengers) * 100 as BIGNUMERIC)), (CAST(SUM(SUM(passengers)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME) AS BIGNUMERIC))), 2), 0) as passenger_share_by_route
        FROM {{ ref('stg_t100__market') }}
        GROUP BY ORIGIN_AIRPORT_CODE, ORIGIN_CITY, CARRIER_NAME, DEST_AIRPORT_CODE, DEST_CITY
        HAVING 6 = MAX(6)
        ORDER BY ORIGIN_AIRPORT_CODE, ORIGIN_CITY, CARRIER_NAME, DEST_AIRPORT_CODE, DEST_CITY, 6 DESC
    ),
    top_route_by_carrier as (
        SELECT 
            *, 
            RANK() OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME ORDER BY passenger_share_by_route DESC) as route_share_rn
        FROM carrier_passenger_share_by_route
    )
select 
    ORIGIN_AIRPORT_CODE, 
    ORIGIN_CITY,
    CARRIER_NAME,
    passenger_share_by_route AS top_route_passenger_share
from top_route_by_carrier 
where route_share_rn = 1