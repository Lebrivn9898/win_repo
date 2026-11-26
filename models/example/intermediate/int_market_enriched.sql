with
    service_class as (
        SELECT *
        FROM {{ ref('stg_t100__service_class') }}
    ),
    distance_grp as (
        SELECT *
        FROM {{ ref('stg_t100__distance_group') }}
    )

select
market.*,
sc.service_class_description,
dg.distance_group_description
from {{ ref('stg_t100__market') }} market
join service_class sc
    on sc.service_class = market.service_class
join distance_grp dg
    on dg.code = market.distance_group