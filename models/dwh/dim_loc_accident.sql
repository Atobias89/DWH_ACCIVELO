{{
    config(
        materialized = 'incremental',
        unique_key = 'location_identity',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at'],
        on_schema_change = 'append_new_columns'
    )
}}

select
    {{dbt_utils.generate_surrogate_key([
        'loc_id',
        'departement'
    ])}} as location_identity,
    loc_id,
    departement,
    commune,
    code_postal,
    lat,
    long,      
    created_at,
    updated_at
from {{ref('stg_loc_accident')}} 

{%  if is_incremental() %}
   where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{this}})
{% endif %}