{% macro stg_info_accident_luminosite(col)%}
      case
          when {{col}} = 1 then 'Plein jour'
          when {{col}} = 2 then 'Crépuscule ou aube'
          when {{col}} = 3 then 'Nuit sans éclairage public'
          when {{col}} = 4 then 'Nuit avec éclairage public non al{{col}}é'
          when {{col}} = 5 then 'Nuit avec éclairage public al{{col}}é'
        end
{% endmacro %}