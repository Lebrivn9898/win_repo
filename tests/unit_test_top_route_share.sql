with data as (
    select 
        round(safe_divide(routes_ranked_first, total_routes) * 100, 2) as share,
        share_of_routes_ranked_first
    from
        {{ ref('int_top_route_share') }}
)
select 
    *
from
    data
where share != share_of_routes_ranked_first
