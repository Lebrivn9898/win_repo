select coeff_var
from {{ ref('int_stability_tbl') }}
