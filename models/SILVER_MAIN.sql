

{{ config(materialized='table', transient=false, alias='Customers') }}

select
    CUSTOMER_ID,
    ORDER_ID,
    sum(amount) as TotalSales,
    SPLIT_PART(EMAIL,'@',1) as EMAIL_USERNAME,STATUS,

    '@'||SPLIT_PART(EMAIL,'@',2) as EMAIL_DOMAIN
from {{ ref('Silver_transformation_layer') }}
group by
    CUSTOMER_ID,
    ORDER_ID,
    EMAIL,STATUS

