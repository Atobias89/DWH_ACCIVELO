{{
    config(
        materialized= 'incremental',
        unique_key = 'victime_id',
        incremental_strategy = 'merge',
        merge_exclude_columns = ['created_at']
    )
}}

with victimes_info as (
    select 
      concat("Num_Acc", row_number() over(partition by "Num_Acc")) as victime_id,
    
     case 
          when grav = '1' then 'Indemne'
          when grav = '2' then 'Tué'
          when grav = '3' then 'Blessé hospitalisé'
          when grav = '4' then 'Blessé léger'
          else 'Non renseigné'
        end as gravite_accident,
        case 
          when sexe = 1 then 'Masculin'
          when sexe = 2 then 'Féminin'
        end as sexe,
         case
	        when trajet = 0 then 'Non renseigné'
            when trajet = 1 then 'Domicile - travail'
            when trajet = 2 then 'Domicile - école'
            when trajet = 3 then 'Courses - achats'
            when trajet = 4 then 'Utilisation professionnelle'
            when trajet = 5 then 'Promenade - loisirs'
            when trajet = 9 then 'Autre'
            else 'Non renseigné'
        end trajet_victime,
        case
               when equipement = '0' then 'Aucun équipement'
               when equipement = '1'then 'Ceinture'
               when equipement = '2'then 'Casque'
               when equipement = '3' then 'Dispositif enfants'
               when equipement = '4' then 'Gilet réfléchissant'
               when equipement = '5' then 'Airbag (2RM/3RM)'
               when equipement = '6' then 'Gants (2RM/3RM)'
               when equipement = '7' then 'Gants + Airbag (2RM/3RM)'
               when equipement = '8' then 'Non déterminable'
               when equipement = '9' then 'Autre'
               else 'Non renseigné'
        end as equipement_securite,
        "Num_Acc" as num_acc,
        "date" date_accident,
        cast(now() as date) as created_at,
        cast(now() as date) as updated_at
        from {{source('acci','information_victime')}}
 
)

select * from victimes_info


 {%  if is_incremental() %}
    where date_accident >= (select coalesce(max(date_accident), '1900-01-01') from {{this}})
{% endif %}

     