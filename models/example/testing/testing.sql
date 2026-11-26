select *
from {{ ref('int_scale_network_breadth') }} a
left join {{ ref('mart_org_airport_carrier_metrics') }} b
    on a.origin_airport_code = b.origin_airport_code
    and a.carrier_name = b.carrier_name
where a.origin_airport_code = 'SJC'
