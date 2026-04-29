{{ config(
    materialized='incremental',transient=false,
    unique_key='ORDER_ID',
    tags=['transform'],schema='Gold',database='BRONZE_DB',alias='Gold_Table'
) }}
 
SELECT
    ORDER_ID,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    PRODUCT_ID,
    PRODUCT_NAME,
    COALESCE(QUANTITY, 1) AS QUANTITY,
    COALESCE(PRICE, 0) AS PRICE,
    COALESCE(QUANTITY, 1) * COALESCE(PRICE, 0) AS TOTAL_AMOUNT,
    ORDER_DATE,
    UPDATED_AT,
   
    CASE
        WHEN CUSTOMER_ID IS NULL THEN 'REJECTED_NULL_CUSTOMER'
        WHEN ORDER_ID IS NULL THEN 'REJECTED_NULL_ORDER'
        WHEN COALESCE(QUANTITY, 1) <= 0 THEN 'INVALID_QUANTITY'
        WHEN COALESCE(PRICE, 0) < 0 THEN 'INVALID_PRICE'
        ELSE 'VALID'
    END AS RECORD_STATUS
FROM {{ ref('Bronze_to_silver') }}
WHERE ORDER_ID IS NOT NULL
  AND CUSTOMER_ID IS NOT NULL
{% if is_incremental() %}
  AND UPDATED_AT > (SELECT COALESCE(MAX(UPDATED_AT), '1900-01-01'::TIMESTAMP) FROM {{ this }})
{% endif %}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY ORDER_ID
    ORDER BY UPDATED_AT DESC
) = 1
 