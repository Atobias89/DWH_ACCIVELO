 {{
    config(
        materialized = 'incremental',
        unique_key = 'accident_id',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at']
    )
 }}

 with info_accident as (
    select 
        concat("Num_Acc", row_number() over(partition by "Num_Acc")) as accident_id,
        {{stg_info_accident_intersection('int')}} as intersection,
           case
          when  col = 1 then 'Deux véhicules - frontale'
          when  col = 2 then 'Deux véhicules - par l arrière'
          when  col = 3 then 'Deux véhicules - par le côté'
          when  col = 4 then 'Trois véhicules et plus - en chaîne'
          when  col = 5 then 'Trois véhicules et plus - collisions multiples'
          when  col = 6 then 'Autre collision'
          when  col = 7 then 'Sans collision'
          else  'Non renseigné'
        end coallision,
        {{stg_info_accident_luminosite('lum')}} as luminosite,  
       {{ stg_info_accident_meteo('atm')}} as meteo,
       {{stg_info_accident_cat_acc('catr')}} as categorie_accident,

        case 
            when circ = 1 then 'A sens unique'
            when circ = 2 then 'Bidirectionnelle'
            when circ = 3 then 'A chaussées séparées'
            when circ = 4 then 'Avec voies d affectation variable'
            else 'Non renseigné'
         end as circulation,
         nbv as nombre_voies,
        case
           when prof = 1 then 'Plat'
           when prof = 2 then 'Pente'
           when prof = 3 then 'Sommet de côte'
           when prof = 4 then 'Bas de côte'
           else  'Non renseigné'
         end as profil_long_route,
        case 
          when plan = 1 then 'Partie rectiligne'
          when plan = 2 then 'En courbe à gauche'
          when plan = 3 then 'En courbe à droite'
          when plan = 4 then  'En «S»'
          else 'Non renseigné'
        end  plan_route,
        "Num_Acc" as num_acc,
        current_date as created_at,
        current_date as updated_at   
      from {{source('acci','information_accident')}}
 )


 select  * from info_accident    

 {%  if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{this}})
{% endif %}