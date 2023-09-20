{{
    config(
        materialized='incremental',
        unique_key='invoice_line_hash'
    )
}}

WITH dim_sales AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

proxy AS (
    SELECT
        invoice_line_hash,
        state_bottle_cost,
        state_bottle_retail,
        sale_bottles,
        sale_dollars,
        sale_liters,
        sale_gallons
    FROM dim_sales
    {{ check_incremental('invoice_line_hash') }}
)

SELECT * FROM proxy
