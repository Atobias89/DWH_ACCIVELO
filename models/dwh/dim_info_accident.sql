{{
    config(
        materialized = 'incremental',
        unique_key = 'accident_identity',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at'],
        on_schema_change = 'append_new_columns'
    )
}}

select 
  {{ dbt_utils.generate_surrogate_key([
        'accident_id',
        'intersection',
        'plan_route'
    ]) }} as accident_identity,
    accident_id,
    intersection,
    coallision, 
    luminosite,
    meteo,
    categorie_accident,
    circulation,
    nombre_voies,
    profil_long_route,
    plan_route,    
    created_at,
    updated_at
from {{ref('stg_info_accident')}}


{%  if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{this}})
{% endif %}