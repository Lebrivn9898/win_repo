select
market.*,
case when service_class = 'F' then 'Scheduled Passenger/ Cargo Service F' else null end as service_class_description
from {{ ref('stg_t100__market') }} market