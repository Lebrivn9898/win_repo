select 
    CARRIER_ID,
    CARRIER_CODE,
    CARRIER_NAME,
    CARRIER_GROUP,
    count(*) as count
FROM {{ ref('stg_t100__market') }}
GROUP BY 1, 2, 3, 4
ORDER BY carrier_name ASC