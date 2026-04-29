{{config (materialized='incremental',transient=false,alias='Silver_Stage',
schema='SILVER_SC',database='BRONZE_DB',tags=['bronze'])}}

select * from {{ source('raww', 'bronze_stage') }}
{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where UPDATED_AT > (select max(UPDATED_AT) from {{ this }}) 
{% endif %}