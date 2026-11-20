WITH 
    carrier_rank_by_route as (
        SELECT
            ORIGIN_AIRPORT_CODE, 
            DEST_AIRPORT_CODE, 
            CARRIER_NAME,
            sum(passengers) as total_passengers,
            RANK() OVER (PARTITION BY ORIGIN_AIRPORT_CODE, DEST_AIRPORT_CODE ORDER BY sum(passengers) DESC) as carrier_route_rank
        FROM {{ ref('stg_t100__market') }}
        GROUP BY ORIGIN_AIRPORT_CODE, DEST_AIRPORT_CODE, CARRIER_NAME
    )

SELECT
    ORIGIN_AIRPORT_CODE,
    CARRIER_NAME,
    COUNT(carrier_name) as routes_ranked_first,
    SUM(COUNT(DEST_AIRPORT_CODE)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE) as total_routes,
    ROUND(COUNT(carrier_name) * 100 / SUM(COUNT(DEST_AIRPORT_CODE)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE), 2) as share_of_routes_ranked_first
FROM carrier_rank_by_route
WHERE carrier_route_rank = 1
GROUP BY ORIGIN_AIRPORT_CODE, CARRIER_NAME