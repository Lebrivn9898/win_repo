select 
    string_field_0 as service_class,
    string_field_1 as service_class_description
FROM {{ source('t100', 'service_class_type') }}
WHERE string_field_0 != 'Code'