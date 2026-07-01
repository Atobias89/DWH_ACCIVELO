with info_accident as (
    select 
        accident_id,
        count(*) nombre_accident_journaliere,
        sum( case when meteo = 'Normale' then 1 else 0 end) nombre_accident_meteo_normale,
        sum( case when meteo = 'Hors intersection' then 1 else 0 end) nombre_accident_hors_intersection,
        sum( case when circulation = 'Bidirectionnelle' then 1 else 0 end) nombre_accident_bidirectionelle,
        date_accident,
        created_at,
        updated_at,
        num_acc
    from {{ref('stg_info_accident')}}
    where updated_at = current_date
    group by  accident_id,
              date_accident,
              created_at,
              updated_at,
              num_acc
),
info_vehicule as (
      select 
        info_vehi_id,       
        num_acc
    from {{ref('stg_info_vehicule')}}
    where updated_at = current_date
   
),
info_victime as (
    select 
        victime_id,
        sum( case when gravite_accident  = 'Tué' then 1 else 0 end) nombre_deces,
        sum( case when gravite_accident <> 'Tué' then 1 else 0 end) nombre_blesses,
        sum( case when sexe = 'Masculin' then 1 else 0 end) nombre_hommes_accidentes,
        sum( case when sexe = 'Féminin' then 1 else 0 end) nombre_femmes_accidentes,      
        num_acc
    from {{ref('stg_info_victime')}}
    where updated_at = current_date
    group by  victime_id, num_acc

),
loc_accident as (
    select 
        loc_id,
        departement,
        "Num_Acc" num_acc
    from {{ref('stg_loc_accident')}}

)

select 
	    inf_acc.accident_id,
	    inf_veh.info_vehi_id,
	    inf_vic.victime_id,
	    inf_acc.date_accident,   
	    loc_acci.loc_id,
        loc_acci.departement,	     
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