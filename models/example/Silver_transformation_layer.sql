{{config (materialized='table',transient=true)}}

select * from {{ ref('Silver') }}
where amount>0   and CUSTOMER_ID IS NOT NULL and CUSTOMER_NAME IS NOT NULL AND EMAIL IS NOT NULL  