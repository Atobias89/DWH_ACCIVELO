{% macro stg_info_accident_cat_acc(col)%}
     case 
          when {{col}}  = 1 then 'Autoroute'
          when {{col}}  = 2 then 'Route nationale'
          when {{col}}  = 3 then 'Route départementale'
          when {{col}}  = 4 then 'Voie communale'
          when {{col}}  = 5 then 'Hors réseau public'
          when {{col}}  = 6 then 'Parc de stationnement ouvert à la circulation publique'
          when {{col}} =  7 then 'Routes de métropole urbaine'
          else 'Autre'
        end 

{% endmacro %}