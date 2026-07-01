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
    {{dbt_utils.generate_surrogate_key([
        'info_vehi_id',
        'manoeuvre_vehicule_avant'
    ])}} as vehicule_identity,
    info_vehi_id,
    manoeuvre_vehicule_avant,
    vehiculeid,
    typevehicules,
    num_vehicules,
    date_accident,
    created_at,
    updated_at
from {{ref('stg_info_vehicule')}}


{%  if is_incremental() %}
    where date_accident > (select coalesce(max(date_accident), '1900-01-01') from {{this}})
{% endif %}
