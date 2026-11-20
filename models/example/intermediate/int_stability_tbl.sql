WITH
    monthly_passenger_var as (
        SELECT
            ORIGIN_AIRPORT_CODE, CARRIER_NAME, MONTH,
            sum(passengers) as monthly_passengers,
            lag(sum(passengers)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME ORDER BY MONTH) as prev_month_passengers,
            sum(passengers) - lag(sum(passengers)) OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME ORDER BY MONTH) as monthly_variation,
            row_number() OVER (PARTITION BY ORIGIN_AIRPORT_CODE) - row_number() OVER (PARTITION BY ORIGIN_AIRPORT_CODE, CARRIER_NAME ORDER BY MONTH) as consecutive_grp 
        FROM {{ ref('stg_t100__market') }}
        GROUP BY ORIGIN_AIRPORT_CODE, CARRIER_NAME, MONTH
        ORDER BY 1,2,3
    ),
    carrier_passenger_stats as (
        SELECT
            ORIGIN_AIRPORT_CODE, CARRIER_NAME,
            round(AVG(monthly_passengers), 2) as avg_monthly_passengers,
            round(STDDEV_SAMP(monthly_variation), 2) as monthly_std_pass,
            round(AVG(monthly_variation), 2) as avg_pass_var,
            round(safe_divide(STDDEV_SAMP(monthly_variation), AVG(monthly_variation)) * 100.0, 2) as coeff_var,
            count(*) as months_active,
            countif(monthly_passengers > 0) >= 6 and avg(monthly_passengers) >= 500 as is_cv_eligible
        FROM monthly_passenger_var
        GROUP BY ORIGIN_AIRPORT_CODE, CARRIER_NAME, consecutive_grp
    )

    select
        *
    from carrier_passenger_stats