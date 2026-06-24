{% macro stg_info_accident_intersection(col) %}
     case 
          when {{col}} = 0 then 'Non renseigné'
          when {{col}} = 1 then 'Hors intersection'
          when {{col}} = 2 then 'Intersection en X'
          when {{col}} = 3 then 'Intersection en T'
          when {{col}} = 4 then 'Intersection en Y'
          when {{col}} = 5 then 'Intersection à plus de 4 branches'
          when {{col}} = 6 then 'Giratoire'
          when {{col}} = 7 then 'Place'
          when {{col}} = 8 then 'Passage à niveau'
          else  'Autre intersection'
        end
{% endmacro %}