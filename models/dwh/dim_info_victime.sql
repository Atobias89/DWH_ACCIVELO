{{
    config(
        materialized = 'incremental',
        unique_key = 'victime_identity',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at'],
        on_schema_change = 'append_new_columns'
    )
}}

select
       {{dbt_utils.generate_surrogate_key([
        'victime_id',
        'gravite_accident'
    ])}} as victime_identity,
    victime_id,
    gravite_accident,
    sexe,
    trajet_victime,
    equipement_securite,
    date_accident,
    created_at,
    updated_at
from {{ref('stg_info_victime')}}

 {%  if is_incremental() %}
    where date_accident > (select coalesce(max(date_accident), '1900-01-01') from {{this}})
{% endif %}