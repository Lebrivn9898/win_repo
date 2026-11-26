select 
    net_breadth.origin_airport_code,
    net_breadth.origin_city,
    net_breadth.carrier_name,
    net_breadth.carrier_passenger_share,
    net_breadth.cnt_distinct_dest,
    route_dep.top_route_passenger_share,
    top_route_sh.routes_ranked_first,
    top_route_sh.total_routes,
    top_route_sh.share_of_routes_ranked_first,
    stability.coeff_var,
    stability.months_active,
    stability.is_cv_eligible,
    growth.six_month_growth
from {{ ref('int_scale_network_breadth') }} net_breadth
join {{ ref('int_route_dependence') }} route_dep
    on route_dep.origin_airport_code = net_breadth.origin_airport_code
    and route_dep.carrier_name = net_breadth.carrier_name
join {{ ref('int_top_route_share') }} top_route_sh
    on top_route_sh.origin_airport_code = net_breadth.origin_airport_code
    and top_route_sh.carrier_name = net_breadth.carrier_name
join {{ ref('int_stability_tbl') }} stability
    on stability.origin_airport_code = net_breadth.origin_airport_code
    and stability.carrier_name = net_breadth.carrier_name
join {{ ref('int_growth_trailing_tbl') }} growth
    on growth.origin_airport_code = net_breadth.origin_airport_code
    and growth.carrier_name = net_breadth.carrier_name

