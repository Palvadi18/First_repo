{%macro my_mac(args)%}
  {%set query%}
    create or replace table {{args}}(name varchar(50))
   {%endset%}
   {%do run_query(query)%}
{%endmacro%} 