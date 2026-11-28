select *
from {{ ref('int_stability_tbl') }}
where coeff_var IS NULL