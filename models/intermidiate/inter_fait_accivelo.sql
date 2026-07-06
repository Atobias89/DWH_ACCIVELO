with info_accident as (
    select 
        accident_id,
        intersection,
        plan_route,
        count(*) nombre_accident_journaliere,
        sum( case when meteo = 'Normale' then 1 else 0 end) nombre_accident_meteo_normale,
        sum( case when meteo = 'Hors intersection' then 1 else 0 end) nombre_accident_hors_intersection,
        sum( case when circulation = 'Bidirectionnelle' then 1 else 0 end) nombre_accident_bidirectionelle,
        dd.ID_DATE date_identity,
        created_at,
        updated_at,
        num_acc
    from {{ref('stg_info_accident')}} sia
    inner join {{ref('dim_dates')}} dd on  CAST(dd.dates AS DATE) = CAST(sia.date_accident AS DATE)
    where updated_at >= current_date
    group by  accident_id,
              intersection,
              plan_route,  
              date_accident,
              date_identity,
              created_at,
              updated_at,
              num_acc
),
info_vehicule as (
      select 
        info_vehi_id,
        manoeuvre_vehicule_avant,       
        num_acc
    from {{ref('stg_info_vehicule')}}
    where updated_at >= current_date
   
),
info_victime as (
    select 
        victime_id,
        gravite_accident,
        sum( case when gravite_accident  = 'Tué' then 1 else 0 end) nombre_deces,
        sum( case when gravite_accident <> 'Tué' then 1 else 0 end) nombre_blesses,
        sum( case when sexe = 'Masculin' then 1 else 0 end) nombre_hommes_accidentes,
        sum( case when sexe = 'Féminin' then 1 else 0 end) nombre_femmes_accidentes,      
        num_acc
    from {{ref('stg_info_victime')}}
    where updated_at >= current_date
    group by  victime_id,  gravite_accident, num_acc

),
loc_accident as (
    select 
        loc_id,
        departement,
        "Num_Acc" num_acc
    from {{ref('stg_loc_accident')}}
    where updated_at >= current_date
)

select 
        {{ dbt_utils.generate_surrogate_key([
            'inf_acc.accident_id',
            'inf_acc.intersection',
            'inf_acc.plan_route'
        ]) }} as accident_identity,
	    {{dbt_utils.generate_surrogate_key([
          'inf_veh.info_vehi_id',
          'inf_veh.manoeuvre_vehicule_avant'
        ])}} as vehicule_identity,
	    {{dbt_utils.generate_surrogate_key([
             'inf_vic.victime_id',
             'inf_vic.gravite_accident'
        ])}} as victime_identity,
	      {{dbt_utils.generate_surrogate_key([
             'loc_acci.loc_id',
            'loc_acci.departement'
        ])}} as location_identity,
	    inf_acc.date_identity,	   	     
        inf_acc.nombre_accident_journaliere,
        inf_acc.nombre_accident_meteo_normale,
        inf_acc.nombre_accident_hors_intersection,
        inf_acc.nombre_accident_bidirectionelle,
        inf_vic.nombre_deces,
        inf_vic.nombre_blesses,
        inf_vic.nombre_hommes_accidentes,
        inf_vic.nombre_femmes_accidentes, 
        inf_acc.created_at,
        inf_acc.updated_at
from info_accident inf_acc
inner join  info_vehicule inf_veh on inf_veh.num_acc =  inf_acc.num_acc
inner join  info_victime  inf_vic on inf_veh.num_acc = inf_vic.num_acc
inner join  loc_accident loc_acci on inf_vic.num_acc =  loc_acci.num_acc