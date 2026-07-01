{{
    config(
        materialized = 'incremental',
        unique_key = 'loc_id',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at']
    )
}}


with loc_accident as(
    select 
        concat(loc."Num_Acc", row_number() over(partition by loc."Num_Acc"))  as loc_id,
        dep.nom departement,
        com.nom commune,
        com."codesPostaux" code_postal,
        loc.lat,
        loc.long,
        loc."Num_Acc",   
        "date" date_accident,  
        current_date created_at,
        current_date updated_at
    from {{source('acci','localisation_accident')}} loc
    left join {{source('acci','info_geo_departments')}} dep on dep.code = loc.dep
    left join {{source('acci','info_geo_communes')}} com on com."codeDepartement" = dep.code and com."codeRegion" = com."codeRegion"
)



select * from loc_accident

 {%  if is_incremental() %}
    where date_accident > (select coalesce(max(date_accident), '1900-01-01') from {{this}})
{% endif %}