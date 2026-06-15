
{{
    config(
        materialized = 'incremental',
        unique_key = 'info_vehi_id',
        incremental_strategy = 'merge',
        merge_exclude_columns =['created_at']
    )
}}

with info_vehicule as(
    select 
  concat(vehiculeid,  row_number() over(partition by vehiculeid))  as info_vehi_id ,
 case	   
           when manv =  0   then 'Inconnue'
           when manv =  1   then 'Sans changement de direction'
           when manv =  2   then 'Même sens, même file'
           when manv =  3   then 'Entre 2 files'
           when manv =  4   then 'En marche arrière'
           when manv =  5   then 'A contresens'
           when manv =  6   then 'En franchissant le terre-plein central'
           when manv =  7   then 'Dans le couloir bus, dans le me sens'
           when manv =  8   then 'Dans le couloir bus, dans le sens inverse'
           when manv =  9   then 'En s insérant'
           when manv =  10  then 'En faisant demi-tour sur la chaussée'
           when manv =  11  then 'Changeant de file à gauche'
           when manv =  12  then 'Changeant de file à droite'
           when manv =  13  then 'Déporté à gauche'
           when manv =  14  then 'Déporté à droite'
           when manv =  15  then 'Tournant à gauche'
           when manv =  16  then 'Tournant à droite'
           when manv =  17  then 'Dépassant à gauche'
           when manv =  18  then 'Dépassant à droite'
           when manv =  19  then 'Traversant la chaussée'
           when manv =  20  then 'Manoeuvre de stationnement'
           when manv =  21  then 'Manoeuvre d évitemment'
           when manv =  22  then 'Ouverture de porte'
           when manv =  23  then 'Arrêté (horstationnement)'
           when manv =  24  then 'En stationnement (avec occupants)'
           when manv =  25  then 'Circulant sur troitoir'
           when manv =  26  then 'Autres manoeuvres'
           else   'Non renseigné'
        end manoeuvre_vehicule_avant,
        vehiculeid,
       case      
          when typevehicules =  '0'  then 'Indeterminable'
          when typevehicules =  '1'  then  'Bicyclette'
          when typevehicules =  '2'  then  'Cyclomoteur <50cm3'
          when typevehicules =  '3'  then  'Voiturette (Quadricycle à moteur carrossé) '
          when typevehicules =  '4'  then  'Scooter immatriculé'
          when typevehicules =  '5'  then  'Motocyclette'
          when typevehicules =  '6'  then  'Side car'
          when typevehicules =  '7'  then  'Vl seul'
          when typevehicules = '8'   then  'Vl + caravane'
          when typevehicules = '9'   then  'Vl + remorque'
          when typevehicules = '10'  then  'VU seul 1,5T <= PTAC <= 3,5T avec ou sans remorque'
          when typevehicules = '11'  then  'VU (10) + caravane'
          when typevehicules = '12'  then  'VU (10) + remorque'
          when typevehicules = '13'  then  'PL seul 3,5T <PTCA <= 7,5T'
          when typevehicules = '14'  then  'PL seul > 7,5T'
          when typevehicules = '15'  then  'PL > 3,5T + remorque'
          when typevehicules = '16'  then  'Tracteur routier seul'
          when typevehicules =  '17' then  'Tracteur routier + semi-remorque'
          when typevehicules = '18'  then  'Transport en commun'
          when typevehicules = '19'  then  'Tramway'
          when typevehicules =  '20' then  'Engin spécial'
          when typevehicules = '21'  then  'Tracteur agricole'
          when typevehicules = '30'  then  'Scooter < 50 cm3'
          when typevehicules =  '31' then  'Motocyclette > 50 cm3 et <= 125 cm3'
          when typevehicules =  '32' then  'Scooter > 50 cm3 et <= 125 cm3'
          when typevehicules = '33'  then  'Motocyclette > 125 cm3'
          when typevehicules =  '34' then  'Scooter > 125 cm3'
          when typevehicules =  '35' then  'Quad léger <= 50 cm3 (Quadricycle à moteur non carrossé)'
          when typevehicules =  '36' then  'Quad lourd > 50 cm3 (Quadricycle à moteur non carrossé)'
          when typevehicules =  '37' then  'Autobus'
          when typevehicules = '38'  then  'Autocar'
          when typevehicules = '39'  then  'Train'
          when typevehicules = '40'  then  'Tramway'
          when typevehicules = '41'  then   '3RM <= 50 cm3'
          when typevehicules = '42'  then  '3RM > 50 cm3 et <= 125 cm3'
          when typevehicules = '43'  then  '3RM > 125 cm3' 
          when typevehicules = '50'  then  'EDP à moteur'
          when typevehicules = '60'  then  'EDP sans moteur'
          when typevehicules = '80'  then  'VAE'
          else  'Autre véhicule'
        end  typevehicules, 
        'numVehicules',
        "_infos_commune.code_epci" info_commune,
        current_date as created_at,
        current_date as updated_at
    from 
    {{source('acci','information_vehicule')}} 
)


select * from info_vehicule

