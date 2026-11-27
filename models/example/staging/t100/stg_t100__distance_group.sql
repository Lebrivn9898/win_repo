select 
    md5(code || description) as distance_grp_sk,
    CODE,
    DESCRIPTION as distance_group_description
FROM {{ source('t100', 'distance_group_type') }}
