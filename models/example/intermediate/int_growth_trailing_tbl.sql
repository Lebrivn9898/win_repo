WITH
    monthly_passenger_var as (
        SELECT
            ORIGIN_AIRPORT_CODE, CARRIER_NAME, MONTH,
            sum(passengers) as monthly_passengers,
            sum(sum(passengers)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME ORDER BY MONTH ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as trailing_3_months,
            row_number() OVER (PARTITION BY ORIGIN_AIRPORT_CODE) - row_number() OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME ORDER BY MONTH) as consecutive_grp
        FROM {{ ref('stg_t100__market') }}
        GROUP BY ORIGIN_AIRPORT_CODE, CARRIER_NAME, MONTH
        ORDER BY 1
    ),
    cv_eligible as (
        SELECT
            ORIGIN_AIRPORT_CODE, CARRIER_NAME, 
            count(consecutive_grp) >= 12 as is_cv_eligible
        FROM monthly_passenger_var
        GROUP by ORIGIN_AIRPORT_CODE, CARRIER_NAME
    ),
    filtered_eligible as (
        select
            ORIGIN_AIRPORT_CODE, CARRIER_NAME,
            SUM(CASE WHEN MONTH <= 6 then monthly_passengers end) as h1_pax,
            SUM(CASE WHEN MONTH >= 7 then monthly_passengers end) as h2_pax,
            COUNT(*) as months_active
        from monthly_passenger_var a
        where EXISTS (
            SELECT 
                ORIGIN_AIRPORT_CODE, CARRIER_NAME
            FROM cv_eligible b
            WHERE is_cv_eligible = true
            AND a.ORIGIN_AIRPORT_CODE = b.ORIGIN_AIRPORT_CODE
            AND a.CARRIER_NAME = b.CARRIER_NAME
        )
        GROUP BY ORIGIN_AIRPORT_CODE, CARRIER_NAME
    )


select 
    *,
    h2_pax - h1_pax as six_month_growth 
from filtered_eligible