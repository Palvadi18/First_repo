{{config (materialized='table',transient=false,schema='MART',
database='BRONZE_DB',alias='MART_TABLE',tags=['gold'])}}


select ORDER_DATE,count(ORDER_ID) Total_Orders,COUNT(DISTINCT CUSTOMER_ID)TOTAL_CUSTOMERS,
SUM(QUANTITY) TOTAL_QNTY,SUM(PRICE) TOTAL_PRICE


 from {{ ref('silver_transformation') }}

 GROUP BY ORDER_DATE