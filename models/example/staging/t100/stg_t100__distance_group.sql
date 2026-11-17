select 
    CODE,
    DESCRIPTION as distance_group_description
FROM {{ source('t100', 'distance_group_type') }}
