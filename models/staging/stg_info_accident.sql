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
        case 
          when int = 0 then 'Non renseigné'
          when int = 1 then 'Hors intersection'
          when int = 2 then 'Intersection en X'
          when int = 3 then 'Intersection en T'
          when int = 4 then 'Intersection en Y'
          when int = 5 then 'Intersection à plus de 4 branches'
          when int = 6 then 'Giratoire'
          when int = 7 then 'Place'
          when int = 8 then 'Passage à niveau'
          else  'Autre intersection'
        end as intersection,
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
        case
          when lum = 1 then 'Plein jour'
          when lum = 2 then 'Crépuscule ou aube'
          when lum = 3 then 'Nuit sans éclairage public'
          when lum = 4 then 'Nuit avec éclairage public non allumé'
          when lum = 5 then 'Nuit avec éclairage public allumé'
        end as luminosite,
        case 
           when atm = 1 then 'Normale'
           when atm = 2 then 'Pluie légère'
           when atm = 3 then 'Pluie forte'
           when atm = 4 then 'Neige - grêle'
           when atm = 5 then 'Brouillard - fumée'
           when atm = 6 then 'Vent fort - tempête'
           when atm = 7 then 'Temps éblouissant'
           when atm = 8 then 'Temps couvert'
           when atm = 9 then 'Autre'
           else 'Non renseigné'
       end as meteo,
        case 
          when catr  = 1 then 'Autoroute'
          when catr  = 2 then 'Route nationale'
          when catr  = 3 then 'Route départementale'
          when catr  = 4 then 'Voie communale'
          when catr  = 5 then 'Hors réseau public'
          when catr  = 6 then 'Parc de stationnement ouvert à la circulation publique'
          when catr =  7 then 'Routes de métropole urbaine'
          else 'Autre'
        end as categorie_accident,
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