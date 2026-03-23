{{
    config(
        materialized='incremental',transient=false
    )
}}

 select * from {{ source('raw', 'BRONZE_STAGE') }}
 {% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where CUSTOMER_ID > (select max(CUSTOMER_ID) from {{ this }}) 
 {% endif %}