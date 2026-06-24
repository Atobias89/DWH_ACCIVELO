{% macro stg_info_accident_meteo(col)%}
      case 
           when {{col}} = 1 then 'Normale'
           when {{col}} = 2 then 'Pluie légère'
           when {{col}} = 3 then 'Pluie forte'
           when {{col}} = 4 then 'Neige - grêle'
           when {{col}} = 5 then 'Brouillard - fumée'
           when {{col}} = 6 then 'Vent fort - tempête'
           when {{col}} = 7 then 'Temps éblouissant'
           when {{col}} = 8 then 'Temps couvert'
           when {{col}} = 9 then 'Autre'
           else 'Non renseigné'
       end
{% endmacro %}