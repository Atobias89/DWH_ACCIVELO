
{{
    config(
        materialized = 'incremental',
        unique_key = ['accident_identity','vehicule_identity','victime_identity','location_identity','date_identity'],
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at']    
    )
}}




select 
        fait_accivelo.accident_identity,
        fait_accivelo.vehicule_identity, 
        fait_accivelo.victime_identity,
        fait_accivelo.location_identity,     
	    fait_accivelo.date_identity,
        fait_accivelo.nombre_accident_journaliere,
        fait_accivelo.nombre_accident_meteo_normale,
        fait_accivelo.nombre_accident_hors_intersection,
        fait_accivelo.nombre_accident_bidirectionelle,
        fait_accivelo.nombre_deces,
        fait_accivelo.nombre_blesses,
        fait_accivelo.nombre_hommes_accidentes,
        fait_accivelo.nombre_femmes_accidentes, 
        fait_accivelo.created_at,
        fait_accivelo.updated_at
from {{ref('inter_fait_accivelo')}} fait_accivelo

{%  if is_incremental() %}
   where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{this}})
{% endif %}